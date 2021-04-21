from random import randomize, shuffle
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
    let values = tile.correctRow(grid[row], values)
    #tile.inspectAndCorrect(grid[row], values)

    for cellpos in 0..<grid[row].len:
        grid[row][cellpos].value = $values[cellpos]

    return grid.toTile()


proc generateNumbers(tile : var Tile) =
    
    for steppos in countup(0, 8, 3):
        shuffle(numbers)
        var puzzlerow : array[9, int]
        puzzlerow.deepCopy(numbers)

        tile = tile.addToRow(puzzlerow, steppos)
        puzzlerow.shift()

        tile = tile.addToRow(puzzlerow, steppos + 1)
        puzzlerow.shift()
        
        tile = tile.addToRow(puzzlerow, steppos + 2)


when isMainModule:
    let grid = getGrid()
    var tile = grid.toTile()
    tile.generateNumbers()
    tile.displayTile()