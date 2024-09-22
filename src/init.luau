--!optimize 2
--!strict

for _, child in script:GetChildren() do
	if child:IsA("ModuleScript") then
		_G[child] = _G[script]
	end
end

local AddBindToRenderStep = require(script.AddBindToRenderStep)
local AddClone = require(script.AddClone)
local AddConnect = require(script.AddConnect)
local AddNewJanitor = require(script.AddNewJanitor)
local AddObject = require(script.AddObject)
local Janitor = require(script.Janitor)

--[=[
	A bunch of utilities to deal with Janitors.
	@class JanitorUtilities
]=]
local JanitorUtilities = table.freeze({
	AddBindToRenderStep = AddBindToRenderStep;
	AddClone = AddClone;
	AddConnect = AddConnect;
	AddNewJanitor = AddNewJanitor;
	AddObject = AddObject;
	Janitor = Janitor;
})

--[=[
	A pointer to the [Janitor](https://howmanysmall.github.io/Janitor/api/Janitor) class.
	@readonly
	@prop Janitor Janitor
	@within JanitorUtilities
]=]

export type Janitor = Janitor.Janitor

return JanitorUtilities
