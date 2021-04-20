from os import sleep

type

  Grid* = array[9, array[9, Cell]]
  Tile* = array[81, Cell]
  Box* = array[3, seq[Cell]]
  Boxes* = seq[Box]

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

const 
    letters* : array[9, char] = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I']


proc inspect*(grid : Grid, cell : Cell) : bool {.deprecated.} =
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


proc inspect*(tile : Tile, cell : Cell,) : bool =
    for each in tile:
        if cell.alias == each.alias:
            continue

        elif each.alias in cell.horizontal or each.alias in cell.vertical or each.alias in cell.box:
            if each.value == cell.value:
                return true

    return false

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
    
    echo "\n"
    sleep(500)