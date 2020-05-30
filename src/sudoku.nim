# This is just an example to get you started. A typical hybrid package
# uses this file as the main entry point of the application.

#import sudokupkg/submodule
import nigui, std/monotimes
import nigui/[msgBox]
from random import randomize, rand
from sequtils import map, count
from times import inMinutes

app.init()

const
  M_SIZE = 297
  SIZE = (((M_SIZE/3)/3) * 0.9).toInt
  N_SIZE = (((M_SIZE/3)/3) * 0.9).toInt
  S_SIZE = ((((M_SIZE/3)/3).toInt - (((M_SIZE/3)/3) * 0.9).toInt) * 4) + (((M_SIZE/3)/3) * 0.9).toInt
  H_SIZE = M_SIZE + SIZE

var
  pos : int = 0
  count = 0
  white : Color = rgb(255, 255, 255)
  black : Color = rgb(0, 0, 0)


proc generator(mode: string, btns1, btns2, btns3, btns4, btns5, btns6, btns7, btns8, btns9, col1, col2, col3, col4, col5, col6, col7, col8, col9, box1, box2, box3, box4, box5, box6, box7, box8, box9 : array[9, TextBox]) =
  randomize()
  #[generating numbers for the game based on the difficulty mode choosen
  for easy generates number from 1 to 9 for medium from 1 to 7 and for 
  hard 1 to 4 incase you input an invalid command an exception is raised]#

  for each in @[btns1, btns2, btns3, btns4, btns5, btns6, btns7, btns8, btns9]:
    for each1 in each:
      each1.text = $(rand(1..9))

  if mode == "easy":
    for each in @[box1, box2, box3, box4, box5, box6, box7, box8, box9]:
      for i in each:
        if each.map(proc (x: TextBox): string = x.text).count("") <= 2:
          i.text = ""  
  elif mode == "medium":
    for each in @[box1, box2, box3, box4, box5, box6, box7, box8, box9]:
      for i in each:
        if each.map(proc (x: TextBox): string = x.text).count("") <= 3:
          i.text = ""
  elif mode == "hard":
    for each in @[box1, box2, box3, box4, box5, box6, box7, box8, box9]:
      for i in each:
        if each.map(proc (x: TextBox): string = x.text).count("") <= 4:
          i.text = ""
  else:
    raiseAssert("invalid command")

  #[the first three for loops filter the generated number 
  according to the three rules of sudoku and make sure no multiple
  number appear on the same line horizontally and vertically
  and no multiple number appear in the same box]#

  for each in @[btns1, btns4, btns3, btns2, btns5, btns8, btns7, btns6, btns9]:
    for i in each:
      if each.map(proc (x: TextBox): string = x.text).count(i.text) > 1:
        i.text = ""

  for each in @[col1, col4, col3, col2, col5, col8, col7, col6, col9]:
    for i in each:
      if each.map(proc (x: TextBox): string = x.text).count(i.text) > 1:
        i.text = ""

  for each in @[box1, box4, box3, box2, box5, box8, box7, box6, box9]:
    for i in each:
      if each.map(proc (x: TextBox): string = x.text).count(i.text) > 1:
        i.text = ""

  #[this for loop makes sure that inputs with generated numbers cannot be changed
  by the user]#
  for each in @[btns1, btns2, btns3, btns4, btns5, btns6, btns7, btns8, btns9]:
      for i in each:
        if i.text != "":
          i.editable = false

