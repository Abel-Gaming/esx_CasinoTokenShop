ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_CasinoTokenShop:BuyTokens')
AddEventHandler('esx_CasinoTokenShop:BuyTokens', function(tokens)
	-- Get the player
	local xPlayer = ESX.GetPlayerFromId(source)

	-- Calculate the total cost
	local Cost = tokens * Config.TokenPurchasePrice

	-- Get the player money
	local PlayerMoney = xPlayer.getMoney()

	-- Check if the player has enough cash
	if PlayerMoney >= Cost then
		xPlayer.removeMoney(Cost)
		xPlayer.addInventoryItem(Config.CasinoTokenItem, tokens)
		if Config.UseSWTNotifications then
			TriggerClientEvent("swt_notifications:Success", source, 'Tokens Purchased', 'You have purchased ' .. tokens .. ' tokens!', 'left', 5000, true)
		else
			-- IMPLEMENT YOUR OWN NOTIFICATIONS HERE
		end
	else 
		if Config.UseSWTNotifications then
			TriggerClientEvent("swt_notifications:Negative", source, 'Not Enough Money', 'You do not have enough money to purchase ' .. tokens .. ' tokens!', 'left', 5000, true)
		else
			-- IMPLEMENT YOUR OWN NOTIFICATIONS HERE
		end
	end
end)

RegisterNetEvent("esx_CasinoTokenShop:SellTokens")
AddEventHandler("esx_CasinoTokenShop:SellTokens", function(tokens)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getInventoryItem(Config.CasinoTokenItem).count >= tokens then
		xPlayer.removeInventoryItem(Config.CasinoTokenItem, tokens) -- Removes item
		xPlayer.addAccountMoney('money', tokens * Config.TokenSellPrice) -- Adds the money
		
		-- Notify the player
		local caption = 'Tokens Sold'
		local message = 'You sold ' .. tokens .. ' to the casino for $' .. tokens * Config.TokenSellPrice
		local position = 'right'
		local timeout = 5000
		local progress = true
		if Config.UseSWTNotifications then
			TriggerClientEvent("swt_notifications:Success", source, caption, message, position, timeout, progress)
		else
			-- IMPLEMENT YOUR OWN NOTIFICATIONS HERE
		end
	else
		local caption = 'Error'
		local message = 'You do not that many tokens to sell!'
		local position = 'right'
		local timeout = 5000
		local progress = true
		if Config.UseSWTNotifications then
			TriggerClientEvent("swt_notifications:Negative", source, caption, message, position, timeout, progress)
		else
			-- IMPLEMENT YOUR OWN NOTIFICATIONS HERE
		end
	end
end)

RegisterServerEvent('esx_CasinoTokenShop:SellAllTokens')
AddEventHandler('esx_CasinoTokenShop:SellAllTokens', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getInventoryItem(Config.CasinoTokenItem).count >= 1 then
		local itemCount = xPlayer.getInventoryItem(Config.CasinoTokenItem).count
		
		xPlayer.removeInventoryItem(Config.CasinoTokenItem, itemCount) -- Removes item
		
		xPlayer.addAccountMoney('money', Config.TokenSellPrice * itemCount) -- Adds the money
		
		-- Notify the player
		local caption = 'Tokens Sold'
		local message = 'You sold ' .. itemCount .. ' tokens to the casino for $' .. itemCount * Config.TokenSellPrice
		local position = 'top'
		local timeout = 5000
		local progress = true
		if Config.UseSWTNotifications then
			TriggerClientEvent("swt_notifications:Success", source, caption, message, position, timeout, progress)
		else
			-- IMPLEMENT YOUR OWN NOTIFICATIONS HERE
		end
	else
		
		local caption = 'Error'
		local message = 'You do not have any tokens to sell!'
		local position = 'top'
		local timeout = 5000
		local progress = true
		if Config.UseSWTNotifications then
			TriggerClientEvent("swt_notifications:Negative", source, caption, message, position, timeout, progress)
		else
			-- IMPLEMENT YOUR OWN NOTIFICATIONS HERE
		end
	end
end)