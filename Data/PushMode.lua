
-- Mode switching
--
-- The Push has two modes, "Live" mode and user mode.
--
-- Live mode is what Ableton uses, and so do we.
-- User mode is a simplified mode for easy custom mapping.
--
-- Send (SYSEX_START SET_MODE_xxx) to switch the mode.
--
SET_MODE_LIVE = {98, 0, 1, 0}
SET_MODE_USER = {98, 0, 1, 1}
