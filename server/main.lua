ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

RegisterServerEvent('esx_vehicleseller:getprice')
AddEventHandler('esx_vehicleseller:getprice', function(vehicle)
	local owner = GetPlayerIdentifiers(source)[1]
	local model = tostring(vehicle.model)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM user_vehicle WHERE owner = @owner AND model = @model', {['@owner'] = owner, ['@model'] = model}, function(result)
			if result[1]['owner'] ~= nil then
				local price = (result[1].price)
				local sellprice = price / 2
				local data = {
				owner = result[1]['identifier'],
				model = result[1]['model'],
				name = result[1]['name'],
				price = result[1]['price'],
				}
				MySQL.Async.execute('DELETE FROM user_vehicle WHERE owner = @owner AND model = @model',{['@owner'] = owner, ['@model'] = model}, function(result2)
				end)
				xPlayer.addBank(sellprice)
				local balance = xPlayer.getBank()
				local source2 = xPlayer.source
				TriggerClientEvent('banking:updateBalance', source2, balance)
			end
	end)
end)

RegisterServerEvent('esx_vehicleseller:checkifowner')
AddEventHandler('esx_vehicleseller:checkifowner', function(vehicle)

    local identifiers = GetPlayerIdentifiers(source)
    local currentSource = source
	local model = tostring(vehicle.model)
	    MySQL.Async.fetchAll("SELECT * FROM user_vehicle WHERE owner=@owner AND model=@model ORDER BY name ASC LIMIT 1", {['@owner'] = identifiers[1], ['@model'] =  model}, function(vehicle)
	        if vehicle[1] then
	            TriggerClientEvent('esx_vehicleseller:checkifowner_fromdb', currentSource, true)
	        else

	            TriggerClientEvent('esx_vehicleseller:checkifowner_fromdb', currentSource, false)
	        end
	    end)
end)

function SendNotification(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(false, false)
end