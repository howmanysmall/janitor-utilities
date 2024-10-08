--!optimize 2
--!strict

local Debug = require("@packages/Debug")
local PathFileSystem = require("@packages/PathFileSystem")

local FileSystemUtilities = {}
local Path = PathFileSystem.Path

local function AsPathToString(asPath: PathFileSystem.AsPath): string
	if type(asPath) == "string" then
		return asPath
	end

	return Path.from(asPath):toString()
end
local function _AsStringToPath(asString: PathFileSystem.AsPath): PathFileSystem.Path
	if type(asString) == "string" then
		return Path.new(asString)
	end

	if Path.is(asString) then
		return asString :: PathFileSystem.Path
	end

	return Path.from(asString)
end

local function GetFileDescendants(directoryPath: PathFileSystem.AsPath)
	local contents = PathFileSystem.ReadDirectory(directoryPath)
	if not contents then
		return {}
	end

	local descendants = {}
	local length = 0
	for _, filePath in contents do
		local childPath = AsPathToString(directoryPath) .. "/" .. filePath
		if PathFileSystem.IsDirectory(childPath) then
			for _, descendant in GetFileDescendants(childPath) do
				length += 1
				descendants[length] = descendant
			end
		else
			length += 1
			descendants[length] = childPath
		end
	end

	return descendants
end
FileSystemUtilities.GetFileDescendants = GetFileDescendants

function FileSystemUtilities.FindFirstFileOfExtension(directoryPath: PathFileSystem.AsPath, extension: string): string?
	if not PathFileSystem.IsDirectory(directoryPath) then
		return nil
	end

	if string.byte(extension, 1) ~= 46 then
		extension = "." .. extension
	end

	extension = `{Debug.EscapeString(extension)}$`
	for _, filePath in PathFileSystem.ReadDirectory(directoryPath) do
		if not PathFileSystem.IsFile(filePath) then
			continue
		end

		if string.match(filePath, extension) then
			return filePath
		end
	end

	return nil
end
function FileSystemUtilities.FindFirstFileOfExtensionPath(
	directoryPath: PathFileSystem.AsPath,
	extension: string
): PathFileSystem.Path?
	if not PathFileSystem.IsDirectory(directoryPath) then
		return nil
	end

	if string.byte(extension, 1) ~= 46 then
		extension = "." .. extension
	end

	extension = `{Debug.EscapeString(extension)}$`
	for _, filePath in PathFileSystem.ReadDirectory(directoryPath) do
		if not PathFileSystem.IsFile(filePath) then
			continue
		end

		if string.match(filePath, extension) then
			return Path.new(filePath)
		end
	end

	return nil
end

function FileSystemUtilities.JustFileName(path: PathFileSystem.AsPath)
	local castPath = AsPathToString(path)
	return string.match(string.match(castPath, "^(.+)%..+$") or castPath, "([^\\/]+)$") or castPath
end
function FileSystemUtilities.JustFileNameWithExtension(path: PathFileSystem.AsPath)
	local castPath = AsPathToString(path)
	return string.match(castPath, "([^\\/]+)$") or castPath
end

local function WithoutExtension(path: PathFileSystem.AsPath): string
	local castPath = AsPathToString(path)
	return string.match(castPath, "^(.+)%..+$") or castPath
end
FileSystemUtilities.WithoutExtension = WithoutExtension

local function GetExtension(path: PathFileSystem.AsPath): string?
	return string.match(AsPathToString(path), "%.([^%.]+)$")
end
FileSystemUtilities.GetExtension = GetExtension

type CreatorFunction = (path: PathFileSystem.AsPath, contents: string?) -> ()
type SafeCreate =
	((name: PathFileSystem.AsPath, fileType: "File", contents: string) -> string)
	& ((name: PathFileSystem.AsPath, fileType: "Directory") -> string)

local function GetNewFilePath(withoutExtension: string, index: number, extension: string?): string
	return if extension then `{withoutExtension} ({index}).{extension}` else `{withoutExtension} ({index})`
end

local function SafeCreate(name: PathFileSystem.AsPath, fileType: "File" | "Directory", contents: string?)
	local checkerFunction: typeof(PathFileSystem.IsDirectory) = if fileType == "File"
		then PathFileSystem.IsFile
		else PathFileSystem.IsDirectory

	local creatorFunction = (
		if fileType == "File" then PathFileSystem.WriteFile else PathFileSystem.WriteDirectory
	) :: CreatorFunction

	if not checkerFunction(name) then
		creatorFunction(name, contents)
		return name
	end

	local withoutExtension = WithoutExtension(name)
	local extension = GetExtension(name)
	local index = 1

	local newFilePath = GetNewFilePath(withoutExtension, index, extension)
	while checkerFunction(newFilePath) do
		index += 1
		newFilePath = GetNewFilePath(withoutExtension, index, extension)
	end

	creatorFunction(newFilePath, contents)
	return newFilePath
end
FileSystemUtilities.SafeCreate = SafeCreate

local function GetOrCreateDirectory(name: PathFileSystem.AsPath)
	if not PathFileSystem.IsDirectory(name) then
		SafeCreate(name, "Directory")
	end
end
FileSystemUtilities.GetOrCreateDirectory = GetOrCreateDirectory

function FileSystemUtilities.RecursivelyCreateDirectory(path: PathFileSystem.AsPath)
	for _, component in string.split(AsPathToString(path), PathFileSystem.PathSeparator) do
		PathFileSystem.WriteDirectory(component)
	end
end

return table.freeze(FileSystemUtilities)
