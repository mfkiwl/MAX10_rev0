/*
 * fmc_loopback.h
 *
 *  Created on: 2013-05-24
 *      Author: bryerton
 */

#ifndef FMC_LOOPBACK_H_
#define FMC_LOOPBACK_H_

#include "../fmc.h"

#define MANUFACTURER "LINNUX"
#define PRODUCT_NAME "DEAP ADC24"
#define SERIAL_NUM	 "0001"
#define PART_NUM	 "0004"

#define P1_VADJ_NOMINAL_VOLTAGE 250
#define P1_VADJ_DEVIATION		13
#define P1_VADJ_MAX_CURRENT		4000

#define P1_3V3_NOMINAL_VOLTAGE	330
#define P1_3V3_DEVIATION		17
#define P1_3V3_MAX_CURRENT		3000

#define P1_12V_NOMINAL_VOLTAGE	1200
#define P1_12V_DEVIATION		60
#define P1_12V_MAX_CURRENT		1000

#define P1_VIO_B_NOMINAL_VOLTAGE P1_VADJ_NOMINAL_VOLTAGE
#define P1_VIO_B_DEVIATION		 P1_VADJ_DEVIATION
#define P1_VIO_B_MAX_CURRENT	 1150

#define P1_VREF_A_NOMINAL_VOLTAGE	P1_VADJ_NOMINAL_VOLTAGE
#define P1_VREF_A_DEVIATION			P1_VADJ_DEVIATION
#define P1_VREF_A_MAX_CURRENT		1

#define P1_VREF_B_NOMINAL_VOLTAGE	P1_VADJ_NOMINAL_VOLTAGE
#define P1_VREF_B_DEVIATION			P1_VADJ_DEVIATION
#define P1_VREF_B_MAX_CURRENT		1

tFMCInfo* CreateFMCDeapADC24(void);

#endif /* FMC_LOOPBACK_H_ */
