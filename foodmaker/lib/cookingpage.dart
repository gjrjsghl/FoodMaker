import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodmaker/value.dart';
import 'package:vibration/vibration.dart';



class cookingInfo extends StatefulWidget {
  cookingInfo();

  @override
  State<cookingInfo> createState() => _cookingInfoState();
}

class _cookingInfoState extends State<cookingInfo> {

  int _selectedPage = 1;
  List<Widget> _selectwidget = <Widget>[
    Cooking(),
    Info()
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromRGBO(239, 190, 111,1),
      appBar: AppBar(
        leading: BackButton(onPressed: () {Navigator.pop(context);}),
        title: _selectedPage == 1 ? Text("My food",style: TextStyle(fontSize: 20,color: Colors.black,decoration: TextDecoration.none)) : myfood[0].img,
        actions: [Text(_selectedPage == 0 ? myfood[0].name : "",style: TextStyle(fontSize: 30,color: Colors.black,decoration: TextDecoration.none)),SizedBox(width: 30,)],
        backgroundColor: _selectedPage == 1 ?Color.fromRGBO(239, 190, 111,1) : Color.fromRGBO(237, 168, 94, 1),
        toolbarHeight: 95,
      ),

      body: Container(
        height: screenheight-100, width: screenwidth,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            height: screenheight-100, width: screenwidth,
            child: _selectwidget[_selectedPage],
          )
        )
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.watch_later_outlined), label: "cooking"),
          BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: "information")
        ],
        currentIndex: _selectedPage,
        selectedItemColor: Colors.black,
        unselectedItemColor: Color.fromARGB(255, 145, 145, 145),
        onTap: _onItemTapped,

      ),
    );
  }
}


class Cooking extends StatefulWidget {
  const Cooking({super.key});

  @override
  State<Cooking> createState() => _CookingState();
}

class _CookingState extends State<Cooking> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    seconds = finaltime*60;

    _startTimer();
  }
  late Timer _timer;

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        seconds--;
      });

      if (seconds == 0) {
        _timer.cancel();
        Vibration.vibrate(duration: 1000);  //진동기능진동기능
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height-100;
    return Container(
      color: Color.fromRGBO(237, 168, 94, 1),
      width: screenwidth, height: screenheight,

      child: Stack(
        children: [
          Column(
            children: [
              Divider(color: Colors.black,thickness: 1),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("권장",style: TextStyle(fontSize: 20,color: Colors.black,decoration: TextDecoration.none)),
                  SizedBox(width: 10),
                  Text("🌡"+finalheat.toString() + "°C",style: TextStyle(fontSize: 20,color: Colors.black,decoration: TextDecoration.none)),
                  SizedBox(width: 25),
                  Text("🕦 "+finaltime.toString() + "m",style: TextStyle(fontSize: 20,color: Colors.black,decoration: TextDecoration.none)),
                ],
              ),
              Expanded(
                child: Container(
                  height: screenheight/3,
                  width: screenheight,
                  decoration: BoxDecoration(color: Color.fromRGBO(239, 190, 111,1), borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
                )
              )
            ],
          ),

          Column(
            children: [
              SizedBox(height: screenheight/10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("현재 ",style: TextStyle(fontSize: 20,color: Colors.black,decoration: TextDecoration.none)),
                  Text(double.parse(S).toString(),style: TextStyle(fontSize: 40,color: Colors.black,decoration: TextDecoration.none)),
                  Text("°C",style: TextStyle(fontSize: 20,color: Colors.black,decoration: TextDecoration.none)),

                  SizedBox(width: 15,),

                  Text("남은 시간 ",style: TextStyle(fontSize: 20,color: Colors.black,decoration: TextDecoration.none)),
                  Text(seconds.toString(),style: TextStyle(fontSize: 40,color: Colors.black,decoration: TextDecoration.none)),
                  Text("초",style: TextStyle(fontSize: 20,color: Colors.black,decoration: TextDecoration.none)),
                ],
              ),
              SizedBox(height: 10,),
              Expanded(
                child: Container(
                  height: screenheight/3,
                  width: screenheight,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
                  child: double.parse(S) > finalheat+10 ? Image.asset("assets/hot.png") : double.parse(S) < finalheat-10 ? Image.asset("assets/cold.png") : seconds > 30 ? Image.asset("assets/well.png") : Image.asset("assets/almost.png")
                )
              )
            ],
          )
        ],
      ),
    );
  }
}


