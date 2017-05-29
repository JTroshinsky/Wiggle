import android.*;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.res.*;
import android.content.res.Configuration;
import android.database.Cursor;
import android.graphics.*;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.*;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.opengl.*;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Base64;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View.OnClickListener;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.Toast;
import controlP5.*;
import java.io.*;
import java.lang.Object.*;
import java.nio.*;
import javax.microedition.khronos.opengles.*;
import processing.core.PConstants;
import processing.core.PImage;
import android.graphics.Matrix;

PImage logo;

PImage target;
PVector targetLocationOne;
PVector targetLocationTwo;
PVector targetLocationThree;
int timer=0;

boolean reloadButtons=false;
boolean widescreen = false;

int chooseImage=1;
Bitmap fullPictureOne;
Bitmap fullPictureTwo;
Bitmap fullPictureThree;
Bitmap scalePictureOne;
Bitmap scalePictureTwo;
Bitmap scalePictureThree;
PImage previewPictureOne;
PImage previewPictureTwo;
PImage previewPictureThree;
PImage pictureOne=null;
PImage pictureTwo=null;
PImage pictureThree=null;
Animation preview;

ControlP5 cp5;
PFont pfont = createFont("Arial", 20, true);
ControlFont font = new ControlFont(pfont, 40);
Button b1;
Button b2;
Button b3;
Button b4;
Button b5;
Button b6;
Button b7;
Button b8;
Button b9;
Button b10;
Button b11;
Button b12;

Activity act;
Context mC;
public void onStart() {
  super.onStart();
  act = this.getActivity();
  mC= act.getApplicationContext();
}

float scene=0;
//Scene 0 - Home screen
//Scene 1 - Choose Images
//Scene 2 - Locate subject
//Scene 3 - Preview and export

public void setup() {  
  size(displayWidth, displayHeight);
  orientation(PORTRAIT);
  frameRate(30);
  textSize(50);

  cp5 = new ControlP5(this);

  logo=loadImage("wLogoBlack.png");
  logo.resize(displayWidth/2, displayWidth/2);
  target=loadImage("target.png");
  target.resize(displayWidth/10, displayWidth/10);

  createButtons();
}

public void draw() {
  background(255);
  if (scene==0)  
    sceneZero(); 
  if (scene==1)  
    sceneOne();
  if (scene==2||scene==2.1||scene==2.2)  
    sceneTwo();  
  if (scene==3)  
    sceneThree();
}

//Scene 0 - Home screen----------------------------------------
public void sceneZero() {
  background(42, 46, 57);
  image(logo, displayWidth/2-logo.width/2, displayHeight/10);

  if (reloadButtons==true) {
    createButtons();    
    reloadButtons=false;
  }  
  cp5.remove("Choose image one");
  cp5.remove("Choose image two");
  cp5.remove("Choose image three");
  cp5.remove("Take more pictures");
  cp5.remove("Next");
  cp5.remove("Back");
  cp5.remove("Next ");
  cp5.remove("Back ");
  cp5.remove("Reset");
  cp5.remove("Save");
  cp5.remove("Back  ");
}

//Scene 1 - Choose Images------------------------------------
public void sceneOne() {  
  background(42, 46, 57);

  if (reloadButtons==true) {
    createButtons();    
    reloadButtons=false;
  }  
  cp5.remove("Start");
  cp5.remove("Directions");
  cp5.remove("Next ");
  cp5.remove("Back ");
  cp5.remove("Reset");
  cp5.remove("Save");
  cp5.remove("Back  ");

  if (previewPictureOne!=null) { 
    b2.setImage(previewPictureOne);
  }
  if (previewPictureTwo!=null) {   
    b3.setImage(previewPictureTwo);
  }
  if (previewPictureThree!=null) {   
    b12.setImage(previewPictureThree);
  }  
  
}

//Scene 2 - Choose subject one----------------------------------

