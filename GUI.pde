void setupGUI(){

int btnWidth;
int btnHeight;
int ddlWidth;
int ddlHeight;
int GUI_W;
int GUI_H;

int GUI_X;
int GUI_Y;
int GUI_border_left;
int GUI_border_right;

int GUI_gutter;

  GUI_X  = width/2;
  GUI_Y = height/2;
  GUI_W = (width/3) *2;
  GUI_H = 23 ;
  GUI_border_left = GUI_X - (GUI_W/2);
  GUI_border_right = GUI_X + (GUI_W/2);

  GUI_gutter = width/ 42;


  btnWidth = GUI_W/6;
  btnHeight = 16;
  ddlWidth = GUI_W/5;
  ddlHeight = GUI_W/4;


  controlP5 = new ControlP5(this);

  // Textfield and textarea
  //
  //
  //
  
  tf = controlP5.addTextfield("texting", GUI_border_left, GUI_Y - GUI_H/2, GUI_W, GUI_H);
  ta = controlP5.addTextarea( "morsetext", lastMorseMSG, GUI_border_left, GUI_Y + GUI_H/2 + GUI_gutter, GUI_W, GUI_H);
  ta.enableColorBackground();
  ta.setColor(color(0, 0, 0));
  ta.setColorBackground(color(255, 255, 255));

  tf.setLabel("");
  tf.setText("Write your message in here and press ENTER on your keypad. ( hit CLEAR to get rid of this text ) ");

  tf.setFocus(true);
  tf.keepFocus(true);

  //
  // the drop down list
  //
  //
  
  ddList = controlP5.addDropdownList("selector", 10, 25, ddlWidth, ddlHeight);
  ddList.setItemHeight(16);
  ddList.setBarHeight(16);
  ddList.captionLabel().set("Who are you?");
  ddList.captionLabel().style().marginTop = 3;
  ddList.captionLabel().style().marginLeft = 3;
  ddList.valueLabel().style().marginTop = 3;
  ddList.addItem("Mona", 0);
  ddList.addItem("Tom", 1);
  ddList.addItem("Mona & Tom", 2);

  // the buttons
  int buttonY = 100;
  ftch = controlP5.addButton("fetch", 0, GUI_border_right - btnWidth,buttonY, btnWidth, btnHeight);
  snd = controlP5.addButton("send", 0, GUI_border_right - btnWidth -100 - GUI_gutter/10, buttonY, btnWidth, btnHeight);

  clr = controlP5.addButton("clear", 0, GUI_border_left, buttonY, btnWidth, btnHeight);
  shw = controlP5.addButton("show", 0, GUI_border_left + 100 + GUI_gutter/10, buttonY, btnWidth, btnHeight);
  hlp =   controlP5.addToggle("help", false, width -13, height - 13, 13, 13);
  hlp.setLabel("?");

  console = controlP5.addTextlabel("console", "Hello World", 13, height -13);

  console.setColorValue(color(0, 0, 0));
//  checkbox = controlP5.addCheckBox("checkBox",20,20);  
//checkbox.setItemsPerRow(1);
//  checkbox.setSpacingColumn(30);
//  checkbox.setSpacingRow(10);
//  // add items to a checkbox.
//  checkbox.addItem("offline",0);
//  checkbox.addItem("save prefs",10);
//  checkbox.addItem("50",50);
//  checkbox.addItem("100",100);
//  checkbox.addItem("200",200);
//  checkbox.addItem("5",5);
// controlP5.Label label = checkbox.valueLabel();
//  label.setColor(color(255,128));
//  println(checkbox);
  // the options
}


// CONTROL EVENTS CONTROL EVENTSCONTROL EVENT SCONTROL EVENTS

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    //    println(theEvent.group().value()+" from "+theEvent.group());
    //    println(theEvent.group().value());

    if (theEvent.group().value() == 0f) {
      if(DEBUG)println("MONA");
      MONA = true;
      TOM = false;
      BOTH = false;
      OPTIONS = false;

      person = "Mona";
      otherPerson = "Tom";
      theMessage_url = keys[2];// this is the url for the theMessage file

      setConsole("Hello " +person);
    }
    else if (theEvent.group().value() == 1f) {
      if(DEBUG)println("TOM"); 
      MONA = false;
      TOM = true;   
      BOTH = false;
      OPTIONS = false;

      person = "Tom";
      otherPerson = "Mona";

       theMessage_url = keys[1];// this is the url for the theMessage file
      setConsole("Hello " +person);
    } 
    else if (theEvent.group().value() == 2f) {

      println("BOTH"); 

      MONA = true;
      TOM = true; 
      BOTH = true;  
      OPTIONS = false;

      person = "Mona & Tom";
      otherPerson = "the other";

      // theMessage_url = keys[1];// this is the url for the theMessage file
      setConsole("Hello " +person);
    }

    else if (theEvent.group().value() == 3f) {


      MONA = false;
      TOM = false; 
      BOTH = false; 
      OPTIONS = true;

      person = "Mona & Tom";
      otherPerson = "the other";

      // theMessage_url = keys[1];// this is the url for the theMessage file
      setConsole("Hello " +person);
    }
  } 
  //  else if(theEvent.isController()) {
  //    println(theEvent.controller().value()+" from "+theEvent.controller());
  //  }
}





