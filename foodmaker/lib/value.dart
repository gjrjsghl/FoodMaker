import 'dart:typed_data';

import 'package:bluetooth_classic/models/device.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:flutter/material.dart';

List<Explore> explore = [];
List<Myfood> myfood = [];

int finalheat = 0;
int finaltime = 0;
int seconds = 0;

Uint8List data = Uint8List(0);

String S = "0";
String preS = "0";

String platformVersion = 'Unknown';
final bluetoothClassicPlugin = BluetoothClassic();
List<Device> devices = [];
List<Device> discoveredDevices = [];
bool scanning = false;
int deviceStatus = Device.disconnected;

class Explore {
  String name;
  List<int> time;
  List<int> heat;
  Image img;

  Explore({required this.name,required this.time,required this.heat, required this.img});

  void setMenu(String s,List<int> t, List<int> h) {
    name = s;
    time = t;
    heat = h;
  }

  void move() {
    List<Myfood> temp = [];
    temp.add(Myfood(name: name, time: time, heat: heat, img: img));
    temp.addAll(myfood);
    myfood = temp.toList();
  }
}

class Myfood {
  String name;
  List<int> time;
  List<int> heat;
  Image img;
  Myfood({required this.name,required this.time,required this.heat,required this.img});
  void setMenu(String s,List<int> t, List<int> h) {
      name = s;
      time = t;
      heat = h;
  }
}