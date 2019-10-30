import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChangeCity extends StatelessWidget {

  var _cityFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("Change City"),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Center(
              child: Image.asset("images/white_snow.png",
                width: 500,
                height: 1200,
                fit: BoxFit.fill,)
          ),

          ListView(
            children: <Widget>[
              ListTile(
                title: TextField(
                  controller: _cityFieldController,
                  decoration: InputDecoration(
                    hintText: "Enter City",
                    // errorText: _validate == true ? "Please Enter a City Name" : null,
                  ),


                  keyboardType: TextInputType.text,
                ),

              ),

              ListTile(
                title: FlatButton(
                  onPressed: (){
                    if(_cityFieldController.text.isNotEmpty){
                      Navigator.pop(context,{
                        "city":_cityFieldController.text
                      });
                    }



                  },
                  color: Colors.blueAccent,
                  child: Text("Get Weather"),
                  textColor: Colors.black,

                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
