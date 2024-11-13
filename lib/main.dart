import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Sensor App',
      theme: ThemeData(
        primaryColor: Colors.teal[700],
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100], // Background light
        cardColor: Colors.white, // Card background color
        appBarTheme: AppBarTheme(
          color: Colors.teal[700],
          foregroundColor: Colors.white,
        ),
      ),
      home: DataScreen(),
    );
  }
}

class DataModel {
  final int suhumax;
  final int suhumin;
  final double suhurata;
  final List<NilaiSuhu> nilaiSuhuMaxHumidMax;
  final List<MonthYear> monthYearMax;

  DataModel({
    required this.suhumax,
    required this.suhumin,
    required this.suhurata,
    required this.nilaiSuhuMaxHumidMax,
    required this.monthYearMax,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    var listNilaiSuhu = json['nilai_suhu_max_humid_max'] as List;
    var listMonthYear = json['month_year_max'] as List;

    return DataModel(
      suhumax: json['suhumax'],
      suhumin: json['suhumin'],
      suhurata: double.parse(json['suhurata'].toString()),
      nilaiSuhuMaxHumidMax:
          listNilaiSuhu.map((i) => NilaiSuhu.fromJson(i)).toList(),
      monthYearMax: listMonthYear.map((i) => MonthYear.fromJson(i)).toList(),
    );
  }
}

class NilaiSuhu {
  final int idx;
  final int suhu;
  final int humid;
  final int kecerahan;
  final String timestamp;

  NilaiSuhu({
    required this.idx,
    required this.suhu,
    required this.humid,
    required this.kecerahan,
    required this.timestamp,
  });

  factory NilaiSuhu.fromJson(Map<String, dynamic> json) {
    return NilaiSuhu(
      idx: json['idx'],
      suhu: json['suhu'],
      humid: json['humid'],
      kecerahan: json['kecerahan'],
      timestamp: json['timestamp'],
    );
  }
}

class MonthYear {
  final String monthYear;

  MonthYear({required this.monthYear});

  factory MonthYear.fromJson(Map<String, dynamic> json) {
    return MonthYear(
      monthYear: json['month_year'],
    );
  }
}

class DataService {
  final String baseUrl = 'http://192.168.3.11:3000/data';

  Future<DataModel> fetchData() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        return DataModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Gagal memuat data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke server: $e');
    }
  }
}

class DataScreen extends StatefulWidget {
  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final DataService dataService = DataService();
  Timer? _timer;
  late Stream<DataModel> _dataStream;

  @override
  void initState() {
    super.initState();
    _dataStream = Stream.periodic(Duration(seconds: 5))
        .asyncMap((_) => dataService.fetchData());

    _startDataRefresh();
  }

  void _startDataRefresh() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('152022083 Much Monitoring System',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: StreamBuilder<DataModel>(
          stream: _dataStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Terjadi Kesalahan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${snapshot.error}'.contains('SocketException')
                            ? 'Tidak dapat terhubung ke server.\nPastikan server sedang berjalan dan dapat diakses.'
                            : '${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red[700], fontSize: 16),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {});
                        },
                        icon: Icon(Icons.refresh),
                        label: Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasData) {
              var data = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ringkasan Suhu',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal[900],
                              ),
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildSuhuInfo('Suhu Max', '${data.suhumax}°C',
                                    Colors.red),
                                _buildSuhuInfo('Suhu Min', '${data.suhumin}°C',
                                    Colors.blue),
                                _buildSuhuInfo('Suhu Rata',
                                    '${data.suhurata}°C', Colors.black),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Detail Pengukuran',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    ...data.nilaiSuhuMaxHumidMax.map((nilai) => Card(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'ID: ${nilai.idx}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      nilai.timestamp,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildMeasurement('Suhu', '${nilai.suhu}°C',
                                        Icons.thermostat),
                                    _buildMeasurement('Kelembaban',
                                        '${nilai.humid}%', Icons.water_drop),
                                    _buildMeasurement('Kecerahan',
                                        '${nilai.kecerahan}', Icons.wb_sunny),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )),
                    SizedBox(height: 16),
                    Text(
                      'Periode Waktu',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    ...data.monthYearMax.map((monthYear) => Card(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: Icon(Icons.calendar_month,
                                color: Colors.teal[700]),
                            title: Text(
                              monthYear.monthYear,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        )),
                  ],
                ),
              );
            } else {
              return Center(child: Text('Tidak ada data.'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildSuhuInfo(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildMeasurement(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.teal[700], size: 28),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
