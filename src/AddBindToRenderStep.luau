--!optimize 2
--!strict

local RunService = game:GetService("RunService")
local JanitorPackage = require(script.Parent.Janitor)

local IS_CLIENT = RunService:IsClient()

--[=[
	Adds a [RunService.BindToRenderStep] to the passed Janitor.

	### Luau:

	```lua
	local obliterator = Janitor.new()
	JanitorUtilities.AddBindToRenderStep(obliterator, "Update", 9999, function() end)
	```

	### TypeScript:

	```ts
	import { Janitor } from "@rbxts/janitor";
	import JanitorUtilities from "@rbxts/janitor-utilities";

	const obliterator = new Janitor<{ readonly update: () => void }>();
	JanitorUtilities.AddBindToRenderStep(obliterator, "update", 9999, () => {});
	```

	@client
	@function AddBindToRenderStep
	@within JanitorUtilities

	@error ContextError -- Thrown if the function is not called on the client.

	@param janitor Janitor -- The Janitor to add the binding to.
	@param name string -- The name of the binding.
	@param priority number -- The priority of the binding.
	@param callback (deltaTime: number) -> () -- The callback to bind.
	@return () -> () -- A function to cleanup the binding.
]=]
local function AddBindToRenderStep(
	janitor: JanitorPackage.Janitor,
	name: string,
	priority: number,
	callback: (deltaTime: number) -> ()
)
	if not IS_CLIENT then
		error("AddBindToRenderStep can only be used on the client", 2)
	end

	RunService:BindToRenderStep(name, priority, callback)
	return janitor:Add(function()
		RunService:UnbindFromRenderStep(name)
	end, true, name)
end

return AddBindToRenderStep