class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    finalheat = myfood[0].heat[0];
    finaltime = myfood[0].time[0];
  }
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Column(
          children: [
            Container(height: screenHeight/3,width: screenWidth),
            Expanded(
              child: Container(
                width: screenWidth,
                decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))),
              )
            )
          ],
        ),
        Container(
          width: screenWidth-50, height: screenHeight*0.07,
          child: Text(myfood[0].name,style: TextStyle(fontSize: 30,color: Colors.white,decoration: TextDecoration.none),textAlign: TextAlign.right),
        ),

        Column(
          children: [
            SizedBox(height : screenHeight*0.05),
            Container(
              width: screenWidth*0.8,height: screenHeight*0.43,
              child: Row(
                children: [
                  Expanded(child: myfood[0].img)
                ]
              ),
            ),
          ],
        ),

        Column(
          children: [
            SizedBox(height: screenHeight*0.45),

            Container(
              width: screenWidth,height: screenHeight*0.1, 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("🌡"+myfood[0].heat[0].toString()+"~"+myfood[0].heat[1].toString()+"°C",style: TextStyle(fontSize: 20,color: Colors.black,decoration: TextDecoration.none)),
                  SizedBox(width: 20),
                  Text("🕦 "+myfood[0].time[0].toString()+"~"+myfood[0].time[1].toString()+"m",style: TextStyle(fontSize: 20,color: Colors.black,decoration: TextDecoration.none)),
                ],
              )
            ),

            Container(
              width: screenWidth, height: screenHeight*0.15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await showDialog(context: context, barrierDismissible: true, builder: (context) {
                        return AlertDialog(
                          content: inputOverray(kind: 0),
                        );
                      }).then((value) => {
                        setState(() {
                          debugPrint("$finalheat");
                        })
                      });
                    },
                    child: Container(
                      child: Text(finalheat.toString() + "°C",style: TextStyle(fontSize: 50,color: Colors.black,decoration: TextDecoration.none)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await showDialog(context: context, barrierDismissible: true, builder: (context) {
                        return AlertDialog(
                          content: inputOverray(kind: 1),
                        );
                      }).then((value) => {
                        setState(() {
                          debugPrint("$finalheat");
                        })
                      });
                    },
                    child: Container(
                      child: Text(finaltime.toString() + "m",style: TextStyle(fontSize: 50,color: Colors.black,decoration: TextDecoration.none)),
                    ),
                  ),
                ],
              ),
            )

          ],
        )
      ],
    );
  }
}




class inputOverray extends StatelessWidget {
  int kind;
  inputOverray({required this.kind});

  TextEditingController a = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;


    return Container(
      width: screenwidth*0.5,
      height : screenheight*0.17,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },

        child: Column(
          children: [
            Form(
            child: Theme(
              data: ThemeData(
                primaryColor: Colors.white,
                inputDecorationTheme: InputDecorationTheme(
                  labelStyle: TextStyle(color: Color.fromRGBO(130, 173, 252, 1)),
                )
              ), child: Container(
                child: Builder(builder: (context) {
                  return Column(
                    children: [
                      Container(

                        child:TextField(
                          controller: a,
                          autofocus: true,
                          keyboardType: TextInputType.number,
                        ), 

                      ),
                      SizedBox(height: 10),
                      ElevatedButton(onPressed: () {
                        if(kind == 0) {
                          finalheat = int.parse(a.text);
                        }else {
                          finaltime = int.parse(a.text);
                        }

                        Navigator.pop(context);
                      }, child: Icon(Icons.check))
                    ],
                  );
                }),
              ), 
            )
          )
          ]
          
        )
      )
    );
  }
}