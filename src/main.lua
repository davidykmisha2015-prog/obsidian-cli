#!/usr/bin/env lua
local VAULT_PATH = os.getenv("HOME") .. "/Документи/ObsidianVault"
-- Беремо саму папку де храняться всі нотатки obsidian 🡩

-- Допоміжна функція: повертає повний шлях до нотатки,
-- і автоматично додає .md, якщо користувач його не вказав
local function get_file_path(note_name)
    if not note_name:match("%.md$") then
        note_name = note_name .. ".md"
    end
    return VAULT_PATH .. "/" .. note_name
end

local function read_note(note_name)
    -- 1. Склеюємо шлях динамічно через параметр
    local file_path = get_file_path(note_name)
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

local function read_all()
    -- Отримуємо список усіх .md файлів у сховищі
    local handle = io.popen(string.format('ls -1 "%s"/*.md 2>/dev/null', VAULT_PATH))
    if not handle then
        print("[Помилка]: Не вдалося відкрити сховище за шляхом: " .. VAULT_PATH)
        return
    end

    print("=== Список нотаток у сховищі ===")
    local has_files = false
    for file_path in handle:lines() do
        has_files = true
        -- Витягуємо лише ім'я файлу без повного шляху та без .md
        local name = file_path:match(".*/(.*)%.md$") or file_path
        print("• " .. name)
    end
    handle:close()

    if not has_files then
        print("(Нотаток не знайдено)")
    end
end

local function remove_note(note_name)
    -- 1. Склеюємо шлях
    local file_path = get_file_path(note_name)
    -- 2. Видаляємо файл який обрав користувач
    local success, err = os.remove(file_path)
    if not success then
        print("[Помилка]: Не вдалося видалити нотатку — " .. tostring(err))
        return
    end

    print("Нотатку '" .. note_name .. "' успішно видалено!")
end

local function add_note(note_name, text)
    -- 1. Склеюємо шлях до файлу
    local file_path = get_file_path(note_name)
    -- 2. Відкрити файл в режимі дописування ("a" а не "r")
    local file, err = io.open(file_path, "a")
    -- 3. Перевірка
    if not file then
        print("[Помилка]: " .. tostring(err))
        return
    end
    -- 4. Записати файл
    file:write(text .. "\n")
    file:close()

    print("Успішно записано!")
end

-- Створюємо комірки перед запуском проги куди і будуть записуватись параметри
local cmd = arg[1]
local note = arg[2]
local text = arg[3]

if cmd == "read" then
    if not note then
        print("[Помилка]: Вкажіть назву нотатки (наприклад: lua main.lua read <назва>)")
        return
    end
    read_note(note)

elseif cmd == "add" then
    if not note or not text then
        print("[Помилка]: Вкажіть назву нотатки і текст (наприклад: lua main.lua add <назва> <текст>)")
        return
    end
    add_note(note, text)

elseif cmd == "read_all" then
    read_all()

elseif cmd == "remove_note" or cmd == "remove" or cmd == "rm" then
    if not note then
        print("[Помилка]: Будь ласка, вкажіть файл, який бажаєте видалити (наприклад: lua main.lua remove_note <назва>)")
        return
    end
    remove_note(note)

else
    print("Використання: lua main.lua <команда> [параметри]")
    print("Команди:")
    print("  read <назва>             — прочитати вміст нотатки")
    print("  add <назва> <текст>      — додати текст до нотатки")
    print("  read_all                 — вивести список усіх нотаток у сховищі")
    print("  remove_note <назва>      — видалити нотатку (аліаси: remove, rm)")
end
