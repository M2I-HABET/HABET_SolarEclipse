#include <Servo.h>
#include <lea6.h>
#include "commands.h"
// The GPS attached to the payload
LEA6 *gps;
// The main serial interface
HardwareSerial *hardSerial;
// The servos
Servo pitch;
Servo roll;
Servo yaw;
// Control the telemetry (enabled from the start)
short telemEnable = 1;
void setup(void) {
	// Create the commands
	commands_init();	
	// Create the GPS object on Serial1
	gps = new LEA6(&Serial1);
	gps->init();
	// Prepare the serial port for the telemetry transmitter
	Serial.begin(9600);
	Serial2.begin(9600);
	hardSerial = &Serial;
	
	// set up the servos and attach them to pins
	
	pitch.attach(10);
	roll.attach(9);
	yaw.attach(6);




	// Create the three burners
	//Serial.print("Initializing the three burners...");
	//burner1 = new ISU_Burner(7, 8);
	//burner2 = new ISU_Burner(9, 10);
	//burner3 = new ISU_Burner(11, 12);
	//Serial.print("Completed\n\r");
}
void loop(void) {
	// The data structure to hold the GPS data
	LEA6::ubloxData_t gpsData;
	char comm_data[2];
	// Read the telemetry serial port and have it decipher the command
	while ( Serial.available() > 0 ) {
		comm_data[0] = Serial.read();
		comm_data[1] = 0;
		commands_interpret(comm_data);
	}
	readGPS();
}
