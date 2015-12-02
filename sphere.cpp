/*****************************************************************************
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
