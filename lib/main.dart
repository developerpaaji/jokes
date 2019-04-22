import 'package:flutter/material.dart';
import 'package:jokes/custom_painter.dart';
import 'package:flutter/foundation.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:jokes/models/joke.dart';
import 'package:jokes/utils/networking.dart' as network;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the conso le where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          accentColor: Colors.white),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new HomeWidgetState();
  }
}

class HomeWidgetState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final List<Tab> tabs = <Tab>[
    new Tab(text: "General"),
    new Tab(text: "Programming"),
  ];

  TabController _tabController;
  int currentIndex=0;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: tabs.length);
    _tabController.addListener((){
      if(_tabController.index!=currentIndex){
        setState(() {
          currentIndex=_tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  get color =>colors[currentIndex];
  List<Color>colors=[Colors.blueAccent,Colors.redAccent];
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: color,
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Jokes'),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        bottom: new TabBar(
          isScrollable: true,
          unselectedLabelColor: Colors.white70,
          labelColor: color,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: new BubbleTabIndicator(
            indicatorHeight: 36.0,
            indicatorColor: Colors.white,
            tabBarIndicatorSize: TabBarIndicatorSize.tab,
          ),
          tabs: tabs,
          labelStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          unselectedLabelStyle:
              TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          controller: _tabController,
        ),
      ),
      body: new TabBarView(
        controller: _tabController,
        children: tabs.map((Tab tab) {
          return new Container(
            padding: EdgeInsets.only(top: 8.0),
              child: FutureBuilder(
                  future: network.getJokes(tab.text.toLowerCase()),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      List<Joke> jokes = snapshot.data;
                      return ListView.builder(
                        itemBuilder: (context, index) => Padding(
                              padding: EdgeInsets.all(8.0),
                              child: buildJoke(jokes[index]),
                            ),
                        shrinkWrap: true,
                        itemCount: jokes.length,
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  }));
        }).toList(),
      ),
    );
  }
  Widget buildJoke(Joke joke){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.0,horizontal: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 16.0),
          decoration: BoxDecoration(color: Colors.white,boxShadow: [BoxShadow(color: Colors.white,blurRadius: 16.0,spreadRadius: 0.2)],border: Border(left: BorderSide(color: color))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Que - ${joke.setup}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 18.0),),
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Text("Ans - ${joke.punchline}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 18.0)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
