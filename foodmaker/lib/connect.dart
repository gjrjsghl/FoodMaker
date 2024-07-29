import 'package:bluetooth_classic/models/device.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:foodmaker/value.dart';

class connect extends StatefulWidget {
  const connect({super.key});

  @override
  State<connect> createState() => _connectState();
}

class _connectState extends State<connect> {
  @override
  void initState() {
    super.initState();
    try {
      initPlatformState();
      bluetoothClassicPlugin.onDeviceStatusChanged().listen((event) {
        setState(() {
          deviceStatus = event;
        });
      });

    } catch(e) {} 
    
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await bluetoothClassicPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      platformVersion = platformVersion;
    });
  }

  Future<void> _getDevices() async {
    var res = await bluetoothClassicPlugin.getPairedDevices();
    setState(() {
      devices = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text("Device status is $deviceStatus"),
              TextButton(
                onPressed: () async {
                  await bluetoothClassicPlugin.initPermissions();
                },
                child: const Text("Check Permissions"),
              ),
              TextButton(
                onPressed: _getDevices,
                child: const Text("Find device"),
              ),
              TextButton(
                onPressed: deviceStatus == Device.connected
                    ? () async {
                        await bluetoothClassicPlugin.disconnect();
                      }
                    : null,
                child: const Text("disconnect"),
              ),
              Center(
                child: Text('Running on: $platformVersion\n'),
              ),
              ...[
                for (var device in devices)
                  TextButton(
                      onPressed: () async {
                        await bluetoothClassicPlugin.connect(device.address,
                            "00001101-0000-1000-8000-00805f9b34fb");
                        setState(() {
                          discoveredDevices = [];
                          devices = [];
                        });
                      },
                      child: Text(device.name ?? device.address))
              ],
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("return"),
              ),
              ...[
                for (var device in discoveredDevices)
                  Text(device.name ?? device.address)
              ],
            ],
          ),
        ),
      ),
    );
  }
}