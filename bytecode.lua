local bytecode = {}

-- バイナリデータ操作のヘルパー関数
local function write_uint32(file, n)
    file:write(string.char(
        (n >> 24) & 0xFF,
        (n >> 16) & 0xFF,
        (n >> 8) & 0xFF,
        n & 0xFF
    ))
end

local function write_uint64(file, n)
    write_uint32(file, (n >> 32) & 0xFFFFFFFF)
    write_uint32(file, n & 0xFFFFFFFF)
end

local function read_uint32(file)
    local b4 = file:read(4)
    if not b4 then return nil end
    local b1, b2, b3, b4 = b4:byte(1, 4)
    return (b1 << 24) | (b2 << 16) | (b3 << 8) | b4
end

local function read_uint64(file)
    local high = read_uint32(file)
    local low = read_uint32(file)
    if not high or not low then return nil end
    return (high << 32) | low
end

-- バイトコードファイルのパース
function bytecode.parse(filename)
    local file = assert(io.open(filename, "rb"))
    
    -- ヘッダーチェック
    local magic = file:read(4)
    assert(magic == "CSVM", "Invalid magic number")
    
    -- バージョンチェック
    local version = read_uint32(file)
    assert(version == 1, "Unsupported version")
    
    -- 定数プール読み込み
    local const_pool_size = read_uint32(file)
    local const_pool = {}
    for i = 1, const_pool_size do
        local type = file:read(1)
        if type == "N" then  -- Number
            const_pool[i] = read_uint64(file)
        elseif type == "S" then  -- String
            local len = read_uint32(file)
            const_pool[i] = file:read(len)
        end
    end
    
    -- バイトコード読み込み
    local code_size = read_uint32(file)
    local code = {}
    for i = 1, code_size do
        local opcode_byte = file:read(1)
        if not opcode_byte then
            error("Unexpected end of file while reading opcode")
        end
        local opcode = string.byte(opcode_byte)
    
        local value = 0
        for j = 6, 0, -1 do
            local byte = file:read(1)
            if not byte then
                error("Unexpected end of file while reading operand")
            end
            value = (value * 256) + string.byte(byte)
        end
    
        code[i] = {
            opcode = opcode,
            value = value
        }
    end
    
    file:close()
    return const_pool, code
end

-- バイトコードファイルの書き込み
function bytecode.write(filename, const_pool, code)
    local file, err = io.open(filename, "wb")
    if not file then
        error(string.format("Cannot open file '%s' for writing: %s", filename, err))
    end
    
    -- ヘッダー書き込み
    file:write("CSVM")
    write_uint32(file, 1)  -- version 1
    
    -- 定数プール書き込み
    write_uint32(file, #const_pool)
    for _, const in ipairs(const_pool) do
        if type(const) == "number" then
            file:write("N")
            write_uint64(file, const)
        elseif type(const) == "string" then
            file:write("S")
            write_uint32(file, #const)
            file:write(const)
        end
    end
    
    -- バイトコード書き込み
    write_uint32(file, #code)
    for _, instruction in ipairs(code) do
        file:write(string.char(instruction.opcode))
        local value = instruction.value
        for i = 6, 0, -1 do
            file:write(string.char((value >> (i * 8)) & 0xFF))
        end
    end
    
    file:close()
end

-- ユーティリティ関数

-- バイトコードの検証
function bytecode.verify(const_pool, code)
    -- 定数プールの検証
    for i, const in ipairs(const_pool) do
        assert(type(const) == "number" or type(const) == "string",
            string.format("Invalid constant type at index %d", i))
    end
    
    -- コードの検証
    for i, instruction in ipairs(code) do
        assert(type(instruction.opcode) == "number" and instruction.opcode >= 0 and instruction.opcode <= 0xFF,
            string.format("Invalid opcode at instruction %d", i))
        assert(type(instruction.value) == "number",
            string.format("Invalid value at instruction %d", i))
    end
    return true
end

-- バイトコードのダンプ（デバッグ用）
function bytecode.dump(const_pool, code)
    print("Constant Pool:")
    for i, const in ipairs(const_pool) do
        print(string.format("  [%d] = %s (%s)", i, tostring(const), type(const)))
    end
    
    print("\nCode:")
    for i, instruction in ipairs(code) do
        print(string.format("  %04d: 0x%02X %d", i, instruction.opcode, instruction.value))
    end
end

-- ファイルがバイトコードファイルかチェック
function bytecode.is_bytecode_file(filename)
    local file = io.open(filename, "rb")
    if not file then return false end
    
    local magic = file:read(4)
    file:close()
    
    return magic == "CSVM"
end

return bytecode