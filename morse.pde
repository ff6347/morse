// Copyright (C) 2011 Fabian "fabiantheblind" Morón Zirfas
// http://www.the-moron.net
// http://fabiantheblind.info/
// info [at] the - moron . net

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses

// NOTE: the board and the frontend do both a decoding from text to morsecode
// the board does it one way. it takes chars and shows thema as morse code
// the MorseCode Class can do both encode and decode
// 


import org.seltar.Bytes2Web.*;
import processing.serial.*;
import controlP5.*;


boolean DEBUG = true; // the debugging stuff
MorseCode morse; // the morse class
Serial port; // the usb port to comunicate with the board

String lastMorseMSG = ""; // this stores the last saved message
String lastClearMSG = ""; // this stores the last clear message

PImage overlay01; // this is the helptip for the button
PImage overlay02; // this is the help overlay


String msg2morse = ""; // this is the message that will be send to the board
String person = "nameless"; // the person who is there
String otherPerson = "not you"; // the other



int tinter = 255;// tint the help overlay
int tinterConsole = 255;


boolean newConsoleMsg = false; // to know if the console has changed
int newConsoleMsgStart = 0; // this should fade out the console

 // the dropdown states
boolean MONA = false; // this is person one
boolean TOM = false; // this is person two
boolean BOTH = false; // this alows to send messages to both
boolean OPTIONS = false; // thisis not working right now



// this is for the upload
String keys []; // holds the strings that refer to the messages of the users
String ul_url = ""; // the URL for the upload
String theMessage_url = "";// this will hold the url of  the message

// GUI ELEMETNS
ControlP5 controlP5;
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
  size(700, 400);

  
  keys  = loadStrings("private.txt"); // sry got to keep this private the urls we are using
  ul_url  = keys[0]; // this is the url for the Upload.php to the server see postToWeb lib by seltar     

  overlay01 = loadImage("overlay_help.png"); // the tiny help thing down right
  overlay02 = loadImage("help.png"); // the help tips

  // this is the port thingy
  if(DEBUG)println("Available serial ports:");
  if(DEBUG)println(Serial.list());
  
  port = new Serial(this, Serial.list()[0], 9600);  // connect at port 0 to the board

  morse = new MorseCode();


   setupGUI();

  // this is for clearing out the console
  setConsole("Hello. Select who you are in the upper left corner than you can play with me!");
}

void draw() {
  background(255);
  drawGUI();
  resetConsole();
}


/**
 * get a string array with morsecode in it and decode it 
 * sets msg2morse
 * this is what will be send to the board
 *
 */
void getAndDecode(String inStr []) {
  String incomingMorse = join(inStr, " ");
  String incomingDecoded = morse.stringFromMorse(incomingMorse);
  msg2morse  = incomingDecoded;
  if(DEBUG) println(incomingDecoded);
}

/**
 * This sends via serial port data to the arduino board
 * 
 */

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


/**
 * Reset the console in the lower left corner
 * 
 */

void resetConsole() {

  if (newConsoleMsg) {

    if (millis() > (newConsoleMsgStart + 15000)) {
      
      console.setValue("");
        console.setColorValue(color(0, 0, 0,tinterConsole));

      newConsoleMsgStart = 0;
      tinterConsole-= 0.5;
      
      if(tinterConsole < 0){
      tinterConsole = 0;
      newConsoleMsg = false;
      }
      
    }
  }
}

/**
 * Set the console in the lower left corner
 * 
 */



void setConsole(String theText) {
  tinterConsole = 255;
          console.setColorValue(color(0, 0, 0));

  console.setValue(theText);
  newConsoleMsg = true;
  newConsoleMsgStart = millis();
}

