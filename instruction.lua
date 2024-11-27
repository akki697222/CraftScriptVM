local instruction = {}

---@param opcode integer
function instruction.new(opcode, value)
    local obj = {
        opcode = opcode,
        value = value,
    }
    function obj:toString(self)
        return string.format("0%x%02x:0%x%02x", self.opcode, self.value)
    end
    return obj
end

return instruction