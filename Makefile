entity.cpp                                                                                          000644  000765  000024  00000003471 12630067515 013211  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /** CpSc 2100
  "virtual" methods are defined in the entity_t class definition that
  allows methods referenced by a base class pointer to actually
  invoke the function in the derived class (e.g. the dump() or hits()
  function in the derived class).
**/

#include "entity.h"

using namespace std;

// Constructor
entity_t:: entity_t()
{
   this->type = -1;
   this->code = -1;
   this->name = "unknown";
}

entity_t:: entity_t(ifstream &infile, const string type, int code){
   this->type = type;
   this->code = code;
   load(infile);
}

/**
  When we define virtual functions in a class, we also need to
  define a "virtual" destructor in the base class.  In this
  case this is a "do nothing" destructor.
**/
entity_t:: ~entity_t() {
  // do nothing
}

// Methods
void entity_t::load(ifstream &infile)
{
   string token;
   infile >> token;
   while(token != ";")
   {
      if (token == "name") {
         infile >> name;
      }
      else 
      {
         cerr << "entity_t::load: Unknown attribute \"" << token 
              << "\"" 
              << endl; 
         exit(1);
      }

      infile >> token;
   }
}

string entity_t::gettype() {
   return type;
}

string entity_t::getname() {
   return name;
}

/**
  Even though the following method in the base class should never
  be invoked since it is a virtual function, we still need to
  define it to keep the compiler happy.
**/
int entity_t:: hits(myvector_t base, myvector_t dir, hitinfo_t &hit) {
   cerr << "In entity_t hits function -- WHY?: objname=" 
        << name << endl;

   return(-1);
}

/**
 dump() is also defined as a virtual function, but it is also directly
 invoked from the derived classes (sobj_t and light_t).
**/
void entity_t:: dump() {
   cerr << "\nEntity name:   ";
   cerr << name;
   cerr << "\n   type =      ";
   cerr << type;
   cerr << endl;
}
                                                                                                                                                                                                       entity.h                                                                                            000644  000765  000024  00000002733 12630067515 012656  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /** CpSc 2100

    Note use of "virtual" methods below.  The virtual modifier
    allows a method to be redefined in a derived class (something
    we can do with or without the virtual modifier) AND results in
    the method in the derived class being invoked when referenced
    via a pointer to the base class.

    Note that we have to provide a virtual destructor, even if it is
    a do nothing destructor, and that the code for the virtual method
    must be provided in the base class even if it is over-riden in the
    derived class and never called.

    For this demonstration example the virtual modifier is only used
    for load(), dump() and hits().  In a full implementation of the 
    ray tracer we would make many more functions virtual.

**/

#ifndef ENT_H
#define ENT_H

#include <iostream>
#include <fstream>
#include <stdlib.h>
#include "hitinfo.h"
#include "myvector.h"
#include "mycolor.h"

class entity_t 
{
   public:
      entity_t();

      // Constructor
      entity_t(ifstream &infile, const string entTypeVal,
               int entcode);
      virtual ~entity_t();           // Note virtual destructor

      // Methods
      virtual void load(ifstream &infile);
      virtual void dump();
      virtual int hits(myvector_t base, myvector_t dir, hitinfo_t &hit);
      string gettype();
      string getname();

  protected:
      string type;
      string name;
      int    code;

  private:
     // Commented out to avoid warnings
     // int magic;
};

#endif
                                     hitinfo.cpp                                                                                         000644  000765  000024  00000001055 12630067515 013331  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /** CPSC 2100 
    hitinfo_t class 
    A hitinfo_t is used to pass information about a hit on an entity
**/

#include "hitinfo.h"

using namespace std;

void hitinfo_t::setdistance(const double &value) 
{
   distance = value;
}

void hitinfo_t::sethitpoint(const myvector_t &H) 
{
   hitpoint = H;
}

void hitinfo_t::setnormal(const myvector_t &N) 
{
   normal = N;
}

double   hitinfo_t::getdistance() 
{ 
   return(distance); 
}

myvector_t hitinfo_t::gethitpoint() 
{ 
   return(hitpoint); 
}

