--!optimize 2
--!strict

local JanitorPackage = require(script.Parent.Janitor)

--[=[
	Constructs an object for you and adds it to the Janitor. It's really just
	shorthand for `Janitor:Add(object.new(), methodName, index)`. This did
	originally exist as part of Janitor's API, but it has since been removed
	in favor of this library.

	### Luau:

	```lua
	local obliterator = Janitor.new()
	local subObliterator = JanitorUtilities.AddObject(obliterator, Janitor, "Destroy")
	-- subObliterator is another Janitor!
	```

	### TypeScript:

	```ts
	import { Janitor } from "@rbxts/janitor";
	import JanitorUtilities from "@rbxts/janitor-utilities";

	const obliterator = new Janitor();
	const subObliterator = JanitorUtilities.AddObject(obliterator, Janitor, "Destroy");
	```

	@function AddObject
	@within JanitorUtilities

	@param janitor Janitor -- The Janitor to add the object to.
	@param constructor {new: (A...) -> T} -- The constructor for the object you want to add to the Janitor.
	@param methodName? boolean | string -- The name of the method that will be used to clean up. If not passed, it will first check if the object's type exists in TypeDefaults, and if that doesn't exist, it assumes `Destroy`.
	@param index? unknown -- The index that can be used to clean up the object manually.
	@param ... A... -- The arguments that will be passed to the constructor.
	@return T -- The constructed object.
]=]
local function AddObject<T, A...>(
	janitor: JanitorPackage.Janitor,
	constructor: {new: (A...) -> T},
	methodName: boolean | nil | string,
	index: unknown?,
	...: A...
)
	return janitor:Add(constructor.new(...), methodName, index)
end

return AddObject
