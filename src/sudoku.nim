import nigui, logic, datafunc
import nigui/[msgBox]
from os import fileExists

type

  Btnbox = seq[seq[TextBox]]
  Btnboxes = seq[Btnbox]

app.init()

const
  msg = """
This is a game of Sudoku made with Nim_Lang using the nigui GUI libray by cnerd,
to win a game of sudoku simply guess the numbers that goes in the empty slots. 
The numbers guessed must not appear more than once in the same row, column and
box. Now using this rule fill all empty slots and have fun playing Sudoku.
"""

  white : Color = rgb(255, 255, 255)
  aliceblue : Color = rgb(240, 248, 255)
  blue : Color = rgb(15, 15, 127)

  title = "Sudoku"
  imgPath = "img/icon.png"

  size = 400
  padding = ((size / 3) * (5 / 100))
  boxSize = ((size / 3).toInt) - (padding * 2).toInt
  textPadding = ((boxSize / 3) * (5 / 100))
  textBoxSize = ((boxSize / 3).toInt) - (textPadding * 6).toInt

var
  drawx, drawy : int


proc load() : Btnboxes =
  var grid = getGrid()
  var tile = grid.toTile()
  tile.generateNumbers()
  grid = tile.toGrid()
  
  var data = grid.getBoxes()
  #var data = getBoxes(getGrid())
  #data.inspectBoxes()

  for each in data:
    var btnbox : Btnbox

    for each2 in each:
      var btnsnlabels : seq[TextBox]

      for each3 in each2:
        let text = newTextBox("")

        if each3.value != $0 and each3.value > $0:
          text.text = $each3.value
          text.fontBold = true
          text.fontFamily = "Ariel"
          text.editable = false
          text.textColor = blue

        else:
          text.fontFamily = "San-Serif"
          
        text.setPosition(textBoxSize, textBoxSize)
        btnsnlabels.add(text)

      btnbox.add(btnsnlabels)

    result.add(btnbox)

proc mainWindow() =
  var mainWindow = newWindow(title)
  mainWindow.height = size + (size / 3).toInt
  mainWindow.width = size + padding.toInt
  mainWindow.centerOnScreen

  if fileExists(imgPath):
    mainWindow.iconPath = imgPath

  var mainContainer = newContainer()
  mainContainer.height = mainWindow.height
  mainContainer.width = mainWindow.width

  var vContainer = newLayoutContainer(Layout_Vertical)
  vContainer.height = size + (padding * 2).toInt
  vContainer.width = mainWindow.width

  var hContainer = newLayoutContainer(Layout_Horizontal)
  hContainer.height = (size / 3).toInt
  hContainer.width = mainWindow.width
  hContainer.setBackgroundColor(aliceblue)
  hContainer.xAlign = XAlign_Center
  hContainer.yAlign = YAlign_Center

  var about = newButton("about")
  var submit = newButton("submit")

  about.onClick = proc(event : ClickEvent) =
    mainWindow.msgBox(msg, "About")

  var bottombtns : seq[Button] = @[about, submit]

  for each in bottombtns:
    each.height = (boxSize / 3).toInt
    each.width = boxSize
    hContainer.add(each)

  mainContainer.add(hContainer)
  hContainer.y = size
  mainContainer.add(vContainer)
  mainWindow.add(mainContainer)

  let data = load()
  drawx = padding.toInt
  drawy = padding.toInt

  for each in countup(0, 8, 3):
    var row = newLayoutContainer(Layout_Horizontal)
    row.width = size
    row.height = (size / 3).toInt
    row.yAlign = YAlign_Center
    row.xAlign = XAlign_Center
    row.scrollableHeight = 0
    row.scrollableWidth = 0

    let info = [data[each], data[each + 1], data[each + 2]]

    var box1 = newLayoutContainer(Layout_Vertical)
    var box2 = newLayoutContainer(Layout_Vertical)
    var box3 = newLayoutContainer(Layout_Vertical)

    box1.yAlign = YAlign_Center 
    box2.yAlign = YAlign_Center 
    box3.yAlign = YAlign_Center

    box1.height = boxSize
    box1.width = boxSize
    
    box2.height = boxSize
    box2.width = boxSize

    box3.height = boxSize
    box3.width = boxSize

    let boxes = [box1, box2, box3]

    for each in 0..<info.len:

      for each2 in info[each]:
        var hbox = newLayoutContainer(Layout_Horizontal)
        hbox.scrollableHeight = 0
        hbox.scrollableWidth = 0
        hbox.xAlign = XAlign_Spread
        hbox.yAlign = YAlign_Center

        hbox.add(each2[0])
        hbox.add(each2[1])
        hbox.add(each2[2])

        boxes[each].add(hbox)

      row.add(boxes[each])

    vContainer.add(row)

  mainWindow.show()

mainWindow()
app.run()