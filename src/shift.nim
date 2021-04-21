from random import randomize, shuffle, sample
import datafunc


proc shift(values : var array[9, int]) =
    var values2 : array[9, int]
    
    values2[0..2] = values[6..8]
    values2[3..5] = values[0..2]
    values2[6..8] = values[3..5]

    values = values2


proc addToRow(tile : Tile, values : array[9, int], row : int) : Tile =
    #var values = values

    var grid = tile.toGrid()
    #let values = tile.correctRow(grid[row], values)
    #tile.inspectAndCorrect(grid[row], values)

    for cellpos in 0..<grid[row].len:
        grid[row][cellpos].value = $values[cellpos]

    return grid.toTile()


proc columnShifting(tile : var Tile) =
    var
        grid = tile.toGrid()
        othergrid : Grid

    for pos in countup(0, 8, 3):
        var values = @[1, 2]
        let 
            addpos = sample(values)

            column1 = [grid[0][pos], grid[1][pos], grid[2][pos], grid[3][pos], grid[4][pos],
            grid[5][pos], grid[6][pos], grid[7][pos], grid[8][pos]]

            column2 = [grid[0][pos + addpos], grid[1][pos + addpos], grid[2][pos + addpos], 
            grid[3][pos + addpos], grid[4][pos + addpos], grid[5][pos + addpos], grid[6][pos + addpos], 
            grid[7][pos + addpos], grid[8][pos + addpos]]

        values.delete(addpos)
        let 
            lastval = (values)[0]

            lastcolumn = [grid[0][pos + lastval], grid[1][pos + lastval], grid[2][pos + lastval], 
            grid[3][pos + lastval], grid[4][pos + lastval], grid[5][pos + lastval], grid[6][pos + lastval], 
            grid[7][pos + lastval], grid[8][pos + lastval]]

        echo lastval
        for pos2 in 0..<column1.len:
            othergrid[pos2][pos] = lastcolumn[pos2]
            othergrid[pos2][pos + addpos] = column1[pos2]
            othergrid[pos2][pos + lastval] = column2[pos2]

    tile = othergrid.toTile()


proc generateNumbers*(tile : var Tile) =
    
    for steppos in countup(0, 8, 3):
        shuffle(numbers)
        var puzzlerow : array[9, int]
        puzzlerow.deepCopy(numbers)

        let grid = tile.toGrid()
        tile.inspectAndCorrect(grid[steppos], puzzlerow)

        tile = tile.addToRow(puzzlerow, steppos)
        puzzlerow.shift()

        tile = tile.addToRow(puzzlerow, steppos + 1)
        puzzlerow.shift()
        
        tile = tile.addToRow(puzzlerow, steppos + 2)


proc shiftBoard*(tile : Tile, difficulty : int) : Sudoku =
    #tile.displayTile()
    #var tile = tile
    #tile.columnShifting()

    var
        solvedtile = tile
        unsolvedtile = setLevel(difficulty, solvedtile)
        
    result.tile = unsolvedtile
    result.solution = solvedtile

when isMainModule:
    let grid = getGrid()
    var tile = grid.toTile()
    tile.generateNumbers()
    let board = shiftBoard(tile, 5)
    board.solution.displayTile()
    board.tile.displayTile()
    #tile.displayTile()