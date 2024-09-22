--!nocheck
--!nolint
--!optimize 2

local Types = require(script.Parent.Types)
local Packages = script.Parent.Parent

local WallyJanitor = Packages:FindFirstChild("Janitor")

export type JanitorStatic = typeof(require(script.Parent.Parent.Janitor))
export type Janitor = Types.Janitor

if WallyJanitor then
	return table.freeze({
		Janitor = require(WallyJanitor) :: JanitorStatic;
	})
end

local TS = _G[script.Parent]
local Janitor = TS.import(script.Parent, TS.getModule(script.Parent, "@rbxts", "janitor").src).Janitor :: JanitorStatic
return table.freeze({
	Janitor = Janitor;
})
