# Greater Blessing of Suppression

A World of Warcraft Wrath of the Lich King (WOTLK) server modification that automatically applies a suppression aura to players, their pets, and NPC bots when entering dungeons and raids.

## Features

- **Automatic Aura Application**: Automatically applies the Greater Blessing of Suppression aura when players enter valid dungeons or raids
- **Player Commands**: Manual control via in-game commands (`supON` and `supOFF`)
- **Multi-Target Support**: Applies aura to:
  - The player
  - Player's pet
  - NPC bots within range
- **Map Validation**: Only works in designated dungeon and raid maps
- **Item Requirement**: Requires the Pain Suppression Runestone (Item ID: 600600) to function

## Installation

1. Place `Greater Blessing of Suppression.lua` in your server's Lua scripts directory
2. Import the SQL file from the `SQL/` folder to create the required item
3. Import the appropriate DBC files from `Spell dbc 45% reduction/` or `Spell dbc 75% reduction/` based on your desired reduction percentage
4. Import the item DBC files from `Item dbc/` if needed
5. Reload your server or restart the Lua engine

## Configuration

Edit the variables at the top of `Greater Blessing of Suppression.lua`:

```lua
local enabled = true          -- Enable/disable the script
local aura = 600600           -- Aura ID to apply
local timer1 = 1000           -- Delay for commands (ms)
local timer = 20000           -- Delay for map events (ms)
local itemID = 600600         -- Required item ID
```

## Usage

### In-Game Commands

- `supON` - Manually turn on the Greater Blessing of Suppression
- `supOFF` - Manually turn off the Greater Blessing of Suppression

### Automatic Behavior

The aura is automatically applied when:
- A player enters a valid dungeon or raid map (with a 20 second delay)
- The player has the required item in their inventory

The aura is automatically removed when:
- A player leaves a valid dungeon or raid map
- The player manually uses the `supOFF` command

## Supported Maps

### Dungeons
- **Classic**: Deadmines, Wailing Caverns, Shadowfang Keep, Blackfathom Deeps, Razorfen Kraul, Razorfen Downs, Uldaman, Gnomeregan, Scarlet Monastery, Scholomance, Blackrock Depths, Lower Blackrock Spire, Upper Blackrock Spire, Dire Maul, Zul'Farrak, Stratholme, Sunken Temple, Blackrock Spire, and more
- **Burning Crusade**: Hellfire Ramparts, Blood Furnace, Slave Pens, Underbog, Mana-Tombs, Auchenai Crypts, Sethekk Halls, Shadow Labyrinth, The Mechanar, The Botanica, The Arcatraz, Magisters' Terrace, and more
- **Wrath of the Lich King**: Utgarde Keep, Utgarde Pinnacle, The Nexus, Azjol-Nerub, Ahn'kahet, Drak'Tharon Keep, Violet Hold, Gundrak, Halls of Stone, Halls of Lightning, The Culling of Stratholme, Trial of the Champion, Forge of Souls, Pit of Saron, Halls of Reflection, and more

### Raids
- **Classic**: Molten Core, Blackwing Lair, Temple of Ahn'Qiraj, Ruins of Ahn'Qiraj
- **Burning Crusade**: Karazhan, Gruul's Lair, Magtheridon's Lair, Serpentshrine Cavern, Tempest Keep, Battle for Mount Hyjal, Black Temple, Sunwell Plateau
- **Wrath of the Lich King**: Naxxramas, Obsidian Sanctum, Eye of Eternity, Ulduar, Trial of the Crusader, Onyxia's Lair, Icecrown Citadel, Ruby Sanctum

## Files Structure

```
.
├── Greater Blessing of Suppression.lua    # Main Lua script
├── SQL/
│   └── Item 600600 Suppression Runestone.sql  # Item database entry
├── Item dbc/
│   ├── Item.csv                           # Item DBC data
│   └── ItemDisplayInfo.csv                # Item display info DBC data
├── Spell dbc 45% reduction/
│   └── Spell.csv                          # Spell DBC with 45% reduction
└── Spell dbc 75% reduction/
    └── Spell.csv                          # Spell DBC with 75% reduction
```

## Requirements

- AzerothCore or compatible WOTLK server
- Lua scripting support enabled
- Database access for SQL import
- DBC file modification tools (if customizing spell/item data)

## Notes

- The script uses optimized hash table lookups for map ID validation (O(1) complexity)
- NPC bots are identified by script names ending with "_bot"
- Pet detection uses a 30-yard range
- NPC bot detection uses a 60-yard range with type 3 objects

## License

This modification is provided as-is for use with private World of Warcraft servers.

## Support

For issues or questions, please open an issue on the GitHub repository.

