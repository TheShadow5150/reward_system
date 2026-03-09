Config = {}

Config.VIPPlayers = { "steam:1100001xxxxxxxx" }
Config.AdminPlayers = { "steam:1100001xxxxxxxx" }

Config.DailyRewards = {
    { item = "bread", amount = 5, label = "5x Pieces of Bread", chance = 40 },
    { item = "gold_nugget", amount = 1, label = "1x Gold Nugget", chance = 20 },
    { cash = 50, label = "$50 Cash", chance = 40 }
}

Config.VIPDailyRewards = {
    { item = "gold_ingot", amount = 1, label = "1x Gold Ingot", chance = 50 },
    { cash = 500, label = "$500 Cash", chance = 50 }
}

Config.Investments = {
    { label = "Small Investment ($100)", cost = 100, time = 120, multiplier = 2.0 }
}

Config.StreakReward = { days = 7, item = "gold_ingot", amount = 1, cash = 500, label = "7-Day Bonus ($500 + Gold Ingot)" }
Config.VIPStreakReward = { days = 7, item = "diamond", amount = 2, cash = 2000, label = "VIP 7-Day Legend Bonus ($2000 + 2x Diamonds)" }