public void sceneTwo() {
  background(42, 46, 57);
  if (reloadButtons==true) {
    createButtons();   
    timer=0;
    reloadButtons=false;
  }  

  cp5.remove("Start");
  cp5.remove("Directions");
  cp5.remove("Choose image one");
  cp5.remove("Choose image two");
  cp5.remove("Choose image three");
  cp5.remove("Take more pictures");
  cp5.remove("Next");
  cp5.remove("Back"); 
  cp5.remove("Save");
  cp5.remove("Back  ");  


  if (timer<=15) {
    timer++;
  }    

  if (scene==2) {
    if (mousePressed&&timer>15) {
      targetLocationOne=new PVector(mouseX, mouseY-200);
    }

    image(pictureOne, 0, 0);
    if (targetLocationOne!=null)
      image(target, targetLocationOne.x-target.width/2, targetLocationOne.y-target.width/2);
  }

  if (scene==2.1) {
    if (mousePressed&&timer>15) {
      targetLocationTwo=new PVector(mouseX, mouseY-200);
    }

    image(pictureTwo, 0, 0);
    if (targetLocationTwo!=null)
      image(target, targetLocationTwo.x-target.width/2, targetLocationTwo.y-target.width/2);
  }

  if (scene==2.2) {
    if (mousePressed&&timer>15) {
      targetLocationThree=new PVector(mouseX, mouseY-200);
    }

    image(pictureThree, 0, 0);
    if (targetLocationThree!=null)
      image(target, targetLocationThree.x-target.width/2, targetLocationThree.y-target.width/2);
  }
}

//Scene 3 - Preview and export Gif -------------------------------------
public void sceneThree() {
  background(42, 46, 57);
  if (reloadButtons==true) {
    createButtons();    
    reloadButtons=false;
    preview = new Animation();
  }
  cp5.remove("Start");
  cp5.remove("Directions");
  cp5.remove("Choose image one");
  cp5.remove("Choose image two");
  cp5.remove("Choose image three");
  cp5.remove("Take more pictures");
  cp5.remove("Next");
  cp5.remove("Back");
  cp5.remove("Next ");
  cp5.remove("Back ");
  cp5.remove("Reset");

  preview.display();
}

class Animation {
  ArrayList<PImage> images;
  int imageCount;
  int frame;

  Animation() {
    imageCount = 2;
    images = new ArrayList<PImage>();
    if (pictureOne!=null)
      images.add(pictureOne);
    if (pictureTwo!=null)
      images.add(pictureTwo);
    if (pictureThree!=null)
      images.add(pictureThree);
    if (pictureTwo!=null&&pictureThree!=null)
      images.add(pictureTwo);
  }

  void display() {
    frame++;
    if (frame>images.size()-1)  
      frame=0;
    delay(150);
    if (frame==0)
      image(images.get(0), 0, 0);
    if (frame==1||frame==3)
      image(images.get(1), targetLocationOne.x-targetLocationTwo.x, targetLocationOne.y-targetLocationTwo.y); 
    if (frame==2)
      image(images.get(2), targetLocationOne.x-targetLocationThree.x, targetLocationOne.y-targetLocationThree.y);
  }
}


//Create and save Gif -----------------------------------------
public void saveGIF() {
  FileOutputStream outStream = null;
  try {
    File root = Environment.getExternalStorageDirectory();
    File file = new File(root.getAbsolutePath()+"/DCIM/Camera/testGif"+day()+"-"+month()+","+hour()+":"+minute()+"_"+(int)random(0, 100)+".gif");
    outStream = new FileOutputStream(file);
    outStream.write(generateGIF());
    outStream.close();
     
  }
  catch(Exception e) {  
    e.printStackTrace();
  }
}

