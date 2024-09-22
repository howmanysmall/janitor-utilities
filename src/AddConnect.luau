--!optimize 2
--!strict

local Connect = require(script.Parent.Utilities.Connect)
local JanitorPackage = require(script.Parent.Janitor)

type ConnectionLike = {
	Disconnect: (self: any) -> (),
	[any]: any,
}
type SignalLike<A...> = {
	Connect: nil | (self: SignalLike<A...>, callback: (A...) -> ()) -> ConnectionLike,
	[any]: any,
}
type SignalLikeCamel<A...> = {
	connect: (self: SignalLikeCamel<A...>, callback: (A...) -> ()) -> ConnectionLike,
	[any]: any,
}

--[=[
	Connects a callback to a signal and adds the returned connection to the
	Janitor.

	### Luau:

	```lua
	local obliterator = Janitor.new()
	JanitorUtilities.AddConnect(obliterator, script.ChildAdded, function(child)
	end)
	```

	### TypeScript:

	```ts
	import { Janitor } from "@rbxts/janitor";
	import JanitorUtilities from "@rbxts/janitor-utilities";

	const obliterator = new Janitor();
	JanitorUtilities.AddConnect(obliterator, script.ChildAdded, (child) => {});
	```

	@function AddConnect
	@within JanitorUtilities
	
	@param janitor Janitor -- The Janitor to add the connection to.
	@param signal Connectable -- The signal to connect to.
	@param callback (A...) -> () -- The callback to connect.
	@param index? unknown -- The index that can be used to clean up the
	connection manually.
	@return ConnectionLike -- The connection that was added.
]=]
local function AddConnect<A...>(
	janitor: JanitorPackage.Janitor,
	signal: RBXScriptSignal<A...> | SignalLike<A...> | SignalLikeCamel<A...>,
	callback: (A...) -> (),
	index: unknown?
): ConnectionLike
	return janitor:Add(Connect(signal, callback), "Disconnect", index)
end

return AddConnect
