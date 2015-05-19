#!/usr/bin/lua

actionsAliases = {
    list = "ls -f"
}

-- true if container name needed
possiblesActions = {
    start = true,
    stop = true,
    attach = true,
    execute = true,
    ls = false
}

function errorExit(message)
    if message ~= nil then
        print(message)
    end
    os.exit(false)
end

function table.slice(tab, begin, finish)
    tab = tab or {}
    if #tab <= 0 then return {} end
    begin = begin or 1
    finish = finish or #tab

    local new = {}
    for i = begin, finish, 1 do
        table.insert(new, tab[i])
    end

    return new
end

function table.merge(tab1, tab2)
    for i=1,#tab2 do
        tab1[#tab1+1] = tab2[i]
    end

    return tab1
end

if arg[1] == nil then
    print("Usage: lxc <action> [identifier] [arguments]\n")
    print("action\t\tthe action you put usually after 'lxc-'")
    print("identifier\tthe container's name or identifier, needed for some commands like start")
    print("arguments\toptionnals arguments for the lxc-<action> command")
    print("\nDon't forget to look for updates : https://github.com/smumu/lxc-wrapper")
    os.exit(true);
end

action = arg[1]
args = {}

if actionsAliases[action] ~= nil then
    local first = true
    for word in string.gmatch(actionsAliases[action], "%S+") do
        if first == true then
            action = word
            first = false
        else
            args[#args+1] = word
        end
    end
end

if possiblesActions[action] == nil then
    errorExit("Unsupported action `" .. action .. "`")
end

command = "lxc-" .. action
args = table.merge(args, table.slice(arg, 2))

if possiblesActions[action] == true then
    if arg[2] == nil then
        errorExit("Need container identifier for action `" .. action .. "`")
    end
    command = command .. " -n"
end

command = command .. " ".. table.concat(args, " ")
os.execute(command)
