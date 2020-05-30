# Package

version       = "0.1.0"
author        = "C_nerd"
description   = "A simple sudoku game made with the nigui gui library"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
binDir        = "bin"
bin           = @["sudoku"]

backend       = "cpp"

# Dependencies

requires "nim >= 1.0.0", "nigui >= 0.2.0"
