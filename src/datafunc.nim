from os import sleep
from random import randomize, shuffle, rand
from sequtils import keepItIf, concat
from strutils import parseInt

type

  Tile* = array[81, Cell]
  Grid* = array[9, array[9, Cell]]
  Box* = seq[array[3, seq[Cell]]]

  Sudoku* = object
    tile* : Tile
    solution* : Tile

  Cell* = object
    tilepos* : int
    alias* : string
    letter* : char
    number* : int
    value* : string
    values* : seq[int]
    horizontal* : seq[string]
    vertical* : seq[string]
    box* : seq[string]

var
    numbers* : array[9, int] = [1, 2, 3, 4, 5, 6, 7, 8, 9]

const
    letters* : array[9, char] = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I']


proc isTileFull*(tile : Tile) : bool =
    for cell in tile:
        if cell.value == "":
            return false

    return true


proc inspect*(tile : Tile, cell : Cell,) : bool =
    for each in tile:
        if cell.alias == each.alias:
            continue

        elif each.alias in cell.horizontal or each.alias in cell.vertical or each.alias in cell.box:
            if each.value == cell.value:
                return false

    return true


proc inspect*(tile : Tile, cell : Cell, value : string) : bool =
    for each in tile:
        if cell.alias == each.alias:
            continue

        elif each.alias in cell.horizontal or each.alias in cell.vertical or each.alias in cell.box:
            if each.value == value:
                return false

    return true


proc inspectHorizontal(tile : Tile, cell : Cell, value : string) : bool =
    for each in tile:
        if cell.alias == each.alias:
            continue

        elif each.alias in cell.vertical:
            if each.value == value:
                return false

    return true


proc inspectAndCorrect*(tile : Tile, row : array[9, Cell], values : var array[9, int]) =
    var
        condition : bool = true

    for pos in 0..<row.len:
        
        if tile.inspectHorizontal(row[pos], $values[pos]):
            continue

        else:
            condition = false
            break

    if not condition:
        randomize()
        shuffle(values)
        inspectAndCorrect(tile, row, values)


proc inspectAndCorrect*(tile : Tile, cells : seq[Cell], values : var seq[int]) =
    var
        condition : bool = true

    for pos in 0..<cells.len:
        
        if tile.inspectHorizontal(cells[pos], $values[pos]):
            echo "hello"
            continue

        else:
            echo "No Hello"
            condition = false
            break

    if not condition:
        randomize()
        shuffle(values)
        inspectAndCorrect(tile, cells, values)


proc correctRow*(tile : Tile, row : array[9, Cell], values : array[9, int]) : array[9, int] =
    var cellvalues : seq[int]

    for pos in countup(0, row.len - 1, 3):
        var value : seq[int] = values[pos..(pos + 2)]
        tile.inspectAndCorrect(row[pos..(pos + 2)], value)
        cellvalues.add(value)

    for pos in 0..<cellvalues.len:
        result[pos] = cellvalues[pos]


proc displayTile*(tile : Tile) =
    for num in 0..<tile.len:
        var value : string

        if num mod 9 == 0:
            echo ""

            if num mod 27 == 0:
                echo "-------------------------------------"

        elif num mod 3 == 0:
            stdout.write("  |  ")

        if tile[num].value == "":
            value = " "
        
        else:
            value = tile[num].value

        stdout.write(" " & value & " ")
    
    stdout.write("\n-------------------------------------")
    echo "\n"
    sleep(500)

proc chooseValue*(tile : var Tile, pos : int, value : string) =
    tile[pos].value = value
    for num in 0..<tile.len:

        if tile[num].alias in tile[pos].horizontal or 
            tile[num].alias in tile[pos].vertical or 
            tile[num].alias in tile[pos].box:

            let curindex = find(
                tile[num].values, 
                tile[pos].value.parseInt
                )

            if curindex != -1:
                tile[num].values.del(curindex)


proc getBox(letter : char, number : int) : seq[string] =
    proc getBox2(number2 : array[3, int]) : seq[string] {.closure.} =

        if ['A', 'B', 'C'].contains(letter):
            let letter2 = ['A', 'B', 'C']

            for num in 0..<number2.len:

                for each in letter2:
                    result.add(each & $number2[num])

        elif ['D', 'E', 'F'].contains(letter):
            let letter2 = ['D', 'E', 'F']

            for num in 0..<number2.len:
                
                for each in letter2:
                    result.add(each & $number2[num])

        elif ['G', 'H', 'I'].contains(letter):
            let letter2 = ['G', 'H', 'I']

            for num in 0..<number2.len:
                
                for each in letter2:
                    result.add(each & $number2[num])
    
    if [1, 2, 3].contains(number):
        result = getBox2([1, 2, 3])

    elif [4, 5, 6].contains(number):
        result = getBox2([4, 5, 6])

    elif [7, 8, 9].contains(number):
        result = getBox2([7, 8, 9])