public byte[] generateGIF() {
  
  if (fullPictureOne!=null&&widescreen)
    fullPictureOne=rotatePicture(fullPictureOne,-90);
  if (fullPictureTwo!=null&&widescreen)
    fullPictureTwo=rotatePicture(fullPictureTwo,-90);
  if (fullPictureThree!=null&&widescreen) 
    fullPictureThree=rotatePicture(fullPictureThree,-90); 
  
  ArrayList<Bitmap> bitmaps = new ArrayList<Bitmap>();
  if (fullPictureOne!=null)
    bitmaps.add(fullPictureOne);
  if (fullPictureTwo!=null)
    bitmaps.add(fullPictureTwo);
  if (fullPictureThree!=null) {
    bitmaps.add(fullPictureThree);
    bitmaps.add(fullPictureTwo);
  }
  ByteArrayOutputStream bos = new ByteArrayOutputStream();
  AnimatedGifEncoder encoder = new AnimatedGifEncoder();
  encoder.start(bos);
  for (Bitmap bitmap : bitmaps) {
    encoder.addFrame(bitmap);
  }
  encoder.finish();
  return bos.toByteArray();
}

public Bitmap rotatePicture(Bitmap source,float angle){
  Matrix matrix = new Matrix();
  matrix.postRotate(angle);  
  return Bitmap.createBitmap(source, 0, 0, source.getWidth(), source.getHeight(), matrix, true);
}


