--[[
getgenv().xp_dashboard = {
    ["VPS"] = "VPS-1"
}
]]

local pc_name = getgenv().xp_dashboard.VPS
local function get_username()
    local username = tostring(game:GetService("Players").LocalPlayer.Name)
    return username
end
local function get_bucks()
    local bucks = tostring(require(game.ReplicatedStorage:WaitForChild("Fsys")).load("ClientData").get(
        "money"))
    return bucks
end
local function get_potions()
    local potions = 0
    for i, v in pairs(require(game.ReplicatedStorage.ClientModules.Core.ClientData).get_data()[game.Players.LocalPlayer.Name].inventory.food) do
        if v.kind == "pet_age_potion" then
            potions = potions + 1
        end
    end
    return tostring(potions)
end
local function get_event()
    local event = tostring(require(game.ReplicatedStorage:WaitForChild("Fsys")).load("ClientData").get(
        "galactic_shards_2024"))
    return event
end
local function send_stats()
    local url = "http://37.221.127.4:8000/update_user"
    url = url .. "?pc=" .. game:GetService("HttpService"):UrlEncode(pc_name)
        .. "&username=" .. game:GetService("HttpService"):UrlEncode(get_username())
        .. "&bucks=" .. game:GetService("HttpService"):UrlEncode(get_bucks())
        .. "&potions=" .. game:GetService("HttpService"):UrlEncode(get_potions())
        .. "&event=" .. game:GetService("HttpService"):UrlEncode(get_event())

    print("URL being sent: ", url)
    local success, response = pcall(function()
        return game:HttpGetAsync(url)
    end)

    if success then
        print("Data Received: " .. response)
    else
        print("Error sending GET request: " .. response)
    end
end
while true do
    send_stats()
    task.wait(600)
end
