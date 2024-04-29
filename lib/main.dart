import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? position;

  @override
  void initState(){
    super.initState();
    _onScreenStrat();
    _listenCurrentLocator();
  }

  Future<void> _onScreenStrat() async{
    bool isEnabled =await Geolocator.isLocationServiceEnabled();
    print(isEnabled);

    LocationPermission permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.whileInUse ||
    permission == LocationPermission.always) {
      position = await Geolocator.getCurrentPosition();
    }else {
      LocationPermission requestStatus = await Geolocator.requestPermission();
      if(requestStatus == LocationPermission.whileInUse ||
          requestStatus == LocationPermission.always){
        _onScreenStrat();
      }else{
        print('Permission denied');
      }
    }
  }

  void _listenCurrentLocator() {
    Geolocator.getPositionStream(locationSettings: LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 1,
      timeLimit: Duration(seconds: 3)
    )
    ).listen((p) {
      print(p);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
          child: Text('current location${position?.latitude}, ${position?.longitude}'),
      ),
    );
  }
}

