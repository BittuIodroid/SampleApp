import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:climatic/style/style.dart';
import 'package:climatic/utils/util.dart' as util;
import 'package:climatic/ui/change_city.dart';
import 'package:permission/permission.dart';        // to give permission to access internet

class Climatic extends StatefulWidget {
  @override
  _ClimaticState createState() => _ClimaticState();
}

class _ClimaticState extends State<Climatic> {

  String _cityEntered;
  // Method to store JSON from API
//  void showWeather() async{
//    Map data=await getWeather(util.apiId, "hello");
//    print(data.toString());
//  }

      //Method to navigate to next screen
  Future _goToNextScreen(BuildContext context) async{
    Map results = await Navigator.of(context).push(           //navigating to the next screen and storing the city received from next screen
      MaterialPageRoute<Map>(builder: (BuildContext context){       // creating the bridge to go to next screen
        return ChangeCity();

      })
    );

    if(results!=null && results.containsKey("city")){
      _cityEntered = results['city'];
    }
  }


  //First Screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("Klimatic"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.location_searching),
              onPressed: (){ _goToNextScreen(context);}
          ),
        ],
      ),

      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset("images/umbrella.png",
            width: 500.0,
            height: 1200.0,
            fit: BoxFit.fill,),
          ),
          
          Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
            child: Text("${_cityEntered == null ? util.defaultCity : _cityEntered}",
            style: cityStyle(),),
          ),
          
          Container(
            alignment: Alignment.center,
            child: Image.asset("images/light_rain.png",width: 500.0,height: 500.0),
          ),
          updateTempWidget(_cityEntered),


        ],
      ),
    );
  }

               //Fetching JSON from API
  Future<Map> getWeather(String apiId, String city) async{
    String apiUrl = 'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.apiId}&units=metric';
    http.Response response= await http.get(apiUrl);
    return json.decode(response.body);
  }


  //Creating a widget to display Temperature and Weather
  Widget updateTempWidget(String city) {
    return FutureBuilder(
        future: getWeather(util.apiId, city == null ? util.defaultCity : city),
        // ignore: missing_return
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          // where we get all the json data, we setup widget etc.
          if (snapshot.hasData) {
            Map weather = snapshot.data;
            if(weather.containsValue("404")){     // Checking if city is available or not
              return Container(
                width: 350,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(50),
                    gradient: LinearGradient(
                      colors: [Colors.red, Colors.blueAccent],


                    )
                ),
                margin: const EdgeInsets.fromLTRB(30, 450, 0, 0),
                child: Text("City Not Found",
                style: cityStyle(),),
              );
            }
            else {
              return Container(
                margin: const EdgeInsets.fromLTRB(15.0, 450.0, 0.0, 0.0),
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      title: Align(                 // Adding Align widget because width is not working for the Container
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 200.0,
                          height: 80.0,
                          padding: const EdgeInsets.only(left:10,top:10,bottom:10),
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular( 50.0),
                              gradient: LinearGradient(
                                colors: [Colors.red, Colors.blueAccent],
                              )


                          ),
                          child: Text(weather['main']['temp'].toString() + " C",
                            style: tempStyle(),
                          ),
                        ),
                      ),

                      subtitle: ListTile(
                        title: Text(
                          "Humidity : ${weather['main']['humidity'].toString()}\n"
                              "Min Temperature : ${weather['main']['temp_min'].toString()} C\n"
                              "Max Remperature : ${weather['main']['temp_max']
                              .toString()} C",
                          style: TextStyle(color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontSize: 20),
                        ),
                      ),

                    )

                  ],
                ),
              );
            }

          }
          else {
            return Container();
          }
        });
  } //updateTempWidget
} //_ClimaticState



