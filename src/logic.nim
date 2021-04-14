from random import randomize, sample
from strutils import parseInt, format
from sequtils import keepItIf
from os import sleep

type

  Grid* = array[9, array[9, Cell]]
  Tile* = array[81, Cell]
  Box* = array[3, seq[Cell]]
  Boxes* = seq[Box]

  Cell* = object
    tilepos : int
    alias : string
    letter : char
    number : int
    value* : string
    values : seq[int]
    horizontal : seq[string]
    vertical : seq[string]
    box : seq[string]

const 
    letters : array[9, char] = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I']

proc inspect(grid : var Grid, cell : Cell) : bool {.deprecated.} =
    var values : seq[Cell]

    for each in grid:
        values.add(each)

    for each in values:
        if cell.alias == each.alias:
            continue

        elif each.alias in cell.horizontal or each.alias in cell.vertical or each.alias in cell.box:
            if each.value == cell.value:
                return true

    return false


proc inspect(tile : var Tile, cell : Cell) : bool =
    for each in tile:
        if cell.alias == each.alias:
            continue

        elif each.alias in cell.horizontal or each.alias in cell.vertical or each.alias in cell.box:
            if each.value == cell.value:
                return true

    return false


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

proc displayTile(tile : Tile) =
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
    
    echo "\n"
    sleep(500)

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


proc backTrack(tile : var Tile, cell : Cell) =
    proc correct(tile : var Tile, cell : Cell) {.closure.} =
        for num in 0..<tile.len:

            if tile[num].alias in cell.horizontal or 
                tile[num].alias in cell.vertical or 
                tile[num].alias in cell.box:

                let curindex = find(
                    tile[num].values, 
                    cell.value.parseInt
                    )

                if curindex == -1:    
                    tile[num].values.add(cell.value.parseInt)

    block backtrack:
        for num3 in cell.tilepos..0:
            echo "Backtracking at ", tile[num3]
            var count : int

            while true:
                if count >= tile[num3].values.len:
                    break

                for num4 in tile[num3].tilepos..cell.tilepos:
                    correct(tile, tile[num3])
                    tile[num3].value = $sample(tile[num3].values)
                    displayTile(tile)

                if not tile.inspect(tile[num3]):
                    break backtrack

                else:
                    echo "continue 2"
                    count.inc()
                    continue



proc generateNumbers*(tile : var Tile) =
    echo "generating random numbers for grid..."

    randomize()
    block myBlock:

        for num in 0..<tile.len:

            while true:
                var cellvalue : int
                var num = num
                
                if tile[num].values == @[]:
                    #[if tile.backTrack(tile[num - 2]):
                        num = num - 2
                        tile.displayTile()]#
                    tile.backTrack(tile[num - 1])
                    break

                else:
                    echo tile[num].alias, " ", tile[num].values
                    cellvalue = sample(tile[num].values)

                tile[num].value = $cellvalue

                if tile.inspect(tile[num]):
                    echo "continue 1"
                    continue

                else:
                    for num2 in 0..<tile.len:
                        if tile[num2].alias in tile[num].horizontal or 
                        tile[num2].alias in tile[num].vertical or 
                        tile[num2].alias in tile[num].box:

                            let curindex = find(tile[num2].values, tile[num].value.parseInt)

                            if curindex != -1:    
                                tile[num2].values.del(curindex)

                    tile.displayTile()
                    break

proc generateNumbers*(grid : var Grid) {.deprecated.} =
    echo "generating random numbers for grid..."

    randomize()
    block myBlock:

        for num in 0..<grid.len:

            for num2 in 0..<grid[num].len:
                while true:
                    var cellvalue : int
                    if grid[num][num2].values == @[]:
                        break myBlock

                    else:
                        cellvalue = sample(grid[num][num2].values)

                    grid[num][num2].value = $cellvalue

                    if grid.inspect(grid[num][num2]):
                        continue

                    else:
                        for num3 in 0..<grid.len:

                            for num4 in 0..<grid[num3].len:
                                if grid[num3][num4].alias in grid[num][num2].horizontal or grid[num3][num4].alias in grid[num][num2].vertical or 
                                grid[num3][num4].alias in grid[num][num2].box:

                                    let curindex = find(grid[num3][num4].values, grid[num][num2].value.parseInt)

                                    if curindex != -1:    
                                        grid[num3][num4].values.del(curindex)

                        break


proc getBoxes*(grid : Grid) : Boxes =

    for pos in countup(0, 8, 3):
        var b1, b2, b3 : Box

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


when isMainModule:
    var grid = getGrid()
    var tile = grid.toTile()
    #echo tile.toGrid() == grid
    #for each in tile:
    #    echo each.tilepos
    #echo grid
    tile.generateNumbers()
    #[var count : int

    for each in tile:
        var sym : string

        if count == 9:
            count = 0
            stdout.write("\n\n")

        count.inc()
        if count mod 3 == 0:
            sym = "     |     "
        
        else:
            sym = "     "

        stdout.write(each.value, sym)]#
    #echo grid.getBoxes()