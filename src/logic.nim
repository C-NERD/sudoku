from random import randomize, sample, rand

type

  Grid* = array[9, array[9, int]]
  Ordered = seq[seq[int]]
  Box* = array[3, seq[int]]
  Boxes* = seq[Box]

proc generateOrdered() : Ordered =
    for each in 0..8:
        result.add(@[1, 2, 3, 4, 5, 6, 7, 8, 9])

proc inVertical(grid : Grid, pos, num : int) : bool =
    for each in grid:
        if each[pos] == num:
            return true

        else:
            continue

    return false

proc getGrid*() : Grid =
    echo "generating random numbers..."
    var grid : Grid
    var ordered = generateOrdered()
    randomize()
    let num1 = rand(1..9)
    var hline : array[9, int]
    hline[0] = num1
    ordered[0].delete(find(ordered[0], num1))

    for pos1 in 0..<grid.len:

        for pos2 in 0..<hline.len:
            if hline[pos2] != 0:
                continue

            else:
                while true:
                    let num = sample(ordered[pos2])

                    if num in hline:
                        hline[pos2] = 0
                        break

                    else:
                        if inVertical(grid, pos2, num):
                            continue

                        else:
                            hline[pos2] = num
                            ordered[pos2].delete(find(ordered[pos2], num))
                            break

        grid[pos1] = hline
        hline = [0, 0, 0, 0, 0, 0, 0, 0, 0]

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
    
    echo result

when isMainModule:
    echo getBoxes(getGrid())