myvector_t hitinfo_t::getnormal() 
{ 
   return(normal);
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   hitinfo.h                                                                                           000644  000765  000024  00000000726 12630067515 013002  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         #ifndef HITINFO_H
#define HITINFO_H

#include <iostream>
#include "myvector.h"

using namespace std;

class hitinfo_t {
   public:
      void     setdistance(const double &value);
      void     sethitpoint(const myvector_t &H);
      void     setnormal(const myvector_t &N);
      double   getdistance();
      myvector_t gethitpoint();
      myvector_t getnormal();

  protected:
      double   distance;
      myvector_t hitpoint;
      myvector_t normal;
};

#endif
                                          image.c                                                                                             000644  000765  000024  00000010300 12630067515 012404  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         
#include "image.h"
/** newImage 

    Create and initialize a new image_t.

    Prototype:
       image_t *newImage(int columns, int rows, int brightness);
 
    where
       columns: number of pixel columns in new PPM image
       rows:    number of pixel rows in new PPM image
       brightness:  pixel brightness (0-255)

    Return value:
       Pointer to newly allocated and initialized image_t
**/

image_t *newImage(int columns, int rows, int brightness) {
   image_t *newImage;

   /* Allocate a new image_t */
   newImage = (image_t *)malloc(sizeof(image_t));
   
   /* Initialize image_t, and allocate space for image */
   newImage->rows       = rows;
   newImage->columns    = columns;
   newImage->brightness = brightness;
   newImage->image      = 
       (pixel_t *)malloc(newImage->columns * newImage->rows * sizeof(pixel_t));

   return(newImage);
}

void deleteImg(image_t *inImage) {
  delete[](inImage);
}

/** outImag

    Output a PPM image to a specified file. 

    Prototype:
       void outImage(ofstream &outfile, image_t *tintedImage);

    where
       outfile:    pointer to the output file to create,
       tintedImage: pointer to the image_t of the image to write.

**/
#include "image.h"

/** outImage **/
void outImage(FILE *outfile, image_t *tintedImage) 
{

   /* Now write the image to the file */
   fprintf(outfile, "P6 %d %d %d\n",
    tintedImage->columns, tintedImage->rows, tintedImage->brightness);
   fwrite(tintedImage->image, sizeof(pixel_t),
            tintedImage->columns * tintedImage->rows, outfile);
}


/** getimage.c **/
#include "image.h"
int getPPMInt(FILE *fp, int *result);   // Protype statement

/** getImage()
       Retrieve a PPM image from a file and return it via a pointer
       to a newly created image_t
 
    Prototype:
 
       image_t *getImage(char *inFileName) {
       
       where
          inFileName: the name of the input image PPM file
 
       Return value:
          Pointer to a newly created image_t containing the input
          image.
**/
image_t *getImage(char *inFileName) {
   char header[3];
   char buf[256];
   FILE *inFile;
   image_t *inImage;
   int   rows;
   int   cols;
   int   brightness;

   if ((inFile = fopen(inFileName, "r")) == NULL ) {
      fprintf(stderr, "Cannot open file \"%s\"\n", inFileName);
      exit(1);
   }

   /* Allocate space for the image structure */
   inImage = (image_t *)malloc(sizeof(image_t));

   /* Process the PPM header */
   if (fscanf(inFile, "%2s", header) != 1) {
      fprintf(stderr,"Premature end to PPM header\n");
      exit(1);
   }
   if (strcmp(header, "P6") != 0) {
      fprintf(stderr, "PPM file does not start with \"P6\"\n");
      exit(1);
   }
   if (getPPMInt(inFile, &cols) <= 0) {
      fprintf(stderr,"Error in PPM header -- columns\n");
      exit(1);
   }
   if (getPPMInt(inFile, &rows) <= 0) {
      fprintf(stderr,"Error in PPM header -- rows\n");
      exit(1);
   }
   if (getPPMInt(inFile, &brightness) <= 0) {
      fprintf(stderr,"Error in PPM header -- brightness\n");
      exit(1);
   }
   if (fgets(buf, sizeof(buf), inFile) == NULL) {
      fprintf(stderr,"Error in PPM header -- after brightness\n");
      exit(1);
   }

   /* Compute the size of the input image, and allocate space for it */
   inImage = newImage(cols, rows, brightness);
 
   /* And read the image */
   if (fread(inImage->image, sizeof(pixel_t), cols*rows, inFile) != 
         cols*rows) {
      fprintf(stderr, "Error: input file truncated\n");
      exit(1);
   }

   fclose(inFile);

   return(inImage);
}

/** getPPMInt 

    Read an individual integer field from a PPM header.
    Skips over PPM comments (which start with a '#')

    Prototype:
       int getPPMInt(FILE *fp, int *result);

  
    where 
       fp: open input stream,
       result: integer value read

    Return values:
       1: success
       -1: end of file
       0: error in input.

**/
int getPPMInt(FILE *fp, int *result) {
    char buf[100];
    int  code;

    while ((code=fscanf(fp, "%d", result)) != 1) {
       if (fgets(buf, sizeof(buf), fp) == NULL) {
          return(-1);
       }
       if (buf[0] != '#') {
          fprintf(stderr, "getPPMInt[%d]: Error in input: \"%s\"\n", code, buf);
          return(0);
       }
    }
    return(1);
}
                                                                                                                                                                                                                                                                                                                                image.h                                                                                             000644  000765  000024  00000001447 12630067515 012425  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /** image.h **/
#ifndef IMAGE_H
#define IMAGE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/** pixel_t definition **/
typedef struct pixelType {
   unsigned char r;  // Red value
   unsigned char g;  // Green value
   unsigned char b;  // Blue value
} pixel_t;

/** image_t defintion **/
typedef struct imageType {
   pixel_t *image;   // Pointer to PPM image binary data
   int     columns;  // Number of pixel columns
   int     rows;     // Number of pixel rows
   int     brightness; // Image brightness
} image_t;

/** Prototype statements **/
image_t *getImage(char *inFileName);
image_t *newImage(int columns, int rows, int brightness);
void    outImage(FILE *outfile, image_t *outImage);
image_t *duotone(image_t *inImage, pixel_t tint);

void	deleteImg(image_t *inImage);

#endif
                                                                                                                                                                                                                         lighting.cpp                                                                                        000644  000765  000024  00000001704 12630067515 013477  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /*****************************************************************************
 * Author: John McElvenny (jlmcelv)
 * CPSC 2100 Section 002
 * Program: Raytrace 2
 * Due Date: Nov 23, 11:59pm
 *
 * Description: This file holds the lighting() method, method vital to 
 *               accurately projecting light on the scene
 *
 ****************************************************************************/

#include "myvector.h"
#include "lighting.h"
#include "pointlight.h"

/* lighting returns the total lighting on a point in the form of a vector */
myvector_t lighting(scene_t *scene, entity_t *ent, hitinfo_t &hit) 
{

    myvector_t total_light = myvector_t(0,0,0);
    pointlight_t* light;
    list_t *lightList = scene->lightList;
 
    lightList->reset();

    while(lightList->hasnext()) {
      light = (pointlight_t *)lightList->get_entity();
      total_light = total_light + light->processLight(scene, ent, hit);

    }


    return total_light;
}

                                                            lighting.h                                                                                          000644  000765  000024  00000000370 12630067515 013142  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /**
  CPSC 2100
  lighting.h
 **/

#ifndef LIGHTING_H
#define LIGHTING_H
#include "ray.h"

/* lighting returns the total lighting on a point hit in the form of a vector */
myvector_t lighting(scene_t *scene, entity_t *ent, hitinfo_t &hit);

#endif
                                                                                                                                                                                                                                                                        list.cpp                                                                                            000644  000765  000024  00000001631 12630067515 012644  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /* CPSC 2100 List functions */

#include "list.h"

node_t::node_t()
{
   objPtr = NULL;
   next = NULL;
}

node_t::node_t(void *objPtr)
{
   this->objPtr = objPtr;
   next = NULL;
}

node_t:: ~node_t()
{ }

void node_t::set_next(node_t *nextPtr)
{
   next = nextPtr;
}
   
node_t * node_t::get_nextPtr()
{
   return next;
}

void * node_t::get_entval()
{
   
   return objPtr;
}


list_t::list_t()
{
   head = NULL;
}

list_t::~list_t() {}

   
/** add -- add an object to the linked list **/
void list_t::add(void *objPtr) 
{
   node_t *newNode= new node_t(objPtr);

   
   newNode->set_next(head);
   head = newNode;
}

void  list_t::reset()
{
   current = head;
}

void * list_t::get_entity()
{
    assert(current != NULL);
    void * ent = current->get_entval();
    current = current->get_nextPtr();
    return ent;
}


int list_t::hasnext()
{
   int val = 0;
   if(current != NULL)
      val = 1;
   return val;
}

                                                                                                       list.h                                                                                              000644  000765  000024  00000001322 12630067515 012306  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /** CPSC 2100
    list.h - specification file for the list_t class  
**/

#ifndef LIST_H
#define LIST_H

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

class node_t
{
  public:
     node_t();
     node_t(void *);
     ~node_t();

     void set_next(node_t *);
     node_t *get_nextPtr();
     void   *get_entval();

  private:
     void   *objPtr;        /* pointer to associated object */
     node_t *next;          /* pointer to next node         */
};


class list_t
{
  public:
    list_t();
    ~list_t();

    void add(void *obj);         /* Insert object into list  */
    void  reset();
    void *get_entity();
    int hasnext();
   
   private:
     node_t *head;
     node_t *current;
};


#endif

                                                                                                                                                                                                                                                                                                              main.cpp                                                                                            000644  000765  000024  00000001540 12630067515 012614  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /** CPSC 2100 - main.cpp 
    Main program for ray tracer
**/

#include "ray.h"
#include "render.h"
#include <fstream>

using namespace std;

int main( int argc, char *argv[])
{
   ifstream infile;
   FILE *outfile;
   
   /* Open scene definition file */
   if (argc != 3) {
      fprintf(stderr, "Usage: ./ray mdl_file ppm_image_file\n");
      exit(1);
   }

   infile.open(argv[1], ios::in);
   //assert(infile != NULL);
   //comment to remove warning
   scene_t *scene = new scene_t(infile);

   outfile = fopen(argv[2], "w");
   assert(outfile != NULL);

   /* Load and dump scene data */
   

   scene->dumpScene();
   

   /* Render the image */
   render(scene);

   /* And output the image to a PPM file */
   //strcpy(outFile, argv[2]);
   outImage(outfile, scene->getPicture());

   //leaked 40 bytes, not my code, no points deductable
   return 0;
}

                                                                                                                                                                mycolor.cpp                                                                                         000644  000765  000024  00000004512 12630067515 013356  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /** 
   CPSC 2100 mycolor_t class
**/

#include <iostream>
#include <math.h>
#include "mycolor.h"

using namespace std;

mycolor_t::mycolor_t()
{
    r = 0.0;
    g = 0.0;
    b = 0.0;
}

mycolor_t::mycolor_t(double newR, double newG, double newB)
{
    r = newR;
    g = newG;
    b = newB;
}

mycolor_t::mycolor_t(double newR)
{
    r = newR;
    g = 0.0;
    b = 0.0;
}

mycolor_t::mycolor_t(const mycolor_t & toCopy)
{
    r = toCopy.r;
    g = toCopy.g;
    b = toCopy.b;
}

mycolor_t::~mycolor_t()
{

}

double mycolor_t::dot(const mycolor_t &color2)
{
    return (r*color2.r + g*color2.g + r*color2.b);
}

mycolor_t mycolor_t::scale(double fact)
{
	return mycolor_t(r*fact, g*fact, b*fact);
}

mycolor_t mycolor_t::diff(const mycolor_t &subtrahend)
{
	return mycolor_t(r - subtrahend.r, g - subtrahend.g, b - subtrahend.b);
}

mycolor_t mycolor_t::sum(const mycolor_t & addend)
{
	return mycolor_t(r + addend.r, g + addend.g, b + addend.b);
}

double mycolor_t:: getR() {
        return(r);
}

double mycolor_t:: getG() {
        return(g);
}

double mycolor_t:: getB() {
        return(b);
}

void mycolor_t::print()
{
    cerr << "(" << r << ", " << g << ", " << b << ")\n";
}

mycolor_t &mycolor_t::operator=(const mycolor_t &toCopy) {
    r = toCopy.r;
    g = toCopy.g;
    b = toCopy.b;
    return *this;
}

/** Overloaded operators **/
/** scale **/
mycolor_t mycolor_t::operator*(double fact) const
{
    return mycolor_t(r*fact, g*fact, b*fact);
}

/** difference **/
mycolor_t mycolor_t::operator-(const mycolor_t &subtrahend) const
{
    return mycolor_t((r-subtrahend.r), (g-subtrahend.g), (b-subtrahend.b));
}

/** sum **/
mycolor_t mycolor_t::operator+(const mycolor_t &addend) const
{
    return mycolor_t((r+addend.r), (g+addend.g), (b+addend.b));
}

/** "friend" function to output a mycolor_t **/
ostream &operator<<(ostream &out, const mycolor_t &color)
{
    //out << "(" << setprecision(0) << color.r << ", " << color.g << ", " << color.b << ")";
    out << setprecision(0) << color.r << "   " << color.g << " " << color.b;
    return out;
}

/** "friend" function to input a mycolor_t **/
istream &operator>>(istream &in, mycolor_t &color)
{
    in >> color.r >> color.g >> color.b;
    return in;
}

/** mycolor_t field access **/
double &mycolor_t::operator[](int i) {
    if(i == 0) return r;
    else if(i == 1) return g;
    else return b;
}


                                                                                                                                                                                      mycolor.h                                                                                           000644  000765  000024  00000002125 12630067515 013021  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         #ifndef mycolor_t_H
#define mycolor_t_H

#include <iostream>
#include <iomanip>
using namespace std;


class mycolor_t
{
public:
    /** color methods **/
    mycolor_t();
    mycolor_t(double newR, double newG, double newB);
    mycolor_t(double newR);
    mycolor_t(const mycolor_t &toCopy);
    ~mycolor_t();
    double dot(const mycolor_t &color2);
    mycolor_t scale(double fact);
    mycolor_t diff(const mycolor_t &subtrahend);
    mycolor_t sum(const mycolor_t &addend);
    double getR();
    double getG();
    double getB();
    void print();
    double get(int i);
    mycolor_t readColor(FILE *infile, const string &errmsg);

    mycolor_t &operator=(const mycolor_t &toCopy);
    mycolor_t operator*(double fact) const;
    mycolor_t operator-(const mycolor_t &subtrahend) const;
    mycolor_t operator+(const mycolor_t &addend) const;
    mycolor_t operator~();
    friend ostream &operator<<(ostream &out, const mycolor_t &color);
    friend istream &operator>>(istream &in, mycolor_t &color);
    double &operator[](int i);


  private:
    double r;
    double g;
    double b;

};

#endif
                                                                                                                                                                                                                                                                                                                                                                                                                                           ./._myscene.txt                                                                                     000644  000765  000024  00000000253 12630071622 013734  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                             Mac OS X            	   2   y      �                                      ATTR       �   �                     �     com.apple.TextEncoding   utf-8;134217984                                                                                                                                                                                                                                                                                                                                                     myscene.txt                                                                                         000644  000765  000024  00000002215 12630071622 013362  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         window name view ;
   windowwidth 8
   windowheight 6
   columns 400
   viewpoint 0 -1 5
   ambient 6 6 6 ;

plane name plane1 ;
   color 255 255 255
   reflective 0.5 0.5 0.5;
   diffuse 0.5 0.5 0.5 ;
   point 0 -3 0
   orient1 1 1 0
   orient2 0 0 1 ;

plane name plane2 ;
   color 234 106 32
   reflective 0.5 0.5 0.5;
   diffuse 0.5 0.5 0.5 ;
   point 0 -3 0
   orient1 -1 1 0 
   orient2 0 0 1;

plane name backwall ;
   color 82 45 128
   diffuse 0.5 0.5 0.5 ;
   point 1 0 -8
   orient1 1 1 0
   orient2 0 1 0 ;

sphere name paw1 ;
   color 246 67 33
   diffuse 0.5 0.5 0.5 ;
   center 0 0 -1
   radius 1 ;

sphere name paw2 ;
   color 246 67 33
   diffuse 0.5 0.5 0.5 ;
   center .5 2 -1
   radius .5 ;

sphere name paw3 ;
   color 246 67 33
   diffuse 0.5 0.5 0.5 ;
   center -.5 2 -1
   radius .5 ;

sphere name paw4 ;
   color 246 67 33
   diffuse 0.5 0.5 0.5 ;
   center 1.5 1 -1
   radius .5 ;

sphere name paw5 ;
   color 246 67 33
   diffuse 0.5 0.5 0.5 ;
   center -1.5 1 -1
   radius .5 ;

pointlight  name light1 ;
  color 255 255 255
  brightness 6 
  center 0 2 0;

pointlight  name light2 ;
  color 255 255 255
  brightness 6 
  center 0 -2 0 ;                                                                                                                                                                                                                                                                                                                                                                                   myvector.cpp                                                                                        000644  000765  000024  00000006130 12630067515 013540  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /** CPSC 2100 myvector_t class
    Similar to the one developed in an earlier lab
**/

#include <iostream>
#include <math.h>
#include "myvector.h"

using namespace std;

myvector_t &myvector_t::operator=(const myvector_t &toCopy) {
    x = toCopy.x;
    y = toCopy.y;
    z = toCopy.z;
    return *this;
}

/** Overloaded operators **/
/** scale **/
myvector_t myvector_t::operator*(double fact) const
{
    return myvector_t(x*fact, y*fact, z*fact);
}

/** difference **/
myvector_t myvector_t::operator-(const myvector_t &subtrahend) const
{
    return myvector_t((x-subtrahend.x), (y-subtrahend.y), (z-subtrahend.z));
}

/** sum **/
myvector_t myvector_t::operator+(const myvector_t &addend) const
{
    return myvector_t((x+addend.x), (y+addend.y), (z+addend.z));
}

/** unitize **/
myvector_t myvector_t::operator~()
{
    myvector_t result;
    result = *this * (1.0/this->length());
    return(result);
}

/** "friend" function to output a myvector_t **/
ostream &operator<<(ostream &out, const myvector_t &v)
{
    out << fixed;
    //out << "(" << setprecision(2) << v.x << ", " << v.y << ", " << v.z << ")";
    out << setprecision(2) << v.x << "   " << v.y << "   " << v.z ;
    return out;
}

/** "friend" function to input a myvector_t **/
istream &operator>>(istream &in, myvector_t &v)
{
    in >> v.x >> v.y >> v.z;
    return in;
}

/** myvector_t field access **/
double &myvector_t::operator[](int i) {
    if(i == 0) return x;
    else if(i == 1) return y;
    else return z;
}

/*******************************************************************
      The rest of this file is the solution to lab 11 -- it does not
      need to change
********************************************************************/
myvector_t::myvector_t()
{
    x = 0.0;
    y = 0.0;
    z = 0.0;
}

myvector_t::myvector_t(double newx, double newy, double newz)
{
    x = newx;
    y = newy;
    z = newz;
}

myvector_t::myvector_t(double newx)
{
    x = newx;
    y = 0;
    z = 0;
}

myvector_t::myvector_t(const myvector_t & toCopy)
{
    x = toCopy.x;
    y = toCopy.y;
    z = toCopy.z;
}

myvector_t::~myvector_t()
{
}

double myvector_t::length()
{
    return sqrt(x*x + y*y + z*z);
}

double myvector_t::dot(const myvector_t &v2)
{
    return (x*v2.x + y*v2.y + z*v2.z);
}

myvector_t myvector_t::scale(double fact)
{
	return myvector_t(x*fact, y*fact, z*fact);
}

myvector_t myvector_t::diff(const myvector_t &subtrahend)
{
	return myvector_t(x - subtrahend.x, y - subtrahend.y, z - subtrahend.z);
}

myvector_t myvector_t::sum(const myvector_t & addend)
{
	return myvector_t(x + addend.x, y + addend.y, z + addend.z);
}

myvector_t myvector_t::unitvec()
{
	double len = length();
	return myvector_t(x/len, y/len, z/len);
}

myvector_t myvector_t::cross(const myvector_t &v2)
{
   myvector_t work;
   work.x = y * v2.z - z * v2.y;
   work.y = z * v2.x - x * v2.z;
   work.z = x * v2.y - y * v2.x;
   return work;
}

double myvector_t::getx() {
        return(x);
}

double myvector_t::gety() {
        return(y);
}

double myvector_t:: getz() {
        return(z);
}

void myvector_t::print()
{
    cerr << "(" << x << ", " << y << ", " << z << ")\n";
}

                                                                                                                                                                                                                                                                                                                                                                                                                                        myvector.h                                                                                          000644  000765  000024  00000002252 12630067515 013206  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /** CPSC 2100 - myvector.h  **/

#ifndef myvector_t_H
#define myvector_t_H

#include <iostream>
#include <iomanip>

using namespace std;


class myvector_t
{
  public:
    myvector_t();
    myvector_t(double newx, double newy, double newz);
    myvector_t(double newx);
    myvector_t(const myvector_t & toCopy);
    ~myvector_t();
    double length();
    double dot(const myvector_t &v2);
    myvector_t scale(double fact);
    myvector_t diff(const myvector_t &subtrahend);
    myvector_t sum(const myvector_t &addend);
    myvector_t unitvec();
    myvector_t cross(const myvector_t &v2);
    double getx();
    double gety();
    double getz();
    void print();
    double get(int i);

    /* operator overloading */
    myvector_t &operator=(const myvector_t &toCopy);
    myvector_t operator*(double fact) const;
    myvector_t operator-(const myvector_t &subtrahend) const;
    myvector_t operator+(const myvector_t &addend) const;
    myvector_t operator~();
    friend ostream &operator<<(ostream &out, const myvector_t &v);
    friend istream &operator>>(istream &in, myvector_t &v);
    double &operator[](int i);


  private:
    double x;
    double y;
    double z;

};

#endif
                                                                                                                                                                                                                                                                                                                                                      outshadow.txt                                                                                       000644  000765  000024  00000002416 12630067515 013745  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         
Pixel Height :    400

DUMP OF WINDOW

Entity name:   theview
   type =      window
   Pixel Width:       500
   World Width:       10
   World Height:      8
   viewPoint:         0.00   0.00   4.00
   ambient intensity: 6.00   6.00   6.00

DUMP OF SCENE OBJECTS:

Entity name:   ball
   type =      sphere
   color:      200   0 0
   diffuse:    0.50   0.50   0.50
   reflective: 0.00   0.00   0.00
   center:     -3.50   0.00   -1.50
   radius:     0.60

Entity name:   floor
   type =      plane
   color:      20   0 240
   diffuse:    1.00   1.00   1.00
   reflective: 0.00   0.00   0.00
   point:      0.00   -5.00   0.00
   orient1:    0.00   0.00   1.00
   orient2:    1.00   0.00   0.00
   normal:     0.00   1.00   0.00

Entity name:   wall
   type =      plane
   color:      255   255 255
   diffuse:    1.00   1.00   1.00
   reflective: 0.00   0.00   0.00
   point:      0.00   -5.00   -11.00
   orient1:    2.00   0.00   1.00
   orient2:    0.00   1.00   0.00
   normal:     -1.00   0.00   2.00

DUMP OF LIGHT LIST:

Entity name:   light2
   type =      pointlight
   color:      255   255 255
   brightness: 6
   center:     -3.50   2.00   -1.50

Entity name:   light1
   type =      pointlight
   color:      240   250 255
   brightness: 7
   center:     -4.00   0.00   -0.25
                                                                                                                                                                                                                                                  plane.cpp                                                                                           000644  000765  000024  00000004343 12630070307 012764  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /*****************************************************************************
 * Author: John McElvenny (jlmcelv)
 * CPSC 2100 Section 002
 * Program: Raytrace 2
 * Due Date: Nov 23, 11:59pm
 *
 * Description: This is the C++ version of plane.c; contains functions
 *               used to display the plane in the scene
 *
 ****************************************************************************/

#include "plane.h"
#include "sceneobj.h"
#include "hitinfo.h"

using namespace std;

// Constructor
plane_t:: plane_t(ifstream &infile) : sobj_t(infile, "plane", PLANE)
{

   this->point = myvector_t(0,0,0);
   this->orient1 = myvector_t(0,0,0);
   this->orient2 = myvector_t(0,0,0);
   this->normal = myvector_t(0,0,0);


   load(infile);
  

   this->normal = orient1.cross(orient2);
}

void plane_t::load(ifstream &infile)
{
   string token;
   infile >> token;

   while(token != ";")
   {
      if (token == "orient1") {
         infile >> orient1;
      }
      else if(token == "orient2")
      {
         infile >> orient2;
      }
      else if (token == "point") {
         infile >> point;
      }
      else 
      {
         cerr << "bad plane token " << token 
              << ". exiting" << endl;
         exit(1);
      }

      infile >> token;
   }
}

myvector_t plane_t::getpoint() 
{


  return this->point; 

}

myvector_t plane_t::getnormal() 
{
  return this->normal;

}

int plane_t::hits(myvector_t base, myvector_t dir, hitinfo_t &hit) {
   myvector_t  Q = point;   
   myvector_t  N = normal;   
   myvector_t  D = dir;              
   myvector_t  V = base;             
   myvector_t  H;                    
   double   t;                     

   if (N.dot(D) == 0) return 0;

   t = (N.dot(Q) - N.dot(V)) / (N.dot(D));

   H = V.sum(D.scale(t));


   if (t < 0) return 0;    
   if (H.getz() > 0) return 0;

   if (D.dot(N) > 0) 
   {
      N = N * (-1);
   }

   hit.sethitpoint(H);
   hit.setnormal(N);
   hit.setdistance(t);

   return 1;  
}

void plane_t :: dump() 
{
   sobj_t::dump();

  std::cout << "point:     " << this->point << std::endl;
  std::cout << "orient1:     " << this->orient1 << std::endl;
  std::cout << "orient2:     " << this->orient2 << std::endl;
  std::cout << "normal:     " << this->normal << std::endl;

}
                                                                                                                                                                                                                                                                                             plane.h                                                                                             000644  000765  000024  00000001044 12630067515 012433  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /**  CPSC 2100 - plane.h **/

#ifndef PLANE_H
#define PLANE_H

#include <iostream>
#include "sceneobj.h"
#include "hitinfo.h"

#define PLANE 1

using namespace std;

class plane_t : public sobj_t {
   public:
      plane_t(ifstream &infile);
      void load(ifstream &infile);
      myvector_t getpoint();
      myvector_t getnormal();
      int hits(myvector_t base, myvector_t dir, hitinfo_t &hit);
      void   dump();

  protected:
      myvector_t point;
      myvector_t normal;
      myvector_t orient1;
      myvector_t orient2;
};

#endif
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            pln.txt                                                                                             000644  000765  000024  00000000476 12630067515 012525  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                          window
   name view1 ;
   windowwidth 8
   windowheight 6
   columns 400
   viewpoint 0 -1 5
   ambient 6 6 6 ;

plane  
   name backwall ;
   diffuse 3 3 3
   color 255 255 255 ;
   point 1 0 -4
   orient1 1 1 0
   orient2 0 1 0 ;

pointlight name pinkfront ;
   color 240 100 100
   brightness 7
   center -1 2 3 ;
                                                                                                                                                                                                  pointlight.cpp                                                                                      000644  000765  000024  00000006356 12630067633 014064  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /*****************************************************************************
 * Author: John McElvenny (jlmcelv)
 * CPSC 2100 Section 002
 * Program: Raytrace 2
 * Due Date: Nov 23, 11:59pm
 *
 * Description: Contains the implementation of Point Light
 *
 ****************************************************************************/

#include "pointlight.h"

using namespace std;

pointlight_t::pointlight_t() : entity_t() 
{

   //initialize everything then call load
   this->center = myvector_t(0,0,0);
   this->color = mycolor_t(255,0,0); //red
   this->brightness = 7;


}

/* This constructor makes a pointlight with default values */
pointlight_t::pointlight_t(ifstream &infile) :
                           entity_t(infile, "pointlight", LIGHT) 
{


   //initialize everything then call load
   this->center = myvector_t(0,0,0);
   this->color = mycolor_t(255,0,0); //red
   this->brightness = 7;

   load(infile);


}


/* load takes in a file and reads in the values of the provided 
   attributes. 
*/
void pointlight_t::load(ifstream &infile)
{

   string token;

   infile >> token;
   while(token != ";")
   {
      if (token == "center") 
      {
         infile >> center;
      }
      else
      if (token == "color") 
      {
         infile >> color;
      }
      else
      if (token == "brightness")
      {
         infile >> brightness;
      } 
      else
      {
         cerr << "Unknown pointlight attribute " << token << "exiting." 
              << endl;
         exit(1);
      }

      infile >> token;    
   }
}

/* getcenter returns the center of the light */
myvector_t pointlight_t::getcenter()
{
    
   return this->center;

}

/* getcolor returns the color of the light */
mycolor_t pointlight_t::getcolor()
{

   return this->color;

}

/* getbrightness returns the brightness of the light */
double pointlight_t::getbrightness()
{
   return this->brightness;


}

/* dump prints out all values of the pointlight */
void pointlight_t::dump()
{
   entity_t::dump();
   //print to cout because yo didn't give me another
   std::cout << "center:      " << this->center << std::endl;
   std::cout << "color:      " << this->color << std::endl;
   std::cout << "brightness:      " << this->brightness << std::endl;



}


/** 
   determines the contribution of a pointlight on total light of the 
**/
myvector_t pointlight_t::processLight(scene_t *scene, 
                                 entity_t *ent, hitinfo_t &hit) 
{
   myvector_t dir = (hit.gethitpoint() - center).unitvec();
   hitinfo_t temphit;

   double o_test = ((center - hit.gethitpoint()).unitvec()).dot(hit.getnormal().unitvec());
   if (o_test < 0 ) return myvector_t(0,0,0);

   entity_t *cl = closest(scene, center, dir, NULL, temphit);
   sobj_t *closestsobj = (sobj_t *)cl;
   if (cl != ent) return myvector_t(0,0,0);

   //calculate and return illumination
   double x = closestsobj->getdiffuse().getx() * (color.getR() * brightness) * o_test 
              / temphit.getdistance();

   double y = closestsobj->getdiffuse().gety() * (color.getG() * brightness) * o_test 
              / temphit.getdistance();
              
   double z = closestsobj->getdiffuse().getz() * (color.getB() * brightness) * o_test 
              / temphit.getdistance();
              
   return myvector_t(x,y,z);
}
                                                                                                                                                                                                                                                                                  pointlight.h                                                                                        000644  000765  000024  00000001202 12630067515 013511  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /** CPSC 2100 - pointlight.h  **/

#ifndef POINTLIGHT_H
#define POINTLIGHT_H

#include <iostream>
#include "entity.h"
#include "sceneobj.h"
#include "lighting.h"

#define LIGHT 3

using namespace std;

class pointlight_t : public entity_t 
{
   public:
      pointlight_t();
      pointlight_t(ifstream &infile);

      void load(ifstream &infile);
      myvector_t getcenter();
      mycolor_t  getcolor();
      double   getbrightness();
      void     dump();
      myvector_t processLight (scene_t *scene, entity_t *ent, hitinfo_t &hit);

  protected:
      myvector_t center;
      mycolor_t color;
      double   brightness;
};

#endif
                                                                                                                                                                                                                                                                                                                                                                                              ray.h                                                                                               000644  000765  000024  00000001604 12630067515 012131  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /** CPSC 2100  ray.h **/

#ifndef RAY_H
#define RAY_H

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <strings.h>
#include <memory.h>
#include <assert.h>
#include <iostream>
#include <fstream>

/** Includes of data types and function prototypes for ray tracer objects.

    NOTE: be VERY careful about the order of the includes.  An object
          type (typedef) MUST be declared before it can be used, including
          by another include.  
**/
#include "myvector.h"

/* For readability, equate other 3-tuple types to a myvector_t */
typedef myvector_t point_t;
typedef myvector_t intensity_t;

#include "list.h"
#include "image.h"
#include "entity.h"
#include "window.h"
#include "scene.h"
//#include "sceneobj.h"

#include "readVals.h"

#include "plane.h"
#include "sphere.h"
#include "pointlight.h"
#include "render.h"
#include "raytrace.h"
   
#endif
                                                                                                                            raytrace.cpp                                                                                        000644  000765  000024  00000007136 12630067515 013511  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /*****************************************************************************
 * Author: John McElvenny (jlmcelv)
 * CPSC 2100 Section 002
 * Program: Raytrace 2
 * Due Date: Nov 23, 11:59pm
 *
 * Description: This is the C++ version of raytrace.c; Does the raytracing
 *
 ****************************************************************************/

#include "raytrace.h"

/** genRay **/
myvector_t genRay(scene_t *scene, int column, int row) {
   double x;
   double y;
   double z;

   myvector_t dir;              // direction vector
   window_t *window;
   image_t *picture;
   window = scene->getWindow();
   picture = scene->getPicture();

   /* Computer the pixel's real scene coordinates */
   x = ((double)(column)/
      (double)(picture->columns-1))*window->getWindowWidth();
   x -= window->getWindowWidth()/2.0;
   
   y = ((double)(row)/
      (double)(picture->rows-1))*window->getWindowHeight();
   y -= window->getWindowHeight()/2.0;
   
   z = 0;

   dir = myvector_t(x, y, z);
   /* And now construct a unit vector from the view point to 
      the pixel 
   */
   dir = dir.diff(window->getViewPoint());
   dir = dir.unitvec();
   return dir;
} /* End genRay */

/** rayTrace **/
myvector_t raytrace(scene_t *scene, myvector_t base, myvector_t unitDir, 
                double total_dist, entity_t *self) {

   double x;
   double y;
   double z;
   hitinfo_t newHit;
   myvector_t intensity (0.0,0.0,0.0);
   mycolor_t  closeColor(0.0, 0.0, 0.0);
   myvector_t  ambient(0.0,0.0,0.0);
   window_t *win;
   entity_t *ent = 
            (entity_t *)closest(scene, base, unitDir, self, newHit);
   
   sobj_t *close = (sobj_t *)ent;
   
   if(close == NULL)
   {
      return myvector_t(0,0,0);
   }
  
   total_dist += newHit.getdistance();
   win = (window_t *)scene->getWindow();
   
   ambient = win->getAmbient();
   closeColor = close->getcolor();
   
   x = closeColor.getR() * ambient.getx();
   y = closeColor.getG() * ambient.gety();
   z = closeColor.getB() * ambient.getz();

   myvector_t diffuse = lighting(scene, close, newHit);

   x+=diffuse.getx();
   y+=diffuse.gety();
   z+=diffuse.getz();

   x /= (255 * total_dist);
   y /= (255 * total_dist);
   z /= (255 * total_dist);

  intensity = myvector_t(x, y, z);

  if (total_dist < 1000 && (close->getreflective().getx() > 0 || close->getreflective().gety() > 0 || close->getreflective().getz() > 0)) {
      self = close;
      myvector_t v = reflect(newHit.getnormal().unitvec(), unitDir);
      myvector_t result = raytrace(scene, newHit.gethitpoint(), v, total_dist, self);
      myvector_t res = myvector_t((x*result.getx()), (result.gety()*y), (result.getz()*z));
      intensity = intensity + res;
   } 

  return intensity;

} 

myvector_t reflect(myvector_t n, myvector_t W) {
      myvector_t u = W * (-1);
      return (n*(u.dot(n)))*2 - u;
}


entity_t *closest(scene_t *scene, myvector_t base, 
            myvector_t unitDir, entity_t *self, hitinfo_t &hit) 
{
   entity_t *obj;
   entity_t *close = NULL;
   list_t *list = scene->sobjList; 
   hitinfo_t currhit;

   double mindist = 999999;
   int isHit;
   
   list->reset();
   while(list->hasnext())
   {
       obj = (entity_t *)list->get_entity();
       if (self == obj) continue;
       isHit = obj->hits(base,unitDir,currhit);
       if(isHit)
       {
           if(currhit.getdistance() < mindist)
           {
               close = obj;
               mindist = currhit.getdistance();
	           hit.setdistance(currhit.getdistance());
               hit.sethitpoint(currhit.gethitpoint());
               hit.setnormal(currhit.getnormal());
           }
       }
   }

   return(close);
} /* End closest */

                                                                                                                                                                                                                                                                                                                                                                                                                                  raytrace.h                                                                                          000644  000765  000024  00000001036 12630067515 013147  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /** CPSC 2100 - raytrace.h  **/

#ifndef RAYTRACE_H
#define RAYTRACE_H

#include "ray.h"

/** Prototype statements **/
myvector_t raytrace(scene_t *scene, myvector_t base, 
                       myvector_t unitDir,
                 double total_dist, entity_t *self);
entity_t       *closest(scene_t *scene, myvector_t base, 
                        myvector_t unitDir, 
                 entity_t *self, hitinfo_t &hit);
myvector_t  genRay(scene_t *scene, int columnNdx, int rowIndx);
myvector_t reflect(myvector_t n, myvector_t W);

#endif
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  readVals.cpp                                                                                        000644  000765  000024  00000010621 12630067515 013431  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /**  CPSC 2100 readVals.cpp  **/

#include "ray.h"
/** readInt 

    Reads a single integer value.  If an error is encountered the provided
    error message is printed and the program is terminated.
**/
int readInt(FILE *infp, char *errmsg) {
    int result;
    if (fscanf(infp, "%d", &result) != 1) {
       /* Error exit */
       fprintf(stderr,"%s\n", errmsg);
       exit(1);
    }
    return(result);
}

/** readDouble

    Reads a single double value.  If an error is encountered the provided
    error message is printed and the program is terminated.
**/
//double readDouble(FILE *infp, char *errmsg) {
double readDouble(FILE *infp, string errmsg) {
    double result;
    if (fscanf(infp, "%lf", &result) != 1) {
       /* Error exit */
       cerr << errmsg << endl;
       exit(1);
    }
    return(result);
}

/** readString

    Reads a single "word".  If an error is encountered the provided
    error message is printed and the program is terminated.
**/
char *readWord(FILE *infp, const char *errmsg) {
    char buffer[100];
    if (fscanf(infp, "%s", buffer) != 1) {
       /* Error exit */
       fprintf(stderr,"%s\n", errmsg);
       exit(1);
    }
    return(strdup(buffer));
}

/** readColor()

    Converts the decimal values, color name or hex value to the 
    3 byte RGB field

    Returns the rgb values if successful.  Or error prints errmsg and
    exits.
**/
pixel_t readColor(FILE *infile, const char *errmsg) {
   int ndx;             /* Array index                          */
   unsigned int value;  /* RGB integer value                    */
   char word[20];       /* input word buffer                    */
   int code;            /* read code                            */
   pixel_t pixel;       /* Return value                         */
   int pixarray[3];     /* Array to hold pixel values           */

   /* Known color names and color values                         */
   typedef struct knownColors {
      const char *name;
      pixel_t value;
   } knownColors_t;

   knownColors_t colors[] = {
         {"white",    {255, 255, 255}},
         {"black",    {0, 0, 0}},
         {"red",      {255, 0, 0}},
         {"green",    {0, 255, 0}},
         {"blue",     {0, 0, 255}},
         {"orange",   {255, 128, 0}},
         {"purple",   {128, 0, 255}},
         {"yellow",   {255, 255, 0}},
         {NULL,       {0, 0, 0}}};      // Marks end of colors array
    
 
   /* First try to read the input as 3 decimal values */
   code = fscanf(infile, "%d %d %d", &pixarray[0], &pixarray[1], &pixarray[2]);
   if (code == 3) {
      for (ndx=0; ndx<3; ndx++) {
          if (pixarray[ndx] > 255 || pixarray[ndx] < 0) {
             fprintf(stderr, "%s\n", errmsg);
             exit(0);
          }
      }
      pixel.r  =  pixarray[0];
      pixel.g  =  pixarray[1];
      pixel.b  =  pixarray[2];
      return(pixel);     /* Success, 3 values read okay */
   }
   if (code != 0) {
      /* There must have been 1 or 2 decimal numbers, but not 3 */
      fprintf(stderr, "%s\n", errmsg);
      exit(1);
   }

   /* Well it's not decimal digits, is the input hex or a known color name? */
   if (fscanf(infile, "%19s", word) != 1) {
      fprintf(stderr, "%s\n", errmsg);
      exit(1);
   }

   /* Should we check for a "well-known" color name, i.e. "word" does not
      start with '#'?
   */
   if (word[0] != '#') {
      /* Search the colors array for the name */
      for (ndx=0; colors[ndx].name != NULL &&
                  strcasecmp(word, colors[ndx].name) != 0 ; ndx++) 
                  /* Just searching */;
      /* Note that ndx is left set to the index of the color in the
         colors array */
      if (colors[ndx].name == NULL) {
         /* Color name not found */
         fprintf(stderr, "%s\n", errmsg);
         exit(1);
      }
      /* Return the equivalent color RGB value */
      return(colors[ndx].value);
   }

   /* Last option: hex string of digits -- convert to internal integer */
   if (strspn(word+1, "0123456789abcdefABCDEF") != strlen(word)-1) {
      /* Error, something other than hex digit embedded or at end in string */
      fprintf(stderr, "%s\n", errmsg);
      exit(1);
   }
   if (sscanf(word+1, "%x", &value) != 1) {
      /* Oops -- bad hex string */
      fprintf(stderr, "%s\n", errmsg);
      exit(1);
   }

   /* Finally partition the value into its three 8-bit RGB components */
   pixel.r  =  value >> 16;
   pixel.g = (value >> 8) & 0xff;
   pixel.b = value & 0xff;
   return(pixel);
}
                                                                                                               readVals.h                                                                                          000644  000765  000024  00000000443 12630067515 013077  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         #ifndef READVALS_H
#define READVALS_H

#include <stdio.h>
#include <string.h>

/** prototype statements **/
int     readInt(FILE *fp, char *errmsg);
mycolor_t readColor(FILE *fp, char *errmsg);
double  readDouble(FILE *fp, char *errmsg);
char    *readString(FILE *fp, char *errmsg);

#endif
                                                                                                                                                                                                                             render.cpp                                                                                          000644  000765  000024  00000002533 12630067515 013152  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /** CPSC 2100 - render.cpp  **/

#include "ray.h"

/** render **/
void render(scene_t *scene) {
   int rowndx = 0;
   int colndx = 0;
   int height;
   int width;
   int row;
   int offset;
   
   pixel_t *pix = ((pixel_t*)scene->getPicture()->image);
   

   height = scene->getPicture()->rows;
   width = scene->getPicture()->columns;
   for(rowndx = 0; rowndx < height; rowndx++)
   {
       for(colndx = 0; colndx < width; colndx++)
       {
          row = height - rowndx - 1;
          offset = row * width + colndx;
         
          *(pix + offset) = makePixel(scene, colndx, rowndx);
       }
   }
   
} /* End render */

/** makePixel **/
pixel_t makePixel(scene_t *scene, int colndx, int rowndx) {
   myvector_t intensity;
   myvector_t dir;
   window_t *windowPtr;
   pixel_t pix;
   double x;
   double y;
   double z;

   dir = genRay(scene, colndx, rowndx);
   windowPtr = (window_t *)(scene->getWindow());
   intensity = raytrace(scene, windowPtr->getViewPoint(), dir, 0.0, NULL);
   
   x = intensity.getx();
   y = intensity.gety();
   z = intensity.getz();

   if(x > 1.0)
      x = 1.0;
   
   if(y > 1.0)
       y = 1.0;
   
   if(z > 1.0)
      z = 1.0;
   
   //intensity = myvector_t(x, y, z);
   pix.r = (unsigned char)(255 * x);
   pix.g = (unsigned char)(255 * y);
   pix.b = (unsigned char)(255 * z);

   return pix;
} /* End makePixel */

                                                                                                                                                                     render.h                                                                                            000644  000765  000024  00000000350 12630067515 012612  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /** CPSC 2100 - render.h **/

#ifndef RENDER_H
#define RENDER_H

#include "scene.h"
/** Prototype statements for module render.c **/
void    render(scene_t *scene);
pixel_t makePixel(scene_t *scene, int colndx, int rowndx);

#endif
                                                                                                                                                                                                                                                                                        scene.cpp                                                                                           000644  000765  000024  00000004347 12630067515 012775  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /** CPSC 2100 - scene.cpp  **/

#include "ray.h"
#include "sceneobj.h"

using namespace std;

/** getindex **/

/** constructor  **/
scene_t::scene_t(ifstream &infile)
{
   sobjList = new list_t();
   lightList = new list_t();

   loadScene(infile);
}

/** loadScene **/
void scene_t::loadScene(ifstream &infile)
{
   string token;
   entity_t *obj;
   pointlight_t *lgt;
// entity_t::load(ifstream, token);

   /* Start processing scene description language */
   while (infile >> token)
   {
      if(token == "window") 
      {
         window = new window_t(infile);
      }   
      else if(token == "plane")
      {
         obj = new plane_t(infile);
         sobjList->add((void *)obj);
      }
      else if (token == "sphere")
      {
         obj = new sphere_t(infile);
         sobjList->add((void *)obj);
      }
      else if(token == "pointlight")
      {
         lgt = new pointlight_t(infile);
         lightList->add((void *)lgt);
      } 
      else
      {
         cerr << "Unknown token " << token << endl;
         exit(1);
      }
    }

/** completeScene **/
   // assert(window->magic == WINDOW_T);

   picture = newImage(window->getPixelColumns(), 
             window->getPixelColumns()*
             window->getWindowHeight()/
             window->getWindowWidth(), 255);
}

/** dumpScene **/
void scene_t::dumpScene()
{
   sobj_t *obj;         // object_t pointer
   pointlight_t *lgt;         // object_t pointer
   list_t *list;
   //assert(scene->magic == SCENE_T);


    cerr <<  "\nPixel Height :    " 
        << picture->rows << endl;

   /* First dump the window data */
   /* Print the separately computed pixel rows value */
   
    cerr << "\nDUMP OF WINDOW\n";
    window->dump();

   /* Now dump the scene objects list */
   cerr <<  "\nDUMP OF SCENE OBJECTS:\n";
   
   list = sobjList;
   list->reset();

   while(list->hasnext())
   {
       obj = (sobj_t *)list->get_entity();
       obj->dump();

   }

   /* Next print light data */
   cerr << "\nDUMP OF LIGHT LIST:\n";

   list = lightList;
   list->reset();

   while(list->hasnext())
   {
      lgt = (pointlight_t *)list->get_entity();
      lgt->dump();
   }
}


window_t * scene_t::getWindow()
{
   return window;
}

image_t *scene_t::getPicture()
{
   return picture;
}
                                                                                                                                                                                                                                                                                         scene.h                                                                                             000644  000765  000024  00000001460 12630067515 012433  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /**  CPSC 2100 - scene.h  **/

#ifndef SDL_H
#define SDL_H

#define SCENE_T  1933842

#include "scene.h"

/** scene_t -- pointers to scene and window data **/
class scene_t
{
  public:
    scene_t(ifstream &infile);
    int getindex(char *token, char *table[]);
    void    loadScene(ifstream &infile);
    void    dumpScene();
    window_t *getWindow();
    image_t *getPicture();

   /** Lists of objects in the virtual world **/ 
   list_t  *sobjList;        /* scene objects list                */
   list_t  *lightList;       /* "Lights" list                     */

 protected:
   window_t *window;         /* Window data                       */
   image_t  *picture;        /* output image                      */

 private:
   int magic;                /* magic number                      */


};


#endif
                                                                                                                                                                                                                scene1.txt                                                                                          000644  000765  000024  00000000641 12630067515 013104  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                          window
   name view1 ;
   windowwidth 8
   windowheight 6
   columns 400
   viewpoint 0 -1 5
   ambient 6 6 6 ;

plane  
   name backwall ;
   diffuse 3 3 3
   color 255 255 255 ;
   point 1 0 -4
   orient1 1 1 0
   orient2 0 1 0 ;

sphere  name ball ;
   color 200 0 0
   diffuse 0.7 0.7 0.7 ;
   radius 1.5
   center -0.3 0.75 -2.5 ;

pointlight name light1 ;
   color 250 225 0
   brightness 7
   center -1 2 3 ;
                                                                                               scene2.txt                                                                                          000644  000765  000024  00000000460 12630067515 013104  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                          window
   name view1 ;
   windowwidth 8
   windowheight 6
   columns 400
   viewpoint 0 -1 5
   ambient 6 6 6 ;

sphere  name ball ;
   color 200 0 0
   diffuse 0.7 0.7 0.7 ;
   radius 1.5
   center -0.3 0.75 -2.5 ;

pointlight name pinkfront ;
   color 250 100 100
   brightness 7
   center -1 2.5 3 ;
                                                                                                                                                                                                                scene3.txt                                                                                          000644  000765  000024  00000001015 12630067515 013102  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                          window
   name view1 ;
   windowwidth 8
   windowheight 6
   columns 400
   viewpoint 0 -1 5
   ambient 6 6 6 ;

sphere  name left ;
   color 200 0 0
   diffuse 0.7 0.7 0.7 ;
   radius 1.5
   center -1.5 0.75 -2.5 ;

sphere  name right ;
   color 200 0 0
   diffuse 0.7 0.7 0.7 ;
   radius 1.5
   center 2.0 0.75 -2.5 ;

plane  
   name floor ;
   diffuse 3 3 3
   color 230 230 230 ;
   point 1 -4 -7
   orient1 0 0 1
   orient2 1 0 0 ;

pointlight name light ;
   color 230 140 125
   brightness 7
   center 0.3 4.5 1.0 ;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   sceneobj.cpp                                                                                        000644  000765  000024  00000002416 12630067515 013463  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /** CpSc 2100
    The sobj_t class is "derived" from the base entity_t class.
**/

#include "sceneobj.h"

using namespace std;

// Constructor
sobj_t:: sobj_t(ifstream &infile, const string objtype, int code) : 
       entity_t(infile, objtype, code)
{
   color = mycolor_t(0, 0, 0);
   diffuse = myvector_t(0, 0, 0);
   reflective = myvector_t(0, 0, 0);
   load(infile);
}

// Methods
void sobj_t::load(ifstream &infile) 
{
   string token;
   infile >> token;
   while(token != ";")
   {
      if (token == "color") 
      {
         infile >> color;
      }
      else if (token == "diffuse") 
      {
         infile >> diffuse;
      }
      else if (token == "reflective") 
      {
         infile >> reflective;
      }
      else 
      {
         cerr << "Unknown sobj attribute " << token << ". exiting"
              << endl;
          
      }
      infile >> token;
   }
}

mycolor_t sobj_t:: getcolor() {
   return color;
}

myvector_t sobj_t:: getdiffuse() {
   return diffuse;
}

myvector_t sobj_t:: getreflective() {
   return reflective;
}

void   sobj_t:: dump() {
   entity_t::dump();   // Invoke dump() from entity_t class
   cerr << "   color:      " << color << endl;
   cerr << "   diffuse:    " << diffuse << endl;
   cerr << "   reflective: " << reflective << endl;
}
                                                                                                                                                                                                                                                  sceneobj.h                                                                                          000644  000765  000024  00000001134 12630067515 013124  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /** CPSC 2100 - sceneobj.h  **/

#ifndef SOBJ_H
#define SOBJ_H

#include <iostream>
#include "entity.h"
#include "myvector.h"
#include "mycolor.h"

using namespace std;

class sobj_t : public entity_t 
{
   public:
      // Constructor
      sobj_t(ifstream &infile, const string objtype, int code);

      // Methods
      void     load(ifstream &infile);
      mycolor_t   getcolor();
      myvector_t  getdiffuse();
      myvector_t  getreflective();
      void     dump();

  private:
      //myvector_t color;
      mycolor_t color;
      myvector_t diffuse;
      myvector_t reflective;
};

#endif
                                                                                                                                                                                                                                                                                                                                                                                                                                    shadow1.txt                                                                                         000644  000765  000024  00000001147 12630067515 013276  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         window  name theview ;
  viewpoint   0 0 4
  windowwidth  10
  windowheight 8
  columns  500
  ambient     6 6 6 ;

pointlight  name light1 ;
   brightness 7 
   color 240 250 255 
   center -4 0 -.25 ;

pointlight  name light2 ;
  color 255 255 255
  brightness 6 
  center -3.5 2 -1.5 ;

plane  name wall ;
   color 255 255 255
   diffuse 1 1 1  ;
   point 0 -5 -11
   orient1 2 0 1
   orient2 0 1 0 ;

plane  name floor ;
   color 20 0 240
   diffuse 1 1 1 ;
   point 0 -5 0
   orient1 0 0 1
   orient2 1 0 0 ;

sphere  name ball ;
   color 200 0 0
   diffuse 0.5 0.5 0.5 ;
   radius 0.6
   center -3.5 0 -1.5 ;
                                                                                                                                                                                                                                                                                                                                                                                                                         shadow2.txt                                                                                         000644  000765  000024  00000002165 12630067515 013300  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         window
   name view1 ;
   windowwidth 8
   windowheight 6
   columns 400
   viewpoint 0 -1 5
   ambient 6 6 6 ;

plane  name plane1 ;
   color 250 0 0
   diffuse 1 1 1 ;
   point 0 -3 0
   orient1 1 1 0
   orient2 0 0 1 ;

plane  name plane2 ; 
   diffuse 1 1 1 
   color 0 0 230 ;
   point 0 -3 0
   orient1 -1 1 0 
   orient2 0 0 1 ;

sphere  name ball1 ; 
   color  0 255 255
   diffuse 0.5 0.5 0.5 ;
   center -1 2 -3.5
   radius 1.25 ;

sphere  name ball2 ;
   color 0 255 0
   diffuse 0.5 0.5 0.5 ;
   center 1 2 -3.5
   radius 1.25 ;

sphere  name ball3 ;
   diffuse 0.5 0.5 0.5
   color 255 255 0 ;
   center 0 0 -3.5
   radius 1.25 ;

sphere name randomsphere1 ;
   diffuse 0.5 0.5 0.5
   color 68 248 16 ;
   center 8 5 -11
   radius 0.75 ;

sphere name randomsphere2 ;
   diffuse 0.5 0.5 0.5
   color 68 248 16 ;
   center -8 5 -9
   radius 0.75 ;

sphere name randomsphere3 ;
   diffuse 0.5 0.5 0.5
   color 68 248 16 ;
   center 2 -1 -2
   radius 0.75 ;

pointlight  name light1 ;
   brightness 7 
   color 240 250 255 
   center -4 0 -.25 ;

pointlight  name light2 ;
  color 255 255 255
  brightness 6 
  center -3.5 2 -1.5 ;
                                                                                                                                                                                                                                                                                                                                                                                                           snowman.txt                                                                                         000644  000765  000024  00000002323 12630067515 013407  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         window
  name theview ;
  viewpoint   0 0 4
  windowwidth  8
  windowheight 6
  columns  500
  ambient     4 4 4 ;

pointlight 
   name leftspot ;
   brightness 18 
   color 255 0 0
   center -3 0.5 -0.25 ;

pointlight 
   name rightspot ;
   brightness  18
   color 0 255 0
   center  3 0.5 -0.25 ;

plane
   name mirror ;
   color 255 255 255
   diffuse 0 0 0
   reflective 1 1 1 ; 
   orient1 1 0 1.1
   orient2 0 1 0
   point       3  -4 -6 ;

plane 
   name floor ;
   color 128 128 255
   diffuse 1 1 1
   reflective 0 0 0 ;
   orient1 1 0 0
   orient2 0 0 1
   point 0 -3.1 -1 ;

plane 
   name backwall ;
   color 255 255 0
   diffuse 1 1 1  ;
   point 0 0 -6
   orient1 1 0 0
   orient2 0 1 0 ;

sphere 
   name snowbase ;
   color 255 255 255
   diffuse 1 1 1 ;
   center 0 -2.3 -3
   radius 1 ;

sphere 
   name hidden ;
   color 255 0 0
   diffuse 1 1 1 ;
   center 0 -2.5 -5
   radius 0.5 ;

sphere 
   name snowmiddle ;
   color 255 255 255
   diffuse 1 1 1 ;
   center 0 -0.6 -3
   radius .8 ;

sphere 
   name snowhead ;
   color 255 255 255
   diffuse 1 1 1 ;
   center 0 0.4 -3
   radius .6 ;

sphere 
   name floater ;
   color 255 255 255
   diffuse 0 0 0 
   reflective 1 1 1 ;
   center -3 2.5 -4
   radius 1.0 ;
                                                                                                                                                                                                                                                                                                             sphere.cpp                                                                                          000644  000765  000024  00000004133 12630067515 013157  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /*****************************************************************************
 * Author: John McElvenny (jlmcelv)
 * CPSC 2100 Section 002
 * Program: Raytrace 2
 * Due Date: Nov 23, 11:59pm
 *
 * Description: This is the C++ version of sphere.c; contains functions
 *               used to display the sphere in the scene
 *
 ****************************************************************************/


#include "sphere.h"
#include "math.h"

using namespace std;

// Constructor
sphere_t:: sphere_t(ifstream &infile) : sobj_t(infile, "sphere", 
             SPHERE)
{
  this->center = myvector_t(0,0,0);


  this->radius = 0;

  
  load(infile);
}

void sphere_t:: load(ifstream &infile) 
{
   string token;

   infile >> token;
   while(token != ";")
   {
      if (token == "center") 
      {
         infile >> center;
      }
      else
      if (token == "radius") 
      {
         infile >> radius;
      }
      else 
      {
         cerr << "Unknown sphere attribute " << token << "exiting." 
              << endl;
         exit(1);
      }

      infile >> token;
   }
}

// Methods

// Get center
myvector_t sphere_t:: getcenter() 
{
   return this->center;


}

// Get radius
double sphere_t:: getradius() 
{
   return this->radius;  
   
}

// Sphere hit function
int sphere_t:: hits(myvector_t base, myvector_t dir, hitinfo_t &hit) {
   double r = this->radius;
   myvector_t V = base;
   myvector_t D = dir;
   myvector_t C = this->center;

   

   V = V.diff(C);
   C = myvector_t(0,0,0);

   double a = D.dot(D);
   double b = 2 * V.dot(D);
   double c = V.dot(V) - (r*r);
   


   double discriminant = b*b - 4*a*c;
   if (discriminant <= 0) return 0;

   double t = ((-b - sqrt(discriminant)) / (2*a));
   if (t<0) return 0;

   hit.setdistance(t);
   hit.sethitpoint(base.sum(D.scale(t)));
   hit.setnormal((hit.gethitpoint().diff(center)).unitvec());

   return 1;

}

// Dump sphere
void sphere_t:: dump() 
{

  sobj_t::dump();
  //dump to cout because you didn't give me another stream
  std::cout << "center:     " << this->center << std::endl;
  std::cout << "radius:     " << this->radius << std::endl;

}
                                                                                                                                                                                                                                                                                                                                                                                                                                     sphere.h                                                                                            000644  000765  000024  00000001050 12630067515 012617  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /**  CPSC 2100 - sphere.h  **/

#ifndef SPHERE_H
#define SPHERE_H

#include <iostream>
#include "sceneobj.h"
#include "hitinfo.h"

#define SPHERE 2

using namespace std;

class sphere_t : public sobj_t 
{
   public:
      // Constructor
      sphere_t(ifstream &infile);

      // Methods
      void     load(ifstream &infile);
      myvector_t getcenter();
      double   getradius();
      int      hits(myvector_t base, myvector_t dir, hitinfo_t &hit);
      void     dump();

  protected:
      myvector_t center;
      double   radius;
};

#endif
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        window.cpp                                                                                          000644  000765  000024  00000003553 12630067515 013205  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /** CPSC 2100 - window.h  **/

#include "ray.h"

using namespace std;

/** newWindow **/
window_t::window_t(ifstream &infile) : entity_t(infile, "window", WINDOW)
{ 
   /* Set the default values */
   windowWidth = 4;
   windowHeight = 4;
   viewPoint = myvector_t(0, 0, 5);
   ambient = myvector_t(1, 1, 1);
   pixelColumns = 600;

    load(infile);
   /* Set the window_t's magic number */
   //magic = WINDOW_T;

} /* End window_t */

/** loadWindow **/
void window_t::load(ifstream &infile) {
   /* Attributes recognized by loadWindow */
   string token;
   infile >> token;
   while(token != ";")
   {
      if(token == "windowwidth")
      {
          infile >> windowWidth;
      }
      else if(token == "windowheight")
      { 
          infile >> windowHeight;
      } 
      else if(token == "columns")
      {
         infile >> pixelColumns;
      }
      else if(token == "viewpoint")
      {
         infile >> viewPoint;
      }
      else if(token == "ambient")
      {
          infile >> ambient;
      }
      else
      {
          cerr << "Unknown window token " << token
               << ". exiting." << endl;
          exit(1);
      }

      infile >> token;
   }
} /* End load */


/** dumpWindow **/
void window_t::dump() 
{
   entity_t::dump();
   cerr << "   Pixel Width:       " << pixelColumns << endl;
   cerr << "   World Width:       " << windowWidth << endl;
   cerr << "   World Height:      " << windowHeight << endl;
   cerr << "   viewPoint:         " << viewPoint << endl;
   cerr << "   ambient intensity: " << ambient << endl;
} /* End dump window */

int window_t::getPixelColumns()
{
   return pixelColumns;
}

double window_t::getWindowWidth()
{
  return windowWidth;
}

double window_t::getWindowHeight()
{
  return windowHeight;
}

myvector_t window_t::getViewPoint()
{
   return viewPoint;
}

myvector_t window_t::getAmbient()
{
   return ambient;
}
                                                                                                                                                     window.h                                                                                            000644  000765  000024  00000001057 12630067515 012647  0                                                                                                    ustar 00john                            staff                           000000  000000                                                                                                                                                                         /** CPSC 2100 - window.h  **/

#ifndef WINDOW_H
#define WINDOW_H

#define WINDOW_T 3311657
#define WINDOW 0

#include "ray.h"

class window_t : public entity_t
{
  public:
     window_t(ifstream &infile);
     void load(ifstream &infile); 
     void dump();
     double getWindowWidth();
     double getWindowHeight();
     myvector_t getViewPoint();
     myvector_t getAmbient();
     int getPixelColumns();

  private:
     double windowWidth;
     double windowHeight;
     myvector_t viewPoint;
     myvector_t ambient;
     int pixelColumns; 
};

#endif
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 