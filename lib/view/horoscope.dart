import 'package:flutter/material.dart';
import 'package:horoscope_app/services/data.dart';
import 'package:http/http.dart' as http;
import 'package:horoscope_app/services/zodiacsign.dart';
import 'dart:convert';

class HoroscopePage extends StatefulWidget {
  const HoroscopePage({Key? key, required this.selectedDate}) : super(key: key);
  final DateTime selectedDate;

  @override
  _HoroscopePageState createState() =>
      _HoroscopePageState(selectedDate: selectedDate);
}

class _HoroscopePageState extends State<HoroscopePage> {
  _HoroscopePageState({required this.selectedDate});
  final DateTime selectedDate;
  late String sign;
  late Future<Data> futureAlbum;

  void initState() {
    sign = new Zodiac().getSign(selectedDate);
    futureAlbum = getInfo();
    super.initState();
  }

  Future<Data> getInfo() async {
    final response = await http.post(
        Uri.parse('https://aztro.sameerkumar.website/?sign=$sign&day=today'));
    if (response.statusCode == 200) {
      return Data.fromJson(jsonDecode(response.body));
    } else {
      print("not success");
      throw Exception("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Horoscope ",
              style: TextStyle(fontSize: 22),
            ),
            Text(
              "App",
              style: TextStyle(fontSize: 22, color: Colors.blue),
            )
          ],
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/nebula.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image(
                      image: AssetImage('images/${sign.toLowerCase()}.png'),
                      width: 200,
                      height: 200,
                      fit: BoxFit.fill,
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Zodiac Sign: ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    sign,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Today's horroscope:-",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15,
              ),
              FutureBuilder<Data>(
                future: futureAlbum,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Text(snapshot.data!.description,
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.justify),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
