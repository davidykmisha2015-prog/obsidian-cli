#!/usr/bin/env lua

-- Path to the directory where all Obsidian notes are stored
local home = os.getenv("HOME") or ""
local VAULT_PATH = home .. "/Documents/ObsidianVault"
-- Support localized directory names (e.g., Ukrainian 'Документи')
local check = io.open(VAULT_PATH, "r")
if check then
    check:close()
else
    local alt_path = home .. "/Документи/ObsidianVault"
    local alt_check = io.open(alt_path, "r")
    if alt_check then
        alt_check:close()
        VAULT_PATH = alt_path
    end
end

-- Helper function: returns the full path to a note,
-- automatically appending .md if omitted
local function get_file_path(note_name)
    if not note_name:match("%.md$") then
        note_name = note_name .. ".md"
    end
    return VAULT_PATH .. "/" .. note_name
end

local function read_note(note_name)
    -- 1. Dynamically build file path
    local file_path = get_file_path(note_name)
    -- 2. Open file in read mode
    local file, err = io.open(file_path, "r")
    -- 3. Error check
    if not file then
        print("[Error]: " .. tostring(err))
        return
    end
    -- 4. Read file content
    local text = file:read("*a")
    file:close()

    print(text)
end

local function read_all()
    -- List all .md files in the vault
    local handle = io.popen(string.format('ls -1 "%s"/*.md 2>/dev/null', VAULT_PATH))
    if not handle then
        print("[Error]: Failed to access vault at: " .. VAULT_PATH)
        return
    end

    print("=== Obsidian Notes in Vault ===")
    local has_files = false
    for file_path in handle:lines() do
        has_files = true
        -- Extract note name without path and .md extension
        local name = file_path:match(".*/(.*)%.md$") or file_path
        print("• " .. name)
    end
    handle:close()

    if not has_files then
        print("(No notes found)")
    end
end

local function remove_note(note_name)
    -- 1. Build file path
    local file_path = get_file_path(note_name)
    -- 2. Remove the selected file
    local success, err = os.remove(file_path)
    if not success then
        print("[Error]: Failed to delete note — " .. tostring(err))
        return
    end

    print("[Success]: Note '" .. note_name .. "' successfully deleted!")
end

local function add_note(note_name, text)
    -- 1. Build file path
    local file_path = get_file_path(note_name)
    -- 2. Open file in append mode ("a")
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

-- Capture CLI arguments before execution
local cmd = arg[1]
local note = arg[2]
local text = arg[3]

if cmd == "read" then
    if not note then
        print("[Error]: Please provide a note name (e.g.: lua src/main.lua read <note_name>)")
        return
    end
    read_note(note)

elseif cmd == "add" then
    if not note or not text then
        print("[Error]: Please provide a note name and text (e.g.: lua src/main.lua add <note_name> <text>)")
        return
    end
    add_note(note, text)

elseif cmd == "read_all" then
    read_all()

elseif cmd == "remove_note" or cmd == "remove" or cmd == "rm" then
    if not note then
        print("[Error]: Please specify a note to delete (e.g.: lua src/main.lua remove <note_name>)")
        return
    end
    remove_note(note)

else
    print("Usage: lua src/main.lua <command> [parameters]")
    print("Commands:")
    print("  read <note_name>         — read note contents")
    print("  add <note_name> <text>   — append text to a note")
    print("  read_all                 — list all notes in the vault")
    print("  remove <note_name>       — delete a note (aliases: remove_note, rm)")
end
