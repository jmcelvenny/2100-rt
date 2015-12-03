/*****************************************************************************
 * Author: John McElvenny (jlmcelv)
 * CPSC 2100 Section 002
 * Program: Raytrace 2
 * Due Date: Nov 23, 11:59pm
 *
 * Description: This is the C++ version of raytrace.c; Does the raytracing
 *
 ****************************************************************************/

#include "raytrace.h"

#define MAX_BOUNCE 20

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
                double total_dist, entity_t *self, int bounce) {

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

  //reflectivity test


   if (close->getreflective().getx() > 0 || close->getreflective().gety() > 0 || close->getreflective().getz() > 0) {
      self = close;
      myvector_t v = reflect(newHit.getnormal().unitvec(), unitDir);
      myvector_t result = raytrace(scene, newHit.gethitpoint(), v, total_dist, self, bounce+1);
      myvector_t res = myvector_t((x*result.getx()), (result.gety()*y), (result.getz()*z));
      intensity = intensity + res;
   } 

  return intensity;

} 

myvector_t raytrace(scene_t *scene, myvector_t base, 
                       myvector_t unitDir,
                 double total_dist, entity_t *self) {
  return raytrace(scene, base, unitDir, total_dist, self, 0);
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

   //base = base + (unitDir * .01); //move it over a lil bit 

   list->reset();
   while(list->hasnext())
   {
       obj = (entity_t *)list->get_entity();
       if (obj == self) continue;
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

