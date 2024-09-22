--!optimize 2
--!strict

local JanitorPackage = require(script.Parent.Janitor)
local Janitor = JanitorPackage.Janitor

--[=[
	Adds a new sub-Janitor to the passed Janitor.

	### Luau:

	```lua
	local obliterator = Janitor.new()
	local subObliterator = JanitorUtilities.AddNewJanitor(obliterator)
	-- subObliterator is another Janitor!
	```

	### TypeScript:

	```ts
	import { Janitor } from "@rbxts/janitor";
	import JanitorUtilities from "@rbxts/janitor-utilities";

	const obliterator = new Janitor();
	const subObliterator = JanitorUtilities.AddNewJanitor(obliterator);
	```

	@function AddNewJanitor
	@within JanitorUtilities

	@param janitor Janitor -- The Janitor to create a new Janitor in.
	@param index? unknown -- The index that can be used to clean up the Janitor manually.
	@return Janitor -- The new Janitor.
]=]
local function AddNewJanitor(janitor: JanitorPackage.Janitor, index: unknown?)
	return janitor:Add(Janitor.new(), "Cleanup", index)
end

return AddNewJanitor
