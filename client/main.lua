ESX	= nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(250)
	end
end)

-- Create Enter / Exit Markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		DrawMarker(25, Config.Position.x, Config.Position.y, Config.Position.z - 0.98, 
		0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 0, 255, 0, 155, false, true, 2, nil, nil, false)
	end
end)

-- Check the distance from the markers
Citizen.CreateThread(function()
	while not NetworkIsSessionStarted() do -- Wait for the user to load
		Wait(500)
	end

	while true do
		Citizen.Wait(1)
		local coords = GetEntityCoords(PlayerPedId())
		-- Check how close the player is to the marker location
		while #(GetEntityCoords(PlayerPedId()) - Config.Position) <= 1.0 do
			Citizen.Wait(0) -- REQUIRED

			-- Draw text with instructions
			ESX.Game.Utils.DrawText3D(Config.Position, "Press ~b~[E]~s~ to buy or sell tokens")

			-- Check for button press
			if IsControlJustReleased(0, 51) then
				-- Open menu is the button is pressed
				OpenMenu()

				-- Wait for menu control
				while ESX.UI.Menu.IsOpen("default", GetCurrentResourceName(), "general_menu") do
					Wait(50)
				end
			end
		end
	end
end)

--Opens the purchase menu
function OpenMenu()
	ESX.UI.Menu.CloseAll()

	local options = {
		{label = "Buy 1 Token", value = 'buy_one'},
		{label = "Buy 10 Tokens", value = 'buy_ten'},
		{label = "Buy 100 Tokens", value = 'buy_one_hundred'},
		{label = "Sell All Token", value = 'sell_all'},
		{label = "Sell 1 Token", value = 'sell_one'},
		{label = "Sell 10 Tokens", value = 'sell_ten'},
		{label = "Sell 100 Tokens", value = 'sell_one_hundred'}
	}
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'general_menu', {
		title = "Casino Tokens",
		align = "center",
		elements = options
	}, function(data, menu)
		
		-- Buy Tokens
		if data.current.value == "buy_one" then
			TriggerServerEvent('esx_CasinoTokenShop:BuyTokens', 1)
		elseif data.current.value == "buy_ten" then
			TriggerServerEvent('esx_CasinoTokenShop:BuyTokens', 10)
		elseif data.current.value == "buy_one_hundred" then
			TriggerServerEvent('esx_CasinoTokenShop:BuyTokens', 100)
		end

		-- Sell Tokens
		if data.current.value == "sell_one" then
			TriggerServerEvent('esx_CasinoTokenShop:SellTokens', 1)
		elseif data.current.value == "sell_ten" then
			TriggerServerEvent('esx_CasinoTokenShop:SellTokens', 10)
		elseif data.current.value == "sell_one_hundred" then
			TriggerServerEvent('esx_CasinoTokenShop:SellTokens', 100)
		elseif data.current.value == "sell_all" then
			TriggerServerEvent('esx_CasinoTokenShop:SellAllTokens')
		end

	end,
	function(data, menu)
		menu.close()
	end)
end