/*
 * Here comes the text from the textfiels
 *
 *
 *
 *
 *
 */
 
 
public void texting(String theText) {
  // receiving text from controller texting

  String in = morse.stringToMorse(theText);
  if(theText.length() > 40){
      setConsole("You wrote: \""+theText.substring(0,40)+"...\"!(and something more ;) ) Now hit send so "+ otherPerson +" can recieve your love note");

  }else{
        setConsole("You wrote: \""+theText+"\" now hit send so "+ otherPerson +" can recieve your love note");


  
  }
  lastMorseMSG  = in;
  lastClearMSG = theText;
  println("this: "+ theText +" means in morse: " + in);
  ta.setText(in);
  tf.setText(theText);
}


/*
 * this clears out the textfield
 * and the textarea below
 *
 *
 *
 *
 */
 
 
void clear() {

  setConsole("You cleared the textfield. Now write something sweet.");
  tf.setText("");
  ta.setText("");
  lastMorseMSG = "";
  lastClearMSG = "";
}

void help(boolean theFlag) {
  if (theFlag==true) {
    setConsole("You opened the help");
  } 
  else {
    setConsole("You closed the help");
  }
  println("a toggle event.");
}







/*
 * send the text to the server
 * needs the postToWeb lib by seltaer
 *
 *
 *
 *
 */
 

void send() {

  println("a button event from write");
  //  theMessage [0] = whosTurn +"";
  //  theMessage [1] = ply1Wins+"";
  //  theMessage [2] = ply2Wins+"";
  //  for(int i = 3; i < theMessage.length ; i++){
  //  theMessage [i] = sectors[i -3].secval +"";
  //  
  //  }
  // write the results to the textfile
  if (TOM) {
    String filename = "tom.txt";
    String msgStrings [] = lastMorseMSG.split("\n");
    saveStrings(dataPath(filename), msgStrings);
    postFileToWeb(filename, lastMorseMSG);  
    setConsole("Well done. Lets hope "+otherPerson+ " replies soon" );
  }
  if (MONA) {
    String filename = "mona.txt";

    String msgStrings [] = lastMorseMSG.split("\n");

    saveStrings(dataPath(filename), msgStrings);
    postFileToWeb(filename, lastMorseMSG);  
    setConsole("Well done. Lets hope "+otherPerson+ " replies soon" );
  } 
  else if ((!MONA) && (!TOM)) {
    setConsole("Hello " + person + " you must decide who you are");
  }
}

/*
 * actually this send the text to the server
 * needs the postToWeb lib by seltaer
 * the void send just outs it all together
 */
 
void postFileToWeb(String fn, String msg) {
  // this is the postToWeb Lib by seltar
  ByteToWeb bytes = new ByteToWeb(this);
  String uploadText = msg;//;= join(theMessage,"\n");
  bytes.post("test", ul_url, fn, true, uploadText.getBytes());
    }



/*
 * This shows the last message
 * in a webbrowser
 *
 *
 *
 *
 */
 
 

void show() {
  if (MONA) {
    link(keys[1]);
    setConsole("I will try to find your last message in the world wide world of webs");

  }
  else if (TOM) {
    setConsole("I will try to find your last message in the world wide world of webs");
    link(keys[2]);
  } 
  else if ((!MONA) && (!TOM)) {
    setConsole("Hello " + person + " you must decide who you are");
  }
}


/*
 * get files from server
 * reading is easy peasy
 * writing to the server needs a lib
 *
 *
 *
 */
 
void fetch() {

  String theMessage [] = new String [100];

  setConsole("Reading from server. You need an internet connection.");

  if (MONA) {
    theMessage = loadStrings(keys[2]);// this could also be a local file but here it is hidden on a server
    if (DEBUG)link(keys[2]);
    getAndDecode(theMessage);

    sendToBoard();
  }
  else  if (TOM) {

    theMessage = loadStrings(keys[1]);// this could also be a local file but here it is hidden on a server
    if (DEBUG)  link(keys[1]);

    getAndDecode(theMessage);


    sendToBoard();
  }
  else if ((!MONA) && (!TOM)) {
    setConsole("Hello " + person + " you must decide who you are");
  }
}



/*
 * 
 * this is what happens within draw
 *
 *
 *
 *
 */
 

void drawGUI(){

  if (hlp.getState() == true) {
    image(overlay02, 0, 0);
    //ta.setColorBackground(color(128,128,128));
    tinter = 255;
  }
  else {
    tint(128, tinter);
    image(overlay01, 0, 0);
    noTint();
    tinter -= 0.5;
    if (tinter < 0) {
      tinter = 0;
    }
  }

  if (BOTH) {

    ftch.lock();
    ftch.setLabel("cant get both");
  }
  else {
    ftch.unlock();
    ftch.setLabel("fetch");
  }

  if (OPTIONS) {
    clr.lock();
    shw.lock();
    snd.lock();
    ftch.lock();
  }
  else {

    clr.unlock();
    shw.unlock();
    snd.unlock();
    ftch.unlock();
  }

}



void customize(DropdownList ddl) {
  //  ddl.setBackgroundColor(color(190));

//  ddl.addItem("Options", 3);

  //  ddl.setColorBackground(color(60));
  //  ddl.setColorActive(color(255,128));
}

