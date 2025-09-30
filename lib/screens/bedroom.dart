import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Bedroom extends StatefulWidget {
  const Bedroom({super.key});

  @override
  State<Bedroom> createState() => _BedroomState();
}

class _BedroomState extends State<Bedroom> {
  final DatabaseReference _deviceRef = FirebaseDatabase.instance.ref(
    'Room/Bedroom/Device',
  );
  final DatabaseReference _sensorRef = FirebaseDatabase.instance.ref(
    'Room/Bedroom/Sensor',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Nút Back
          Positioned(
            left: 18,
            top: 23,
            child: SizedBox(
              width: 48,
              height: 48,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 28,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context); // Quay lại HomePage
                },
              ),
            ),
          ),

          // Bedroom
          Positioned(
            top: 44,
            left: (MediaQuery.of(context).size.width - 243) / 2,
            child: Container(
              width: 243,
              height: 41,
              decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: const Text(
                "Bedroom",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Text Devices
          const Positioned(
            left: 37,
            top: 130,
            child: Text(
              "Devices",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          //LED 1
          Positioned(
            left: 25,
            top: 171,
            child: StreamBuilder<DatabaseEvent>(
              stream: _deviceRef.child('LED1').onValue,
              builder: (context, snapshot) {
                final bool isOn = (snapshot.data?.snapshot.value ?? 0) == 1;
                return Container(
                  width: 167,
                  height: 183,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAF8D3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 39,
                        top: 12,
                        child: Container(
                          width: 92,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "LED 1",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      // Hình ảnh đổi theo switch
                      Positioned(
                        left: 41,
                        top: 48,
                        child: SizedBox(
                          width: 88,
                          height: 88,
                          child: Image.asset(
                            isOn
                                ? 'assets/images/led.png'
                                : 'assets/images/led_off.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Switch
                      Positioned(
                        left: 53,
                        top: 144,
                        child: SizedBox(
                          width: 67,
                          height: 32,
                          child: Switch(
                            value: isOn,
                            onChanged: (val) {
                              _deviceRef.child('LED1').set(val ? 1 : 0);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // LED 2
          Positioned(
            left: 207,
            top: 171,
            child: StreamBuilder<DatabaseEvent>(
              stream: _deviceRef.child('LED2').onValue,
              builder: (context, snapshot) {
                final bool isOn = (snapshot.data?.snapshot.value ?? 0) == 1;
                return Container(
                  width: 167,
                  height: 183,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFFBD),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 39,
                        top: 12,
                        child: Container(
                          width: 92,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "LED 2",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      // Hình ảnh đổi theo switch
                      Positioned(
                        left: 41,
                        top: 48,
                        child: SizedBox(
                          width: 88,
                          height: 88,
                          child: Image.asset(
                            isOn
                                ? 'assets/images/led.png'
                                : 'assets/images/led_off.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Switch
                      Positioned(
                        left: 53,
                        top: 144,
                        child: SizedBox(
                          width: 67,
                          height: 32,
                          child: Switch(
                            value: isOn,
                            onChanged: (val) {
                              _deviceRef.child('LED2').set(val ? 1 : 0);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // FanFan
          Positioned(
            left: 28,
            top: 370,
            child: StreamBuilder<DatabaseEvent>(
              stream: _deviceRef.child('Fan').onValue,
              builder: (context, snapshot) {
                final bool isOn = (snapshot.data?.snapshot.value ?? 0) == 1;
                return Container(
                  width: 164,
                  height: 181,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC5FFDD),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 37,
                        top: 12,
                        child: Container(
                          width: 90,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "Fan",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      // Hình ảnh đổi theo switch
                      Positioned(
                        left: 38,
                        top: 50,
                        child: SizedBox(
                          width: 88,
                          height: 88,
                          child: Image.asset(
                            isOn
                                ? 'assets/images/fan.png'
                                : 'assets/images/fan_off.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Switch
                      Positioned(
                        left: 48,
                        top: 145,
                        child: SizedBox(
                          width: 67,
                          height: 32,
                          child: Switch(
                            value: isOn,
                            onChanged: (val) {
                              _deviceRef.child('Fan').set(val ? 1 : 0);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // airair
          Positioned(
            left: 207,
            top: 370,
            child: StreamBuilder<DatabaseEvent>(
              stream: _deviceRef.child('Air').onValue,
              builder: (context, snapshot) {
                final bool isOn = (snapshot.data?.snapshot.value ?? 0) == 1;
                return Container(
                  width: 164,
                  height: 181,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC2EEF7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 37,
                        top: 12,
                        child: Container(
                          width: 90,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "Air",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      // Hình ảnh đổi theo switch
                      Positioned(
                        left: 38,
                        top: 50,
                        child: SizedBox(
                          width: 88,
                          height: 88,
                          child: Image.asset(
                            isOn
                                ? 'assets/images/air.png'
                                : 'assets/images/air_off.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Switch
                      Positioned(
                        left: 48,
                        top: 145,
                        child: SizedBox(
                          width: 67,
                          height: 32,
                          child: Switch(
                            value: isOn,
                            onChanged: (val) {
                              _deviceRef.child('Air').set(val ? 1 : 0);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Sensors
          const Positioned(
            left: 37,
            top: 580,
            child: Text(
              "Sensors",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          // Temp
          Positioned(
            left: 32,
            top: 620,
            child: Container(
              width: 343,
              height: 101,
              decoration: BoxDecoration(
                color: const Color(0xFFFFB9B9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Stack(
                children: [
                  const Positioned(
                    left: 40,
                    top: 28,
                    child: Text(
                      "Temp",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  Positioned(
                    left: 120,
                    top: 28,
                    child: SizedBox(
                      width: 45,
                      height: 45,
                      child: Image.asset(
                        'assets/images/temp.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Positioned(
                    left: 180,
                    top: 12,
                    child: Container(
                      width: 149,
                      height: 76,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCFFCD),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: StreamBuilder<DatabaseEvent>(
                        stream: _sensorRef.child('Temp').onValue,
                        builder: (context, snapshot) {
                          final dynamic value =
                              snapshot.data?.snapshot.value ?? 0;
                          return Text(
                            "$value °C",
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //humhum
          Positioned(
            left: 32,
            top: 730,
            child: Container(
              width: 343,
              height: 101,
              decoration: BoxDecoration(
                color: const Color(0xFFA1BCFF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Stack(
                children: [
                  const Positioned(
                    left: 40,
                    top: 28,
                    child: Text(
                      "Hum",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  Positioned(
                    left: 120,
                    top: 28,
                    child: SizedBox(
                      width: 45,
                      height: 45,
                      child: Image.asset(
                        'assets/images/hum.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Positioned(
                    left: 180,
                    top: 12,
                    child: Container(
                      width: 149,
                      height: 76,
                      decoration: BoxDecoration(
                        color: const Color(0xFFBFF1F3),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: StreamBuilder<DatabaseEvent>(
                        stream: _sensorRef.child('Humid').onValue,
                        builder: (context, snapshot) {
                          final dynamic value =
                              snapshot.data?.snapshot.value ?? 0;
                          return Text(
                            "$value %",
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
