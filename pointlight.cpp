/*****************************************************************************
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

   entity_t *cl = closest(scene, center, dir, ent, temphit);
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
