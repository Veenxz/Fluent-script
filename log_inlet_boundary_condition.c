/****************************************************************************/
/*                  ANSYS FLUENT log inlet boundary UDF                     */
/*                       Test on ANSYS FLUENT 19.2                          */
/*                       Author:Veenxz Version:1.1                          */
/*                      Beijing Forestry University                         */
/*                        Update Date:2020/06/18                            */
/****************************************************************************/

#include "udf.h"

/*DEFINE                  NAME                              UNITS*/
#define L 100           //characteristic length             [m]
#define F_hight 0.01    //friction height                   [m]
#define U_star 0.5      //friction velocity                 [m/s]
#define U_av 15         //averaged velocity at H = 10 m     [m/s]
#define rho 1.225       //fluid density                     [kg/m^3]
#define nu 1.78938e-05  //kinematic viscosity               [m^2/s]
#define k 0.41          //Karman constant                   [dimensionless]
#define cmu 0.09        //model constant                    [dimensionless]
#define TI 0.02771931  //Turb_Intensity
#define TL 0.8520129  //Turb_Length_Scale

/* profile for velocity [m/s]*/
DEFINE_PROFILE(inlet_x_velocity, thread, index)
{
    real x[ND_ND];
    real z,U;
    face_t f;

    begin_f_loop(f, thread)
    {
        F_CENTROID(x,f,thread);
        z = x[1];
        U = (U_star/k)*log((z+F_hight)/F_hight);
        F_PROFILE(f, thread, index) = U;
    }
    end_f_loop(f, thread)
}

/* profile for kinetic energy [m^2/s^2]*/
DEFINE_PROFILE(k_profile,thread,index)
{
    real x[ND_ND];
    real z,U;
    face_t f;

    begin_f_loop(f,thread)
    {
        F_CENTROID(x,f,thread);
        z = x[1];
        U = (U_star/k)*log((z+F_hight)/F_hight);
        F_PROFILE(f,thread,index)=1.5*pow((U*TI),2);
    }
    end_f_loop(f,thread)
}

/* profile for dissipation rate [m^2/s^3]*/
DEFINE_PROFILE(epsilon_profile,thread,index)
{
    real x[ND_ND];
    real z,U,TKE;
    face_t f;

    begin_f_loop(f,thread)
    {
        F_CENTROID(x,f,thread);
        z = x[1];
        U = (U_star/k)*log((z+F_hight)/F_hight);
        TKE=1.5*pow((U*TI),2);
        //smaller tdr
        //F_PROFILE(f,thread,index)=pow(Cu,0.75)*pow(TKE,1.5)/TL;
        F_PROFILE(f,thread,index)=pow(TKE,1.5)/TL;
    }
    end_f_loop(f,thread)
}
