import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

class MainPage extends StatefulWidget{
  List<dynamic> allEvents;

  MainPage(this.allEvents);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Personal Fixtures", style: TextStyle(fontFamily:'Permanent Marker'),),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(title:"Search")));
            },
    )
        ],
      ),
      body: 
        ListView.builder(
          itemCount:widget.allEvents.length,
          itemBuilder: (BuildContext context, int index) {
            String eventName = widget.allEvents[index]["strEvent"];
            String sportType = widget.allEvents[index]["strSport"];
            String date = widget.allEvents[index]["dateEvent"];
            String time = widget.allEvents[index]["strTime"];
            String league = widget.allEvents[index]["strLeague"];
            String homeScore = widget.allEvents[index]["intHomeScore"];
            String awayScore = widget.allEvents[index]["intAwayScore"];
            String picture = widget.allEvents[index]["strThumb"];
            if(picture == null){
              picture = "https://mediacdn.mancity.com/-/media/news-pics/2019/march/gettyimages-1134086190.ashx?width=1024&height=576";
            }
            if(homeScore == null){
              homeScore = "null";
            
            }
            if(awayScore == null){
              awayScore = "null";
            }
            return
            Card(
              child:
                Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 16.0 / 9.0,
                    child: Image.network(
                      picture,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text(eventName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, fontFamily: 'Permanent Marker'),),
                  Text(homeScore + "        --        " + awayScore, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, fontFamily: 'Permanent Marker')),
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.only(right: 216),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.calendar_today),
                        SizedBox(width: 10,),
                        Text(date, style: TextStyle(fontFamily: 'Permanent Marker')),
                      ],
                    )),
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.only(right: 216),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.access_time),
                        SizedBox(width: 4,),
                        Text(time, style: TextStyle(fontFamily: 'Permanent Marker')),
                      ],
                    )),
                  SizedBox(height: 20,)
                ])
            );
          }

        ),
    );
  }
}

