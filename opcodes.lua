---@enum opcodes
local opcodes = {
    -- スタック操作命令群
    PUSH         = 0x01,
    POP          = 0x02,
    DUP          = 0x03,
    SWAP         = 0x04,
    PICK         = 0x05,
    ROLL         = 0x06,

    -- 算術演算命令群
    ADD          = 0x10,
    SUB          = 0x11,
    MUL          = 0x12,
    DIV          = 0x13,
    MOD          = 0x14,

    -- 比較・分岐命令群
    CMP          = 0x20,
    JMP          = 0x21,
    JE           = 0x22,
    JNE          = 0x23,
    JL           = 0x24,
    JG           = 0x25,

    -- メモリ操作命令群
    LOAD         = 0x30,
    STORE        = 0x31,

    -- サブルーチン命令群
    CALL         = 0x40,
    RET          = 0x41,

    -- オブジェクト操作命令群
    NEW          = 0x50,
    DEL          = 0x51,
    GETF         = 0x52,
    SETF         = 0x53,
    CALLM        = 0x54,

    -- 配列操作命令群
    NEWARRAY     = 0x60,
    ARRLEN       = 0x61,
    ALOAD        = 0x62,
    ASTORE       = 0x63,

    -- 例外処理命令群
    THROW        = 0x70,
    CATCH        = 0x71,

    -- 型操作命令群
    TYPEOF       = 0x80,
    TYPESIZE     = 0x81,
    CAST         = 0x82,
    CONVERT      = 0x83,
    INSTANCEOF   = 0x84,
    ISSUBTYPE    = 0x85,
    MAKEGENERICS = 0x86,
    TYPEPARAM    = 0x87,

    -- その他
    NOP          = 0x00,
    CHARAT       = 0xF0,
    HALT         = 0xFF
}

return opcodes
