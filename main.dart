import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'mainPage.dart';
import 'signIn.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInPage(),
    );
  }
}

class EventsPage extends StatefulWidget{
  List<dynamic> events;

  EventsPage(this.events);
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Search Results", style:TextStyle(fontFamily: "Permanent Marker"))
      ),
      body: 
        ListView.builder(
          itemCount:widget.events.length,
          itemBuilder: (BuildContext context, int index) {
            String eventName = widget.events[index]["strEvent"];
            String sportType = widget.events[index]["strSport"];
            String date = widget.events[index]["dateEvent"];
            String time = widget.events[index]["strTime"];
            String league = widget.events[index]["strLeague"];
            String homeScore = widget.events[index]["intHomeScore"];
            String awayScore = widget.events[index]["intAwayScore"];
            String picture = widget.events[index]["strThumb"];
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




class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<List<dynamic>> getPreviousEvents() async {
    var url = "https://www.thesportsdb.com/api/v1/json/1/eventslast.php?id=133738";
    var response = await http.get(url);
    var events_json = jsonDecode(response.body);
    events_json = events_json["results"];
    return events_json;
  }

  Future<List<dynamic>> getNextEvents(var id) async {
    var url = "https://www.thesportsdb.com/api/v1/json/1/eventslast.php?id=$id";
    var response = await http.get(url);
    var events_json = jsonDecode(response.body);
    events_json = events_json["results"];
    return events_json;
  }

  Future<String> getTeamId(var teamName) async {
    var url = "https://www.thesportsdb.com/api/v1/json/1/searchteams.php?t=$teamName";
    var response = await http.get(url);
    var teamInfo = jsonDecode(response.body);
    teamInfo = teamInfo["teams"][0];
    var teamId = teamInfo["idTeam"];
    return teamId;
  }

  void events(context, var tName) async {
    var tid = await getTeamId(tName);
    var events = await getNextEvents(tid);
    Navigator.push(context, MaterialPageRoute(builder: (context) => EventsPage(events)));
  }

  TextEditingController teamSearch = TextEditingController();
  
  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Search", style: TextStyle(fontFamily: 'Permanent Marker')),
      ),
      body:
       Column(
          children: <Widget>[
            Padding(
              padding:EdgeInsets.all(15),
              child: TextField(
                controller: teamSearch,
                decoration: InputDecoration(
                  hintText: "Search for any team"
                ),
              )
            ), 
          SizedBox(height: 10,),
          Padding(
            padding:EdgeInsets.only(left: 10),
            child: RaisedButton(
              onPressed:(){
                events(context, teamSearch.text); 
                },
              color: Colors.black,
              child: Text(" Search Fixtures ", style: TextStyle(color: Colors.white, fontFamily: 'Permanent Marker'),),
            )
          ),
        ],
        )
    );
  }
}
