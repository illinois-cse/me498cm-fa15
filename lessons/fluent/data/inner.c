#include "udf.h"

DEFINE_PROFILE(inner_vx, thread, index) 
{ 
real x[ND_ND];  // position vector, from FLUENT 
real x0, y0;    // center of circle coordinates 
real R, omega; 	// inner radius and angular velocity 
real theta;
face_t f;       // fluent face object 
x0 = 0.001;   //m
y0 = 0.001;   //m
R  = 0.006;   //m
omega = 1250 /*RPM*/ * 2*3.1415/60; /*rad/s*/
begin_f_loop(f, thread)
{ 
F_CENTROID(x, f, thread); // this fills the position vector 
theta = atan2(x[1]-y0, x[0]-x0); /*rad*/
F_PROFILE(f, thread, index) = -R * omega * sin(theta);
} 
end_f_loop(f, thread) 
}

DEFINE_PROFILE(inner_vy, thread, index) 
{ 
real x[ND_ND];  // position vector, from FLUENT 
real x0, y0;    // center of circle coordinates 
real R, omega; 	// inner radius and angular velocity 
real theta;
face_t f;       // fluent face object 
x0 = 0.001;   //m
y0 = 0.001;   //m
R  = 0.006;   //m
omega = 1250 /*RPM*/ * 2*3.1415/60; /*rad/s*/
begin_f_loop(f, thread)
{ 
F_CENTROID(x, f, thread); // this fills the position vector 
theta = atan2(x[1]-y0, x[0]-x0); /*rad*/
F_PROFILE(f, thread, index) = R * omega * sin(theta);
} 
end_f_loop(f, thread) 
}