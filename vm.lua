local opcodes = require("opcodes")
local vm = {stack = {}}

function vm.push(value)
    table.insert(vm.stack, value)
end

function vm.pop()
    if (#vm.stack <= 0) then
        error("Stack underflow")
    end

    return table.remove(vm.stack, #vm.stack)
end

function vm.execute(constant_pool, code)
    assert(code ~= nil)
    assert(type(code) == "table")

    local pc = 1
    while pc <= #code do
        local instruction = code[pc].opcode
        local value = code[pc].value

        if instruction == opcodes.PUSH then
            print("Pushing '" .. value .. "' to stack")
            vm.push(value)
        elseif instruction == opcodes.POP then
            local pop = vm.pop()
            print("Popped '" .. pop .. "' from stack")
        elseif instruction == opcodes.DUP then
            local pop = vm.pop()
            vm.push(pop)
            vm.push(pop)
            print("Duplicated")
        elseif instruction == opcodes.ADD then
            local b = vm.pop()
            local a = vm.pop()
            vm.push(a + b)
            print(a .. " + " .. b)
        end

        pc = pc + 1
    end
end

return vm