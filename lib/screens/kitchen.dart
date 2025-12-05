import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Kitchen extends StatefulWidget {
  const Kitchen({super.key});

  @override
  State<Kitchen> createState() => _KitchenState();
}

class _KitchenState extends State<Kitchen> {
  final DatabaseReference _deviceRef = FirebaseDatabase.instance.ref(
    'Room/Kitchen/Device',
  );
  final DatabaseReference _sensorRef = FirebaseDatabase.instance.ref(
    'Room/Kitchen/Sensor',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nút Back
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,top:20,
              ), // khoảng cách từ viền màn hình
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
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            // Kitchen
            Center(
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
                  "Kitchen",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Text Devices
            Text(
              "Devices",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            //LED 1
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder<DatabaseEvent>(
                    // Tạo một đường ống kết nối trực tiếp, Lắng nghe data thời gian thực
                    stream: _deviceRef.child('LED1').onValue,
                    builder: (context, snapshot) {
                      final bool isOn =
                          (snapshot.data?.snapshot.value ?? 0) ==
                          1; // nhận data từ firebase
                      return Container(
                        // vẽ lại giao diện (thay đổi ảnh đèn)
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
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
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
                                  // thay đổi ảnh nếu thỏa điều kiện
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
                                    _deviceRef
                                        .child('LED1')
                                        .set(
                                          val ? 1 : 0,
                                        ); // gửi lệnh lên firebase
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  Spacer(),
                  // LED 2
                  StreamBuilder<DatabaseEvent>(
                    stream: _deviceRef.child('LED2').onValue,
                    builder: (context, snapshot) {
                      final bool isOn =
                          (snapshot.data?.snapshot.value ?? 0) == 1;
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
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
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
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // FanFan
                  StreamBuilder<DatabaseEvent>(
                    stream: _deviceRef.child('Fan').onValue,
                    builder: (context, snapshot) {
                      final bool isOn = (snapshot.data?.snapshot.value ?? 0) == 1;
                      return Container(
                        width: 167,
                        height: 184,
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
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
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
                  Spacer(),
                  // airair
                  StreamBuilder<DatabaseEvent>(
                    stream: _deviceRef.child('Air').onValue,
                    builder: (context, snapshot) {
                      final bool isOn = (snapshot.data?.snapshot.value ?? 0) == 1;
                      return Container(
                        width: 167,
                        height: 184,
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
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
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
                ],
              ),
            ),

            // Sensors
            Padding(
              padding: const EdgeInsets.all(8.0),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                height: 101,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB9B9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        "Temp",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 45,
                        height: 45,
                        child: Image.asset(
                          'assets/images/temp.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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

            SizedBox(height: 20),
            //hummi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                height: 101,
                decoration: BoxDecoration(
                  color: const Color(0xFFA1BCFF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        "Hum",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
              
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 45,
                        height: 45,
                        child: Image.asset(
                          'assets/images/hum.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
