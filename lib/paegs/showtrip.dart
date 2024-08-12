import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/config/config.dart';
import 'package:flutter_application_2/models/response/trip_get_res.dart';
import 'package:flutter_application_2/paegs/profile.dart';
import 'package:flutter_application_2/paegs/trip.dart';
import 'package:http/http.dart' as http;

class ShowtripPage extends StatefulWidget {

  int idx = 0;
  ShowtripPage({super.key, required this.idx});

  @override
  State<ShowtripPage> createState() => _ShowtripPageState();
}

class _ShowtripPageState extends State<ShowtripPage> {
  String url = '';
  List<TripGetResponse> trips = [];
  List<TripGetResponse> filteredTrips = [];
  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   Configuration.getConfig().then(
  //     (config) {
  //       url = config['apiEndpoint'];
  //       // getTrips();
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการทริป'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
  log(value);
  if (value == 'profile') {
	Navigator.push(
		context,
		MaterialPageRoute(
		  builder: (context) =>  ProfilePage(idx: widget.idx),
		));
  } else if (value == 'logout') {
	Navigator.of(context).popUntil((route) => route.isFirst);
  }
},

            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('ออกจากระบบ'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
          future: loadData,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(
                      16.0), // ปรับค่าเพื่อเพิ่มช่องว่างรอบๆ ข้อความ
                  child: Text(
                    'ปลายทาง',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 40, // กำหนดความสูงของ ListView
                  child: ListView(
                    scrollDirection: Axis.horizontal, // เลื่อนในแนวนอน
                    children: [
                      const SizedBox(width: 16), // เพิ่มช่องว่างทางซ้าย
                      FilledButton(
                          onPressed: () {},
                          child: FilledButton(
                              // onPressed: () => getTrips(),
                              onPressed: () => getTrips(null),
                              child: const Text('ทั้งหมด'))),

                      const SizedBox(width: 8), // เพิ่มช่องว่างระหว่างปุ่ม
                      FilledButton(
                          onPressed: () => getTrips('เอเชีย'),
                          child: const Text('เอเชีย')),
                      const SizedBox(width: 8),
                      FilledButton(
                          onPressed: () => getTrips('ยุโรป'),
                          child: const Text('ยุโรป')),
                      const SizedBox(width: 8),
                      FilledButton(
                          onPressed: () => getTrips('อาเซียน'),
                          child: const Text('อาเซียน')),
                      const SizedBox(width: 8),
                      FilledButton(
                          onPressed: () => getTrips('ประเทศไทย'),
                          child: const Text('ประเทศไทย')),
                      const SizedBox(width: 8),
                      FilledButton(
                          onPressed: () {}, child: const Text('โอเชียเนีย')),
                      const SizedBox(width: 8),
                      FilledButton(
                          onPressed: () {},
                          child: const Text('รายละเอียดเพิ่มเติม')),
                      const SizedBox(width: 16), // เพิ่มช่องว่างทางขวา
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Column(
                        // children: filteredTrips
                        children: trips
                            .map((trip) => Card(
                                  child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            trip.name,
                                            style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0)),
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 160, // กำหนดความกว้าง
                                                height: 160, // กำหนดความสูง
                                                child: Image.network(
                                                  trip.coverimage,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return const Center(
                                                      child: Text(
                                                        'cannot load image',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        'ประเทศ${trip.country}'),
                                                    Text(
                                                        'ระยะเวลา ${trip.duration} วัน'),
                                                    Text(
                                                        'ราคา ${trip.price} บาท'),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        FilledButton(
                                                            onPressed: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        TripPage(
                                                                            idx:
                                                                                trip.idx),
                                                                  ));
                                                            },
                                                            child: const Text(
                                                                'รายละเอียดเพิ่มเติม')),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      )),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }

  // zone can null
  void getTrips(String? zone) {
    http.get(Uri.parse('$url/trips')).then((value) {
      trips = tripGetResponseFromJson(value.body);
      List<TripGetResponse> filteredTrips = [];
      if (zone != null) {
        for (var trip in trips) {
          if (trip.destinationZone == zone) {
            filteredTrips.add(trip);
          }
        }
        trips = filteredTrips;
      }
      setState(() {});
    }).catchError((err) {
      log(err.toString());
    });
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];

    var res = await http.get(Uri.parse('$url/trips'));
    log(res.body);
    trips = tripGetResponseFromJson(res.body);
    log(trips.length.toString());
  }

  gotoTripsPage(int idx) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TripPage(idx: idx),
        ));
  }
}
