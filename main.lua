#!/usr/bin/env lua
local VAULT_PATH = os.getenv("HOME") .. "/Documents/ObsidianVault"
-- Path to the directory where all Obsidian notes are stored 🡩

local function read_note(note_name)
    -- 1. Dynamically build the full path using the parameter
    local file_path = VAULT_PATH .. "/" .. note_name .. ".md"
    -- 2. Create the file variable and open the file
    local file, err = io.open(file_path, "r")
    -- 3. Error check
    if not file then
        print("[Error]: " .. tostring(err))
        return
    end
    -- 4. Read the file
    local text = file:read("*a")

    file:close()

    print(text)
end

local function add_note(note_name, text)
    -- 1. Build the path the same way as in read_note
    local file_path = VAULT_PATH .. "/" .. note_name .. ".md"
    -- 2. Open the file in append mode ("a" instead of "r")
    local file, err = io.open(file_path, "a")
    -- 3. Error check
    if not file then
        print("[Error]: " .. tostring(err))
        return
    end
    -- 4. Append text to file
    file:write(text .. "\n")

    file:close()

    print("[Success]: Note updated!")
end

-- Create variables to capture CLI arguments before execution
-- ↴
local cmd = arg[1]
local note = arg[2]
local text = arg[3]

if cmd == "read" then
    read_note(note) -- Call the read_note function defined above ------------ ⮥

elseif cmd == "add" then
    if not text then -- Input validation / safeguard
        print("[Error]: Missing note text!")
        return
    end
    add_note(note, text) -- Call the add_note function defined above --------- ⮥

else
    print("Usage:")
    print("  ob read <note_name>")
    print("  ob add <note_name> \"text to append\"")
end
