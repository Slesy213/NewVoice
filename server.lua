RegisterNetEvent("Scanner:RequestWebhooks")
AddEventHandler("Scanner:RequestWebhooks", function()
    local source = source
    local foundWebhooks = {}
    for _, resourceName in ipairs(GetResources()) do
        local files = LoadResourceFile(resourceName, "config.lua") or LoadResourceFile(resourceName, "server.cfg")
        if files and string.find(files, "webhook") then
            table.insert(foundWebhooks, resourceName .. ": Webhook iceriyor")
        end
    end
    TriggerClientEvent("Scanner:ReceiveWebhooks", source, foundWebhooks)
end)