proc g_logic(start : MonoTime, btns1, btns2, btns3, btns4, btns5, btns6, btns7, btns8, btns9, col1, col2, col3, col4, col5, col6, col7, col8, col9, box1, box2, box3, box4, box5, box6, box7, box8, box9: array[9, TextBox]) : string =

  for each in @[btns1, btns2, btns3, btns4, btns5, btns6, btns7, btns8, btns9]:
    for i in each:
      if each.map(proc (x: TextBox): string = x.text).count(i.text) == 1:
        count.inc
      elif i.text == "":
        return "some boxes are empty "

  if count == 81:
    count = 0
    for each in @[col1, col2, col3, col4, col5, col6, col7, col8, col9]:
      for i in each:
        if each.map(proc (x: TextBox): string = x.text).count(i.text) == 1:
          count.inc
        elif i.text == "":
          return "some boxes are empty "

  if count == 81:
    count = 0
    for each in @[box1, box2, box3, box4, box5, box6, box7, box8, box9]:
      for i in each:
        if each.map(proc (x: TextBox): string = x.text).count(i.text) == 1:
          count.inc
        elif i.text == "":
          return "some boxes are empty "

  if count == 81:
    count = 0
    return "You have won it took you " & $inMinutes(getMonoTime() - start) & " minutes to solve the game"
  
  else:
    count = 0
    return "You have double number on some of the columns, rows or boxes"

