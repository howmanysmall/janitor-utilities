--!optimize 2
--!strict
--[[
	Wraps `wally install` with type exports in link files.

	Roughly equivalent to wally-package-types, but with support for generics
	with defaults and some support for WaitForChild require paths.
--]]

--[=[ lunar
	about = "Does the same thing that wally-package-types does, but better and in Luau."
]=]

local WallyPackageTypes = require("@utilities/WallyPackageTypes")
WallyPackageTypes()

--hyperfine "lune run wally-package-types" "lunar wally-package-types" "wally-package-types --sourcemap sourcemap.json Packages/" --prepare="rm -rf packages && cp -a UntouchedPackages Packages && rojo sourcemap --output sourcemap.json default.project.json" --cleanup="rm -rf packages" --warmup=8 -i
