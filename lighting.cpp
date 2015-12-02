/*****************************************************************************
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

