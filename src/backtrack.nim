from random import randomize, sample
from strutils import parseInt
from sequtils import keepItIf
import datafunc

proc foreSight(tile : Tile, curcell, backcell : Cell) : tuple[tile : Tile, success : bool] =
    var
        tile = tile
        values : seq[int]

    proc correct(tile : var Tile, pos : int) {.closure.} =
        for num in 0..<tile.len:

            if tile[num].alias in tile[pos].horizontal or 
                tile[num].alias in tile[pos].vertical or 
                tile[num].alias in tile[pos].box:

                let curindex = find(
                    tile[num].values, 
                    tile[pos].value.parseInt
                    )

                #if curindex == -1:    
                 #   tile[num].values.add(tile[pos].value.parseInt)
                if curindex != -1:
                    tile[num].values.del(curindex)

    echo curcell.tilepos, "     ", backcell.tilepos
    randomize()
    for num in curcell.tilepos..backcell.tilepos:
        var 
            checked : seq[string]
            check : bool = true

        values = tile[num].values
        echo values

        if tile[num].value != "":
            values.keepItIf(it != tile[num].value.parseInt)

        if values == @[]:
            return (tile, false)

        while true:        
            tile[num].value = $sample(values)
            checked.add(tile[num].value)

            if not tile.inspect(tile[num]):
                tile.correct(tile[num].tilepos)
                break

            else:
                for each in values:
                    if $each notin checked:
                        check = false
                        break

                if check:
                    #echo "check waste"
                    #tile.displayTile()
                    return (tile, false)

        tile.displayTile()
    return (tile, true)



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
                break