//Choose image from gallery----------------------------------
public void pickImage(int img) {
  chooseImage=img;
  Intent intent = new Intent(Intent.ACTION_PICK, android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
  intent.setType("image/*");
  startActivityForResult(intent, 1);
}

@Override
  void onActivityResult(int requestCode, int resultCode, Intent data) {
  super.onActivityResult(requestCode, resultCode, data);
  if (requestCode==1) {
    if (resultCode==Activity.RESULT_OK) {
      if (data!=null) {
        Uri selectedImage = data.getData();

        InputStream imageStream = null;
        try {
          imageStream = mC.getContentResolver().openInputStream(
            selectedImage);
        } 
        catch (FileNotFoundException e) {
          
          e.printStackTrace();
        }

        Bitmap bimg = BitmapFactory.decodeStream(imageStream);    
        Bitmap previewbimg = Bitmap.createScaledBitmap(bimg, displayWidth, displayHeight/3, true);
        Bitmap scalebimg;
        
        if (bimg.getWidth()>bimg.getHeight()) {          
          double scale=bimg.getWidth()/bimg.getHeight();          
          scalebimg= Bitmap.createScaledBitmap(bimg,(int)(displayHeight/scale),displayWidth, true);
          scalebimg=rotatePicture(scalebimg,90);
          bimg=rotatePicture(bimg,90);
          widescreen=true;
        } else {
          double scale=bimg.getHeight()/bimg.getWidth();
          scalebimg= Bitmap.createScaledBitmap(bimg, (int)(displayWidth/scale), (int)(displayHeight), true);
          widescreen=false;
        } 

        PImage previewimg=new PImage(previewbimg.getWidth(), previewbimg.getHeight(), PConstants.ARGB);
        previewbimg.getPixels(previewimg.pixels, 0, previewimg.width, 0, 0, previewimg.width, previewimg.height);
        previewimg.updatePixels();   

        PImage img=new PImage(scalebimg.getWidth(), scalebimg.getHeight(), PConstants.ARGB);
        scalebimg.getPixels(img.pixels, 0, img.width, 0, 0, img.width, img.height);
        img.updatePixels(); 

        if (chooseImage==1) {
          fullPictureOne=scalebimg; //was bimg, changed to scale to prevent crash
          scalePictureOne=scalebimg;
          pictureOne=img;
          previewPictureOne=previewimg;
        } else if (chooseImage==2) {
          fullPictureTwo=scalebimg; //was bimg, changed to scale to prevent crash
          scalePictureTwo=scalebimg;
          pictureTwo=img;
          previewPictureTwo=previewimg;
        } else if (chooseImage==3) {
          fullPictureThree=scalebimg; //was bimg, changed to scale to prevent crash
          scalePictureThree=scalebimg;
          pictureThree=img;
          previewPictureThree=previewimg;
        }
      }
    }
  }
}

//Take more pictures----------------------------------------
public void takePicture() {
  Intent intent= new Intent(MediaStore.INTENT_ACTION_VIDEO_CAMERA);
  getActivity().startActivityForResult(intent, 2);
}

//Open to direction page------------------------------------
public void directionLink() {
  Uri uri = Uri.parse("http://www.adorama.com/alc/0011780/article/Wiggle-3D-How-To-Make-Animated-3D-Images"); 
  Intent intent = new Intent(Intent.ACTION_VIEW, uri);
  startActivity(intent);
}

//Create the button-----------------------------------------
public void createButtons() {
  //Scene 0 ----------------------------
  b1=cp5.addButton("Start")
    .setPosition(displayWidth/6*1, displayHeight/8*4)
    .setSize(displayWidth/6*4, displayHeight/8*1)
    .setFont(font)
    .setId(1); 
  b1.setColorBackground(color(84, 86, 93));
  b1.isSwitch();    
  b1.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      switch(theEvent.getAction()) {
        case(ControlP5.ACTION_PRESSED):
        reloadButtons=true;
        ; 
        case(ControlP5.ACTION_RELEASED): 
        scene=1; 
        break;
      }
    }
  }
  );     

  b7=cp5.addButton("Directions")
    .setPosition(displayWidth/6*1, displayHeight/16*11)
    .setSize(displayWidth/6*4, displayHeight/8*1)
    .setFont(font)
    .setId(1); 
  b7.setColorBackground(color(84, 86, 93));
  b7.isSwitch();    
  b7.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      switch(theEvent.getAction()) {
        case(ControlP5.ACTION_PRESSED):
        reloadButtons=true; 
        ; 
        case(ControlP5.ACTION_RELEASED): 
        directionLink(); 
        break;
      }
    }
  }
  );

  //Scene 1 ----------------------------      
  b2=cp5.addButton("Choose image one")
    .setPosition(0, 0)
    .setSize(displayWidth, (int)(displayHeight*.6666/3))
    .setFont(font)
    .setId(1);  
  b2.setColorBackground(color(47, 51, 64));
  b2.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      switch(theEvent.getAction()) {
        case(ControlP5.ACTION_PRESSED): 
        pickImage(1); 
        case(ControlP5.ACTION_RELEASED): 
        ;
        break;
      }
    }
  }
  );

  b3=cp5.addButton("Choose image two")
    .setPosition(0, (int)(displayHeight*.6666/3))
    .setSize(displayWidth, (int)(displayHeight*.6666/3))
    .setFont(font)
    .setId(1);    
  b3.setColorBackground(color(42, 46, 57));
  b3.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      switch(theEvent.getAction()) {
        case(ControlP5.ACTION_PRESSED):
        pickImage(2); 
        case(ControlP5.ACTION_RELEASED):
        ; 
        break;
      }
    }
  }
  );

  b12=cp5.addButton("Choose image three")
    .setPosition(0, (int)(displayHeight*.6666/3)*2)
    .setSize(displayWidth, (int)(displayHeight*.6666/3))
    .setFont(font)
    .setId(1);    
  b12.setColorBackground(color(47, 51, 64));
  b12.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      switch(theEvent.getAction()) {
        case(ControlP5.ACTION_PRESSED):
        pickImage(3); 
        case(ControlP5.ACTION_RELEASED):
        ; 
        break;
      }
    }
  }
  );

  b4=cp5.addButton("Take more pictures")
    .setPosition(0, displayHeight/3*2)
    .setSize(displayWidth, displayHeight/6)
    .setFont(font)
    .setId(1);   
  b4.setColorBackground(color(42, 46, 57));
  b4.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      switch(theEvent.getAction()) {
        case(ControlP5.ACTION_PRESSED):
        takePicture(); 
        ; 
        case(ControlP5.ACTION_RELEASED):
        ; 
        break;
      }
    }
  }
  ); 

  b5=cp5.addButton("Next")
    .setPosition(displayWidth/4, (displayHeight-(displayHeight/3*2))/2+displayHeight/3*2)
    .setSize(displayWidth/4*3, displayHeight/3/2)
    .setFont(font)
    .setId(1);   
  b5.setColorBackground(color(47, 51, 64));
  b5.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {       
      if (previewPictureOne!=null||previewPictureTwo!=null) {
        switch(theEvent.getAction()) {
          case(ControlP5.ACTION_PRESSED):
          reloadButtons=true;
          ; 
          case(ControlP5.ACTION_RELEASED): 
          scene=2; 
          break;
        }
      }
    }
  }
  ); 

  b6=cp5.addButton("Back")
    .setPosition(0, (displayHeight-(displayHeight/3*2))/2+displayHeight/3*2)
    .setSize(displayWidth/4, displayHeight/3/2)
    .setFont(font)
    .setId(1);   
  b6.setColorBackground(color(47, 51, 64));
  b6.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {    
      switch(theEvent.getAction()) {
        case(ControlP5.ACTION_PRESSED):
        reloadButtons=true;
        ; 
        case(ControlP5.ACTION_RELEASED): 
        scene=0; 
        break;
      }
    }
  }
  );

  //Scene 2 ----------------------------
  b11=cp5.addButton("Next ")
    .setPosition(displayWidth/4, (displayHeight-(displayHeight/3*2))/2+displayHeight/3*2)
    .setSize(displayWidth/4*3, displayHeight/3/2)
    .setFont(font)
    .setId(1);   
  b11.setColorBackground(color(47, 51, 64));
  b11.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {       
      if (previewPictureOne!=null||previewPictureTwo!=null) {
        switch(theEvent.getAction()) {
          case(ControlP5.ACTION_PRESSED):
          reloadButtons=true;
          ; 
          case(ControlP5.ACTION_RELEASED): 
          if (scene==2)scene=2.1;
          else if (scene==2.1&&pictureThree!=null)scene=2.2;
          else if (scene==2.1)scene=3;
          else if (scene==2.2)scene=3; 
          break;
        }
      }
    }
  }
  ); 

  b10=cp5.addButton("Back ")
    .setPosition(0, (displayHeight-(displayHeight/3*2))/2+displayHeight/3*2)
    .setSize(displayWidth/4, displayHeight/3/2)
    .setFont(font)
    .setId(1);   
  b10.setColorBackground(color(47, 51, 64));
  b10.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {    
      switch(theEvent.getAction()) {
        case(ControlP5.ACTION_PRESSED):
        reloadButtons=true;
        ; 
        case(ControlP5.ACTION_RELEASED): 
        if (scene==2)scene=1;
        else if (scene==2.1)scene=2;
        else if (scene==2.2)scene=2.1;
        ; 
        break;
      }
    }
  }
  );

  //Scene 3 ---------------------------
  b8=cp5.addButton("Save")
    .setPosition(displayWidth/4, (displayHeight-(displayHeight/3*2))/2+displayHeight/3*2)
    .setSize(displayWidth/4*3, displayHeight/3/2+5)
    .setFont(font)
    .setId(1);   
  b8.setColorBackground(color(47, 51, 64));
  b8.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {       
      if (previewPictureOne!=null||previewPictureTwo!=null) {
        switch(theEvent.getAction()) {
          case(ControlP5.ACTION_PRESSED):
          reloadButtons=true;
          ; 
          case(ControlP5.ACTION_RELEASED): 
          saveGIF(); 
          break;
        }
      }
    }
  }
  ); 

  b9=cp5.addButton("Back  ")
    .setPosition(0, (displayHeight-(displayHeight/3*2))/2+displayHeight/3*2)
    .setSize(displayWidth/4, displayHeight/3/2+5)
    .setFont(font)
    .setId(1);   
  b9.setColorBackground(color(47, 51, 64));
  b9.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {    
      switch(theEvent.getAction()) {
        case(ControlP5.ACTION_PRESSED):
        reloadButtons=true;
        ; 
        case(ControlP5.ACTION_RELEASED): 
        scene=2; 
        break;
      }
    }
  }
  );
}