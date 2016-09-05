-- Push command definitions

-- all push sysex commands begin with this
--SYSEX_START = {240, 71, 127, 21}
SYSEX_START = {71, 127, 21}

-- variable-length commands use this terminator
--SYSEX_END = {247}
SYSEX_END = {}
