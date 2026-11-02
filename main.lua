#!/usr/bin/env lua
local VAULT_PATH = os.getenv("HOME") .. "/Документи/ObsidianVault"
-- Беремо саму папку де храняться всі нотатки obsidian 🡩

 local function read_note(note_name)
    -- 1. Склеюємо шлях динамічно через параметр
    local file_path = VAULT_PATH .. "/" .. note_name .. ".md"
    -- 2. Створюємо змінну file і відкриваємо файл
    local file, err = io.open(file_path, "r")
    -- 3. Перевірка на помилку
    if not file then
        print("[Помилка]: " .. tostring(err))
        return
    end
    -- 4. Читаємо файл
    local text = file:read("*a")

    file:close()

    print(text)
end

local function add_note(note_name, text)
    -- 1. Теж склеюємо файл так само як в функції read_note
    local file_path = VAULT_PATH .. "/" .. note_name .. ".md"
    -- 2. Відкрити файл в режимі зміни ("a" а не "r")\
    local file, err = io.open(file_path, "a")
    -- 3. Теж перевірка
    if not file then
        print("[Помилка]: " .. tostring(err))
        return
    end
    -- 4. Записати файл
    file:write(text .. "\n")

    file:close()

    print("Успішно записано!")
end
    -- Створюємо комірки перед запуском проги куди і будуть записуватись флажки
    -- ↴
    local cmd = arg[1]
    local note = arg[2]
    local text = arg[3]

    if cmd == "read" then
        read_note(note) -- Викликаємо функцію read_note яку написали вище ------------ ⮥
    
    elseif cmd == "add" then
        if not text then -- Захист від дурня
            print("Помилка...")
            return
        end
        add_note(note, text) -- юзаємо функцію яка теж зверху ------------------------- ⮥
    
    else
        print("Повідомлення про правильен юзання")
    end
