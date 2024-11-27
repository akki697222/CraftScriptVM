require("_includes")
local ap = argparse("CraftScript", "CraftScript Executor (and VM)")
ap:option("-b --bytecode", "Executes Compiled Bytecode")

local args = ap:parse()
local vm = require("vm")

local const_pool = {}

local code = {
    instruction.new(opcodes.PUSH, 1),
    instruction.new(opcodes.DUP, 0),
    instruction.new(opcodes.ADD, 0),
    instruction.new(opcodes.POP, 0),
    instruction.new(opcodes.HALT, 0)
}

bytecode.write("test.craftbyte", const_pool, code)

local function getOpName(opcode)
    for key, value in pairs(opcodes) do
        if value == opcode then
            return key
        end
    end
    return ""
end

if args.bytecode then
    local cpool, codes = bytecode.parse(args.bytecode)
    for _, inst in ipairs(codes) do
        print(getOpName(inst.opcode) .. ":" .. tostring(inst.value))
    end

    vm.execute(cpool, codes)
end