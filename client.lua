local VORPmenu = exports.vorp_menu:GetMenu()
local showOverlay = false
local timeUntilReward = "Ready to Claim!"

RegisterCommand('rewards', function() TriggerServerEvent('my_mod:requestMenuStatus') end)
RegisterCommand('toggleoverlay', function() showOverlay = not showOverlay end)

RegisterNetEvent('my_mod:updateOverlay')
AddEventHandler('my_mod:updateOverlay', function(newTime) timeUntilReward = newTime end)

RegisterNetEvent('my_mod:openMenuWithStatus')
AddEventHandler('my_mod:openMenuWithStatus', function(isVIP, isAdmin)
    VORPmenu.CloseAll()
    local menu = VORPmenu.CreateMenu(isVIP and "⭐ VIP Rewards" or "Standard Rewards", 'Main Office')
    menu.addButton('Claim Daily Reward', 'Get your daily gift', function() TriggerServerEvent('my_mod:claimDaily') end)
    for _, data in ipairs(Config.Investments) do
        menu.addButton(data.label, "Cost: $"..data.cost, function() TriggerServerEvent('my_mod:startInvestment', data.cost, data.time) end)
    end
    if isAdmin then
        menu.addButton('~o~Admin: Reset My Timer', 'Reset your cooldown', function() TriggerServerEvent('my_mod:adminResetSelf') end)
    end
    menu.Display()
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if showOverlay then
            SetTextScale(0.35, 0.35)
            DisplayText(CreateVarString(10, "LITERAL_STRING", "Daily Reward Status: " .. timeUntilReward), 0.8, 0.9)
        end
    end
end)