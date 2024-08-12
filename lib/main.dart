import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Latest Pics From Mars',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 168, 4, 4)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  
  Future callApi() async{
    var response= await http.get(Uri.https('api.nasa.gov','/mars-photos/api/v1/rovers/perseverance/latest_photos',{"api_key":"DEMO_KEY"}));
    var data= jsonDecode(response.body);
    var picsList = [];
    //print(data);
    for (var img in data["latest_photos"]){
      print(img["img_src"]);
      picsList.add([img["img_src"],img["camera"]["name"]]);
    }
    return picsList;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Latest Pics from Perseverance Rover"),
      ),
      body: FutureBuilder(
        future: callApi(),
        builder: (context,snapshot) {
          if (snapshot.connectionState==ConnectionState.done){
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context,index){
                return Column(
                  children: [
                    Text(snapshot.data[index][1]),
                    Image.network(snapshot.data[index][0])
                  ],
                  // title:Text(snapshot.data[index][1]),
                  // leading:Image.network(snapshot.data[index][0]),
                  
                );
              }
            );
          }
          else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }

        },
      ), 
      );
  }
}

