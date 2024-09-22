--!optimize 2
--!strict

local DISCONNECTABLE = {
	Disconnect = function() end;
}

local function Connect(event: any, callback: (...any) -> ())
	local pascalConnect = event.Connect
	if type(pascalConnect) == "function" then
		assert(type(pascalConnect) == "function", `event {event}.Connect is not a function`)
		return pascalConnect(event, callback)
	end

	local camelConnect = event.connect
	if type(camelConnect) == "function" then
		assert(type(camelConnect) == "function", `event {event}.connect is not a function`)
		return camelConnect(event, callback)
	end

	return DISCONNECTABLE
end

return Connect