proc toTile*(grid : Grid) : Tile =
    var grid = grid
    for num in 0..<grid.len:
        if num > 0:
            let start = num * 9

            for num2 in start..(start + 8):
                grid[num][num2 - start].tilepos = num2
                
            result[start..(start + 8)] = grid[num]

        else:
            for num2 in 0..8:
                grid[num][num2].tilepos = num2

            result[0..8] = grid[num]

proc toGrid*(tile : Tile) : Grid =
    var
        first : int
        last : int

    for num in 0..8:
        first = num * 9
        last = first + 8
        var seqrow : seq[Cell] = tile[first..last]
        var arrayrow : array[9, Cell]

        for num2 in 0..<seqrow.len:
            arrayrow[num2] = seqrow[num2]

        result[num] = arrayrow

proc getGrid*() : Grid =
    var grid : Grid
    for num in 0..<grid.len:

        for num2 in 0..<grid[num].len:
            
            grid[num][num2].values = @[1, 2, 3, 4, 5, 6, 7, 8, 9]
            grid[num][num2].alias = letters[num] & $(num2 + 1)
            grid[num][num2].letter = letters[num]
            grid[num][num2].number = num2 + 1

            grid[num][num2].box = getBox(grid[num][num2].letter, grid[num][num2].number)

            for num3 in 1..9:
                if num3 != grid[num][num2].number:
                    grid[num][num2].horizontal.add(grid[num][num2].letter & $num3)

                if letters[num3 - 1] != grid[num][num2].letter:
                    grid[num][num2].vertical.add(letters[num3 - 1] & $(num2 + 1))

            grid[num][num2].box.keepItIf(
                it notin grid[num][num2].horizontal and 
                it notin grid[num][num2].vertical and
                it != grid[num][num2].alias
                )

    return grid


proc getBoxes*(grid : Grid) : Box =

    for pos in countup(0, 8, 3):
        var b1, b2, b3 : array[3, seq[Cell]]

        b1[0] = grid[pos][0..2]
        b1[1] = grid[pos + 1][0..2]
        b1[2] = grid[pos + 2][0..2]

        b2[0] = grid[pos][3..5]
        b2[1] = grid[pos + 1][3..5]
        b2[2] = grid[pos + 2][3..5]

        b3[0] = grid[pos][6..8]
        b3[1] = grid[pos + 1][6..8]
        b3[2] = grid[pos + 2][6..8]

        result.add(b1)
        result.add(b2)
        result.add(b3)


proc setLevel*(level : int, tile : Tile) : Tile =
    let
        levelseeds : array[3, int] = [3, 5, 6]

    proc straighten(row1, row2, row3 : seq[Cell]) : seq[Cell] {.closure.} =
        result = concat(row1, row2, row3)

    proc fold(row : seq[Cell]) : seq[array[3, Cell]] {.closure.} =
        
        for pos in countup(0, row.len - 1, 3):
            var innerrow = [row[pos], row[pos + 1], row[pos + 2]]
            result.add(innerrow)

    proc levelSetting(levelseed : int, tile : Tile) : Tile {.closure.} =

        var 
            grid = tile.toGrid()

        for pos in countup(0, grid.len - 1, 3):
            
            randomize()
            var
                straightenedbox1 = straighten(grid[pos][0..2], grid[pos + 1][0..2], grid[pos + 2][0..2])
                straightenedbox2 = straighten(grid[pos][3..5], grid[pos + 1][3..5], grid[pos + 2][3..5])
                straightenedbox3 = straighten(grid[pos][6..8], grid[pos + 1][6..8], grid[pos + 2][6..8])

            for seed in 1..levelseed:
                let randpos1 = rand(0..8)
                let randpos2 = rand(0..8)
                let randpos3 = rand(0..8)

                straightenedbox1[randpos1].value = $0
                straightenedbox2[randpos2].value = $0
                straightenedbox3[randpos3].value = $0

            let
                foldedbox1 = fold(straightenedbox1)
                foldedbox2 = fold(straightenedbox2)
                foldedbox3 = fold(straightenedbox3)

            for foldpos in 0..2:
                grid[pos + foldpos][0..2] = foldedbox1[foldpos]
                grid[pos + foldpos][3..5] = foldedbox2[foldpos]
                grid[pos + foldpos][6..8] = foldedbox3[foldpos]

        result = grid.toTile()

    if level in levelseeds:
        result = levelSetting(level, tile)

    else:
        result = levelSetting(3, tile)