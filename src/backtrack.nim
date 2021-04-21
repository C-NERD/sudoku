from random import randomize, sample, shuffle
#from strutils import parseInt
#from sequtils import keepItIf
import datafunc

#[proc foreSight(tile : Tile, curcell, lastcell : Cell) : tuple[success : bool, tile : Tile] =

    var
        tile = tile
        values : seq[int]
        originalvalue : string

    proc correct(tile : var Tile, pos : int, originalvalue : string) {.closure.} =
        #This function is used to correct other cells related to the cell
        #at position pos, it removes the curent value of the cell at position
        #pos from the values attribute of it's relative and it adds it's
        #original value to their values attribute

        for num in 0..<tile.len:

            if tile[num].alias in tile[pos].horizontal or 
                tile[num].alias in tile[pos].vertical or 
                tile[num].alias in tile[pos].box:

                tile[num].values.add(originalvalue.parseInt)
                let curindex = find(
                    tile[num].values, 
                    tile[pos].value.parseInt
                    )

                if curindex != -1:
                    tile[num].values.del(curindex)

    proc checkCell(tile : Tile, cell : Cell) : tuple[posible : bool, value : string] {.closure.} =
        #This function checks if the potencial values of a cell (last cell) are valid
        #and it returns a tuple of bool and string

        for value in cell.values:
            
            for pos in 0..<tile.len:
                if cell.alias == tile[pos].alias:
                    continue

                elif tile[pos].alias in cell.horizontal or tile[pos].alias in cell.vertical or tile[pos].alias in cell.box:
                    if tile[pos].value == cell.value:
                        break

                elif pos == tile.len - 1:
                    return (posible : true, value : $value)

        return (posible : false, value : "")

    randomize()
    for cellpos in countup(curcell.tilepos, lastcell.tilepos):
        values = tile[cellpos].values
        originalvalue = tile[cellpos].value

        if values == @[] or tile[cellpos].value == "":
            continue

        while true:
            values.keepItIf(it != tile[cellpos].value.parseInt)

            if values != @[]:
                tile[cellpos].value = $sample(values)

            else:
                tile[cellpos].value = originalvalue
                break

            if tile.inspect(tile[cellpos]):
                tile.correct(tile[cellpos].tilepos, originalvalue)
                tile[cellpos].values.add(originalvalue.parseInt)
                tile[cellpos].values.keepItIf(it != tile[cellpos].value.parseInt)
                break

            elif not tile.inspect(tile[cellpos]) and values.len == 0:
                #This checks if it's not able to find any suitable value
                #from the list of available values if so it changes the
                #cell value back to it's original one and then breaks the
                #while loop

                tile[cellpos].value = originalvalue
                break

            else:
                continue

        let cellcondition = tile.checkCell(tile[lastcell.tilepos])

        if cellcondition.posible == true:
            tile.chooseValue(lastcell.tilepos, cellcondition.value)
            return (success : true, tile : tile)

        else:
            continue

    return (success : false, tile : tile)


proc backTrack*(tile : var Tile, cell : Cell) =

    for num in countdown(cell.tilepos, 0):
        echo "Backtracking at ", tile[num]
        tile.displayTile()
        
        if tile[num].value == "":
            continue

        else:
            let values = foreSight(tile, tile[num], cell)

            if values.success:
                tile = values.tile
                break]#


proc generateNumbers(tile : var Tile) =
    randomize()

    block toplevel:

        for pos in 0..<tile.len:
            if tile[pos].value != "":
                continue

            shuffle(numbers)

            for number in numbers:

                if tile.inspect(tile[pos], $number):
                    tile[pos].value = $number

                    if isTileFull(tile):
                        break toplevel

                    else:
                        generateNumbers(tile)
                        break toplevel


#[proc generateNumbers*(tile : var Tile) =
    echo "generating random numbers for grid..."

    randomize()
    block myBlock:

        for num in 0..<tile.len:

            while true:
                var cellvalue : int
                var num = num
                
                if tile[num].values == @[]:
                    tile.backTrack(tile[num])
                    break

                else:
                    cellvalue = sample(tile[num].values)

                tile[num].value = $cellvalue

                if not tile.inspect(tile[num]):

                    if tile[num].values == @[] or tile[num].values.len <= 1:
                        tile.backTrack(tile[num])
                        break

                    continue

                else:
                    for num2 in 0..<tile.len:
                        if tile[num2].alias in tile[num].horizontal or 
                        tile[num2].alias in tile[num].vertical or 
                        tile[num2].alias in tile[num].box:

                            let curindex = find(tile[num2].values, tile[num].value.parseInt)

                            if curindex != -1:    
                                tile[num2].values.del(curindex)

                    break]#


when isMainModule:
    let grid = getGrid()
    var tile = grid.toTile()
    tile.generateNumbers()
    tile.displayTile()