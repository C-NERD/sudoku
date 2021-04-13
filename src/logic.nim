from random import randomize, sample
from strutils import parseInt, format
from sequtils import keepItIf

type

  Grid* = array[9, array[9, Cell]]
  Box* = array[3, seq[Cell]]
  Boxes* = seq[Box]

  Cell* = object
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

proc inspect(grid : var Grid, cell : Cell) : bool =
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

proc getGrid*() : Grid =
    var grid : Grid
    for num in 0..<grid.len:

        for num2 in 0..<grid[num].len:
            
            grid[num][num2].values = @[1, 2, 3, 4, 5, 6, 7, 8, 9]
            grid[num][num2].alias = letters[num] & $(num2 + 1)
            grid[num][num2].letter = letters[num]
            grid[num][num2].number = num2 + 1

            grid[num][num2].box = getBox(grid[num][num2].letter, grid[num][num2].number)

            for num3 in (grid[num][num2].number)..9:
                if num3 != grid[num][num2].number:
                    grid[num][num2].horizontal.add(grid[num][num2].letter & $num3)
                    grid[num][num2].vertical.add(letters[num3 - 1] & $(num2 + 1))

            for num3 in 1..(grid[num][num2].number):
                if num3 != grid[num][num2].number:
                    grid[num][num2].horizontal.add(grid[num][num2].letter & $num3)
                    grid[num][num2].vertical.add(letters[num3 - 1] & $(num2 + 1))

            grid[num][num2].box.keepItIf(it notin grid[num][num2].horizontal and it notin grid[num][num2].vertical)

    return grid

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

#[proc getValues(grid : Grid) : array[9, array[9, array[3, array[3, int]]]] =

    for pos in countup(0, 8, 3):
        var b1, b2, b3 : array[3, array[3, int]]

        for each in grid[pos]:
            

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
        result.add(b3)]#

proc generateNumbers*(grid : var Grid) =
    echo "generating random numbers for grid..."

    randomize()
    block myBlock:

        for num in 0..<grid.len:

            for num2 in 0..<grid[num].len:
                while true:
                    var cellvalue : int
                    if grid[num][num2].values == @[]:
                        #echo "zero", "      $1".format([$grid[num][num2].letter])
                        #cellvalue = 0
                        #echo grid.getBoxes()
                        #quit(-1)
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


when isMainModule:
    var grid = getGrid()
    #echo grid
    grid.generateNumbers()
    echo grid.getBoxes()