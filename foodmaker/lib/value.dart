import 'dart:typed_data';
import 'package:bluetooth_classic/models/device.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:flutter/material.dart';

//음식 리스트
List<Explore> explore = [];
List<Myfood> myfood = [];

int finalheat = 0;
int finaltime = 0;
int seconds = 0;

//블루투스 관련 부분
Uint8List data = Uint8List(0);

String S = "0";
String preS = "0";

String platformVersion = 'Unknown';
final bluetoothClassicPlugin = BluetoothClassic();
List<Device> devices = [];
List<Device> discoveredDevices = [];
bool scanning = false;
int deviceStatus = Device.disconnected;

class Explore { //탐색 음식
  String name;
  List<int> time;
  List<int> heat;
  Image img;

  Explore({required this.name,required this.time,required this.heat, required this.img});

  void setMenu(String s,List<int> t, List<int> h) { //값 수정에 쓸 예정
    name = s;
    time = t;
    heat = h;
  }

  void move() {  //음식 옮기기
    List<Myfood> temp = [];
    temp.add(Myfood(name: name, time: time, heat: heat, img: img));
    temp.addAll(myfood);
    myfood = temp.toList();
  }
}

class Myfood { //최근 음식
  String name;
  List<int> time;
  List<int> heat;
  Image img;
  Myfood({required this.name,required this.time,required this.heat,required this.img});

  void setMenu(String s,List<int> t, List<int> h) { //값 수정에 쓸 예정
      name = s;
      time = t;
      heat = h;
  }
}