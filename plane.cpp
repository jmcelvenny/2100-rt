/*****************************************************************************
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

   H = V + (D * t);

   if (t < 0) return 0;    
   if (H.getz() > 0) return 0;

   if (D.dot(hit.getnormal()) > 0) 
   {
      hit.getnormal() = (hit.getnormal()).scale(-1);
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
