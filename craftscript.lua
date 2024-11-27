require("_includes")
local ap = argparse("CraftScript", "CraftScript Executor (and VM)")
ap:option("-b --bytecode", "Executes Compiled Bytecode")

local args = ap:parse()
local vm = require("vm")

local const_pool = {
    10,             -- const #1
    "Hello World",  -- const #2
    20              -- const #3
}

local code = {
    instruction.new(opcodes.PUSH, 1),
    instruction.new(opcodes.PUSH, 2),
    instruction.new(opcodes.ADD, 0),
    instruction.new(opcodes.HALT, 0)
}

bytecode.write("test.craftbyte", const_pool, code)

if args.bytecode then
    print(bytecode.parse(args.bytecode))
end
