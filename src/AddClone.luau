--!optimize 2
--!strict

local JanitorPackage = require(script.Parent.Janitor)

--[=[
	Clones an Instance and adds it to the Janitor.

	### Luau:

	```lua
	local obliterator = Janitor.new()
	local newPart = JanitorUtilities.AddClone(obliterator, Instance.new("Part"))
	```

	### TypeScript:

	```ts
	import { Janitor } from "@rbxts/janitor";
	import JanitorUtilities from "@rbxts/janitor-utilities";

	const obliterator = new Janitor();
	const newPart = JanitorUtilities.AddClone(obliterator, new Instance("Part"));
	```

	@function AddClone
	@within JanitorUtilities

	@param janitor Janitor -- The Janitor to add the object to.
	@param object Instance -- The Instance to clone.
	@param methodName? string -- The name of the method that will be used to clean up. If not passed, it will first check if the object's type exists in TypeDefaults, and if that doesn't exist, it assumes `Destroy`.
	@param index? unknown -- The index that can be used to clean up the object manually.
	@param ... A... -- The arguments that will be passed to the constructor.
	@return T -- The constructed object.
]=]
local function AddClone<T>(janitor: JanitorPackage.Janitor, object: T & Instance, methodName: string?, index: unknown?): T
	return janitor:Add(object:Clone(), methodName, index)
end

return AddClone