proc s_layout() =
  #initializing the window

  var
    btns1 : array[9, TextBox] = [newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox()]
    btns2 : array[9, TextBox] = [newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox()]
    btns3 : array[9, TextBox] = [newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox()] 
    btns4 : array[9, TextBox] = [newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox()] 
    btns5 : array[9, TextBox] = [newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox()] 
    btns6 : array[9, TextBox] = [newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox()] 
    btns7 : array[9, TextBox] = [newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox()] 
    btns8 : array[9, TextBox] = [newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox()] 
    btns9 : array[9, TextBox] = [newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox(), newTextBox()]

    col1 : array[9, TextBox] = [btns1[0], btns2[0], btns3[0], btns4[0], btns5[0], btns6[0], btns7[0], btns8[0], btns9[0]]
    col2 : array[9, TextBox] = [btns1[1], btns2[1], btns3[1], btns4[1], btns5[1], btns6[1], btns7[1], btns8[1], btns9[1]]
    col3 : array[9, TextBox] = [btns1[2], btns2[2], btns3[2], btns4[2], btns5[2], btns6[2], btns7[2], btns8[2], btns9[2]]
    col4 : array[9, TextBox] = [btns1[3], btns2[3], btns3[3], btns4[3], btns5[3], btns6[3], btns7[3], btns8[3], btns9[3]]
    col5 : array[9, TextBox] = [btns1[4], btns2[4], btns3[4], btns4[4], btns5[4], btns6[4], btns7[4], btns8[4], btns9[4]]
    col6 : array[9, TextBox] = [btns1[5], btns2[5], btns3[5], btns4[5], btns5[5], btns6[5], btns7[5], btns8[5], btns9[5]]
    col7 : array[9, TextBox] = [btns1[6], btns2[6], btns3[6], btns4[6], btns5[6], btns6[6], btns7[6], btns8[6], btns9[6]]
    col8 : array[9, TextBox] = [btns1[7], btns2[7], btns3[7], btns4[7], btns5[7], btns6[7], btns7[7], btns8[7], btns9[7]]
    col9 : array[9, TextBox] = [btns1[8], btns2[8], btns3[8], btns4[8], btns5[8], btns6[8], btns7[8], btns8[8], btns9[8]]

    box1 : array[9, TextBox] = [btns1[0], btns2[0], btns3[0], btns1[1], btns2[1], btns3[1], btns1[2], btns2[2], btns3[2]]
    box2 : array[9, TextBox] = [btns4[0], btns5[0], btns6[0], btns4[1], btns5[1], btns6[1], btns4[2], btns5[2], btns6[2]]
    box3 : array[9, TextBox] = [btns7[0], btns8[0], btns9[0], btns7[1], btns8[1], btns9[1], btns7[2], btns8[2], btns9[2]]
    box4 : array[9, TextBox] = [btns1[3], btns2[3], btns3[3], btns1[4], btns2[4], btns3[4], btns1[5], btns2[5], btns3[5]]
    box5 : array[9, TextBox] = [btns4[3], btns5[3], btns6[3], btns4[4], btns5[4], btns6[4], btns4[5], btns5[5], btns6[5]]
    box6 : array[9, TextBox] = [btns7[3], btns8[3], btns9[3], btns7[4], btns8[4], btns9[4], btns7[5], btns8[5], btns9[5]]
    box7 : array[9, TextBox] = [btns1[6], btns2[6], btns3[6], btns1[7], btns2[7], btns3[7], btns1[8], btns2[8], btns3[8]]
    box8 : array[9, TextBox] = [btns4[6], btns5[6], btns6[6], btns4[7], btns5[7], btns6[7], btns4[8], btns5[8], btns6[8]]
    box9 : array[9, TextBox] = [btns7[6], btns8[6], btns9[6], btns7[7], btns8[7], btns9[7], btns7[8], btns8[8], btns9[8]]

  var mainWindow = newWindow("Sudoku")
  mainWindow.height = H_SIZE
  mainWindow.width = M_SIZE 
  mainWindow.centerOnScreen
  mainWindow.iconPath = "img/icon.png"

  #[the whole layout covering the window 
  the layouts containing the textbox will 
  be put over it]#

  var mainContainer = newContainer()
  mainWindow.add(mainContainer)

  #[shows a message box for choosing game 
  difficulty and generates numbers based on
  option choosen]#
  let difficulty = mainWindow.msgBox("Select game difficulty", "game Mode", "Easy", "medium", "Hard")

  if difficulty == 3:
    generator("hard", btns1, btns2, btns3, btns4, btns5, btns6, btns7, btns8, btns9, col1, col2, col3, col4, col5, col6, col7, col8, col9, box1, box2, box3, box4, box5, box6, box7, box8, box9)
  elif difficulty == 2:
    generator("medium", btns1, btns2, btns3, btns4, btns5, btns6, btns7, btns8, btns9, col1, col2, col3, col4, col5, col6, col7, col8, col9, box1, box2, box3, box4, box5, box6, box7, box8, box9)
  else:
    generator("easy", btns1, btns2, btns3, btns4, btns5, btns6, btns7, btns8, btns9, col1, col2, col3, col4, col5, col6, col7, col8, col9, box1, box2, box3, box4, box5, box6, box7, box8, box9)

  for each in btns1:
    mainContainer.add(each)
    each.fontSize = 24
    each.fontFamily = "San-Serif"
    each.width = SIZE
    each.height = SIZE
    each.textColor = black
    each.x = pos
    each.y = 0
    each.setBackgroundColor(white)

    if each == btns1[2] or each == btns1[5]:
      pos += S_SIZE
    else:
      pos += N_SIZE

  pos = 0
  for each in btns2:
    mainContainer.add(each)
    each.fontSize = 24
    each.fontFamily = "San-Serif"
    each.width = SIZE
    each.height = SIZE
    each.textColor = black
    each.x = pos
    each.y = SIZE
    each.setBackgroundColor(white)

    if each == btns2[2] or each == btns2[5]:
      pos += S_SIZE
    else:
      pos += N_SIZE

  pos = 0
  for each in btns3:
    mainContainer.add(each)
    each.fontSize = 24
    each.fontFamily = "San-Serif"
    each.width = SIZE
    each.height = SIZE
    each.textColor = black
    each.x = pos
    each.y = 2*(SIZE)
    each.setBackgroundColor(white)

    if each == btns3[2] or each == btns3[5]:
      pos += S_SIZE
    else:
      pos += N_SIZE

  pos = 0
  for each in btns4:
    mainContainer.add(each)
    each.fontSize = 24
    each.fontFamily = "San-Serif"
    each.width = SIZE
    each.height = SIZE
    each.textColor = black
    each.x = pos
    each.y = 2*(SIZE) + S_SIZE
    each.setBackgroundColor(white)

    if each == btns4[2] or each == btns4[5]:
      pos += S_SIZE
    else:
      pos += N_SIZE

  pos = 0
  for each in btns5:
    mainContainer.add(each)
    each.fontSize = 24
    each.fontFamily = "San-Serif"
    each.width = SIZE
    each.height = SIZE
    each.textColor = black
    each.x = pos
    each.y = 4*(SIZE) + ((S_SIZE)/4).toInt
    each.setBackgroundColor(white)

    if each == btns5[2] or each == btns5[5]:
      pos += S_SIZE
    else:
      pos += N_SIZE

  pos = 0
  for each in btns6:
    mainContainer.add(each)
    each.fontSize = 24
    each.fontFamily = "San-Serif"
    each.width = SIZE
    each.height = SIZE
    each.textColor = black
    each.x = pos
    each.y = 5*(SIZE) + ((S_SIZE)/4).toInt
    each.setBackgroundColor(white)

    if each == btns6[2] or each == btns6[5]:
      pos += S_SIZE
    else:
      pos += N_SIZE

  pos = 0
  for each in btns7:
    mainContainer.add(each)
    each.fontSize = 24
    each.fontFamily = "San-Serif"
    each.width = SIZE
    each.height = SIZE
    each.textColor = black
    each.x = pos
    each.y = 5*(SIZE) + S_SIZE + ((S_SIZE)/4).toInt
    each.setBackgroundColor(white)

    if each == btns7[2] or each == btns7[5]:
      pos += S_SIZE
    else:
      pos += N_SIZE

  pos = 0
  for each in btns8:
    mainContainer.add(each)
    each.fontSize = 24
    each.fontFamily = "San-Serif"
    each.width = SIZE
    each.height = SIZE
    each.textColor = black
    each.x = pos
    each.y = 7*(SIZE) + (2*(S_SIZE/4)).toInt
    each.setBackgroundColor(white)

    if each == btns8[2] or each == btns8[5]:
      pos += S_SIZE
    else:
      pos += N_SIZE

  pos = 0
  for each in btns9:
    mainContainer.add(each)
    each.fontSize = 24
    each.fontFamily = "San-Serif"
    each.width = SIZE
    each.height = SIZE
    each.textColor = black
    each.x = pos
    each.y = 8*(SIZE) + (2*(S_SIZE/4)).toInt
    each.setBackgroundColor(white)

    if each == btns9[2] or each == btns9[5]:
      pos += S_SIZE
    else:
      pos += N_SIZE
  pos = 0

  var start = getMonoTime()
  var btn = newButton("submit")
  mainContainer.add(btn)
  btn.width = 3*(SIZE) + 3
  btn.height = SIZE
  btn.x = 2*(3*(SIZE) + (S_SIZE - N_SIZE))
  btn.y = 9*(SIZE) + (2*(S_SIZE/4)).toInt + 3
  btn.onClick = proc(event : ClickEvent) = 
    let msg = mainWindow.msgBox(g_logic(start, btns1, btns2, btns3, btns4, btns5, btns6, btns7, btns8, btns9, col1, col2, col3, col4, col5, col6, col7, col8, col9, box1, box2, box3, box4, box5, box6, box7, box8, box9), "", "restart", "quit")
    if msg == 2:
      mainWindow.dispose()
    elif msg == 1:
      s_layout()
      mainWindow.dispose()

  var btn2 = newButton("About")
  mainContainer.add(btn2)
  btn2.width = 3*(SIZE) + 3
  btn2.height = SIZE
  btn2.x = 0
  btn2.y = 9*(SIZE) + (2*(S_SIZE/4)).toInt + 3
  btn2.onClick = proc(event : ClickEvent) = 
    mainWindow.alert("""This is a sudoku game made with Nim_Lang using the nigui GUI libray by C_nerd
To win a game of sudoku simply guess the numbers that goes on the empty slots and the
number guessed must not appear again in the same row and column and also in the same box
now using this rule fill all empty slots
    
Have fun playing.""", "ABOUT")

  mainWindow.show()

s_layout()
app.run()