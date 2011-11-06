import org.seltar.Bytes2Web.*;
import processing.serial.*;
import controlP5.*;



/**
 * ControlP5 Textflied.
 * 
 * for a more advanced example see textfieldAdvanced which 
 * demonstrates how to use keepFocus, setText, getText, getTextList,
 * clear, setAutoClear, isAutoClear or submit.
 * by andreas schlegel, 2009
 */

boolean DEBUG = true;
ControlP5 controlP5;
MorseCode morse;
String lastMorseMSG = "";
String lastClearMSG = "";
PImage overlay01;
PImage overlay02;

String msg2morse = "";
String person = "nameless";
String otherPerson = "not you";
Serial port;

int waitPeriod = 3000;
int waitPeriodStart;
int tfWidth;
int tfHeight;
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

int tinter = 255;// tint the help overlay


boolean newConsoleMsg = false;
int newConsoleMsgStart = 0;
boolean MONA = false;
boolean TOM = false;
boolean BOTH = false;
boolean OPTIONS = false;



// this is for the upload
String keys [];
String ul_url = ""; // the URL for the upload
String theMessage_url = "";

//String theMessage [] = new String [100];





String textValue = "";
Textfield tf; // the textfield
Textarea ta;
Toggle hlp;
Textlabel console;
Button ftch;
Button snd;
Button clr;
Button shw;

CheckBox checkbox;





DropdownList ddList;

void setup() {


  keys  = loadStrings("private.txt"); // sry got to keep this private
  ul_url  = keys[0]; // this is the url for the Upload.php to the server see postToWeb lib by seltar     
  String theMessage [] = new String [100];


  //  PFont fnt = loadFont("GentiumBasic-16.vlw"); // use true/false for smooth/no-smooth
  //  font = new ControlFont(fnt);
  //  
  println("Available serial ports:");
  println(Serial.list());
  port = new Serial(this, Serial.list()[0], 9600);  

  morse = new MorseCode();

  size(700, 400);

  overlay01 = loadImage("overlay_help.png");
  overlay02 = loadImage("help.png");

  GUI_X  = width/2;
  GUI_Y = height/2;
  GUI_W = (width/3) *2;
  GUI_H = 23 ;
  GUI_border_left = GUI_X - (GUI_W/2);
  GUI_border_right = GUI_X + (GUI_W/2);

  GUI_gutter = width/ 42;

  tfWidth = 400;
  tfHeight = 200;
  btnWidth = GUI_W/6;
  btnHeight = 16;
  ddlWidth = GUI_W/5;
  ddlHeight = GUI_W/4;

  frameRate(25);
  controlP5 = new ControlP5(this);


  tf = controlP5.addTextfield("texting", GUI_border_left, GUI_Y - GUI_H/2, GUI_W, GUI_H);
  ta = controlP5.addTextarea( "morsetext", lastMorseMSG, GUI_border_left, GUI_Y + GUI_H/2 + GUI_gutter, GUI_W, GUI_H);
  ta.enableColorBackground();
  ta.setColor(color(0, 0, 0));
  ta.setColorBackground(color(255, 255, 255));

  tf.setLabel("");
  tf.setText("Write your message in here and press ENTER on your keypad. ( hit CLEAR to get rid of this text ) ");

  tf.setFocus(true);
  tf.keepFocus(true);

  ddList = controlP5.addDropdownList("selector", 10, 25, ddlWidth, ddlHeight);
  customize(ddList);


  ftch = controlP5.addButton("fetch", 0, GUI_border_right - btnWidth, 100, btnWidth, btnHeight);
  snd = controlP5.addButton("send", 0, GUI_border_right - btnWidth -100 - GUI_gutter/10, 100, btnWidth, btnHeight);

  clr = controlP5.addButton("clear", 0, GUI_border_left, 100, btnWidth, btnHeight);
  shw = controlP5.addButton("show", 0, GUI_border_left + 100 + GUI_gutter/10, 100, btnWidth, btnHeight);
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

  //  try{
  //  read();// this reads the theMessage from the server
  //  }catch(Exception e){
  ////  textLabel.setValue(labelStrings[2]);
  //println("Error reading");  
  //}
  // this is for clearing out the console
  setConsole("Hello. Select who you are in the upper left corner than you can play with me!");
}

void draw() {
  background(255);
  if (hlp.getState() == true) {
    image(overlay02, 0, 0);
    //ta.setColorBackground(color(128,128,128));
    tinter = 255;
  }
  else {
    tint(128, tinter);
    image(overlay01, 0, 0);
    noTint();
    tinter --;
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
  resetConsole();
}


void controlEvent(ControlEvent theEvent) {
  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    //    println(theEvent.group().value()+" from "+theEvent.group());
    //    println(theEvent.group().value());

    if (theEvent.group().value() == 0f) {
      println("MONA");
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
      println("TOM"); 
      MONA = false;
      TOM = true;   
      BOTH = false;
      OPTIONS = false;

      person = "Tom";
      otherPerson = "Mona";

      // theMessage_url = keys[1];// this is the url for the theMessage file
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




  // saveStrings("/Desktop/theMessage.txt", theMessage);
}

void show() {
  if (MONA) {
    link(keys[1]);
  }
  else if (TOM) {
    link(keys[2]);
  } 
  else if ((!MONA) && (!TOM)) {
    setConsole("Hello " + person + " you must decide who you are");
  }
}

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



void getAndDecode(String inStr []) {

  String incomingMorse = join(inStr, " ");
  String incomingDecoded = morse.stringFromMorse(incomingMorse);
  msg2morse  = incomingDecoded;
  println(incomingDecoded);
}

void sendToBoard() {

  String theText = msg2morse;
  println(theText );
  for (int i =0; i < theText.length();i++) {
    char c = theText.charAt(i);
    port.write(c + '\0');
    byte b = 10;
    port.write(b);
  }
}
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
void customize(DropdownList ddl) {
  //  ddl.setBackgroundColor(color(190));
  ddl.setItemHeight(16);
  ddl.setBarHeight(16);
  ddl.captionLabel().set("Who are you?");
  ddl.captionLabel().style().marginTop = 3;
  ddl.captionLabel().style().marginLeft = 3;
  ddl.valueLabel().style().marginTop = 3;
  ddl.addItem("Mona", 0);
  ddl.addItem("Tom", 1);
  ddl.addItem("Mona & Tom", 2);
//  ddl.addItem("Options", 3);



  //  ddl.setColorBackground(color(60));
  //  ddl.setColorActive(color(255,128));
}



void resetConsole() {

  if (newConsoleMsg) {

    if (millis() == (newConsoleMsgStart + 15000)) {
      console.setValue("");
      newConsoleMsgStart = 0;
      newConsoleMsg = false;
    }
  }
}

void setConsole(String theText) {

  console.setValue(theText);
  newConsoleMsg = true;
  newConsoleMsgStart = millis();
}


// function buttonB will receive changes from 
// controller with name buttonB
// writes the values to the textfile
public void write() {
}// close write

void postFileToWeb(String fn, String msg) {
  // this is the postToWeb Lib by seltar
  ByteToWeb bytes = new ByteToWeb(this);
  String uploadText = msg;//;= join(theMessage,"\n");
  bytes.post("test", ul_url, fn, true, uploadText.getBytes());
}


