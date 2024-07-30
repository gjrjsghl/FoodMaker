import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodmaker/connect.dart';
import 'package:foodmaker/cookingpage.dart';
import 'package:foodmaker/value.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);  //화면 회전 고정

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      home: BasicBoard(),
    );
  }
}

class BasicBoard extends StatelessWidget {
  const BasicBoard({super.key});
  
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height; //화면크기
    double screenWidth = MediaQuery.of(context).size.width;   //화면크기
    return Container(
      color: Colors.white,
      width: screenWidth,
      height: screenHeight,
      child : Column(
        children: [
          SizedBox(height: 50),
          Container(
            width: screenWidth, height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Image.asset("assets/top1.png"),),
                Expanded(child: Image.asset("assets/top2.png"),),
                Expanded(child: Image.asset("assets/top3.png"),),
              ],
            ),
          ),
          SizedBox(height: 50),

          Container(
            width: screenWidth, height: screenHeight-150,
            child: SingleChildScrollView(  //자판 올라올때 화면 안깨지게 막는 용도
              child: FoodSelection(),
            )
          )
          
        ],
      )
    );
  }
}


class FoodSelection extends StatefulWidget {
  const FoodSelection({super.key});

  @override
  State<FoodSelection> createState() => _FoodSelectionState();
}

class _FoodSelectionState extends State<FoodSelection> { //음식 화면

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //기본 음식 목록 추가
    myfood.add(Myfood(name: "계란후라이", time: [3,5], heat: [163,177],img: Image.asset("assets/eggfry.png")));
    myfood.add(Myfood(name: "라면", time: [5,5], heat: [100,100],img: Image.asset("assets/raman.png")));
    myfood.add(Myfood(name: "볶음밥", time: [5,5], heat: [100,100],img: Image.asset("assets/bokemrice.png")));

    explore.add(Explore(name: "오므라이스", time: [5,5], heat: [100,100],img: Image.asset("assets/omerice.png")));
    explore.add(Explore(name: "카레라이스", time: [5,5], heat: [100,100],img: Image.asset("assets/curryrice.png")));
    explore.add(Explore(name: "김치찌개", time: [5,5], heat: [100,100],img: Image.asset("assets/kimchi.png")));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width-50;
    double screenHeight = MediaQuery.of(context).size.height-150;
    double tempHeight = screenHeight/2.5;
    return Column(
      children: [
        Container(
          height: tempHeight,
          width: screenWidth,
          child : Column(
            children: [
              Container(
                height: 60,
                width: screenWidth,
                child: Text("최근 음식",style: TextStyle(fontSize: 30,color: Colors.black,decoration: TextDecoration.none),textAlign: TextAlign.left,)
              ),
              Container(
                height: tempHeight-70, width: screenWidth,
                child: ListView.separated( //가로 리스트
                  scrollDirection: Axis.horizontal,
                  itemCount: myfood.length,
                  itemBuilder: (BuildContext ctx, int idx) {
                    return GestureDetector(
                      onTap: () { //도형 클릭 이벤트 감지
                        List<Myfood> temp = [];
                        temp.add(myfood[idx]);
                        myfood.removeAt(idx);
                        temp.addAll(myfood);
                        setState(() {
                          myfood = temp.toList(); //toList() 붙여야 깊은 복사
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context) => cookingInfo())); //화면 넘기기
                      },

                      child: Stack(
                        children: [
                           Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(239, 190, 111,1),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            height: tempHeight-70, width: (tempHeight-100),

                            child: Column(
                              children: [
                                Container(
                                  height: tempHeight-110,
                                ),
                                Text(myfood[idx].name,style: TextStyle(fontSize: 20,color: Colors.black,decoration: TextDecoration.none),textAlign: TextAlign.left) 
                              ],
                            ),
                          ),
                          Container(
                            height: tempHeight-110, width: (tempHeight-70),
                            child: Row(
                              children: [
                                SizedBox(width: 40),
                                Expanded(child: myfood[idx].img)
                              ],
                            ),
                          ),
                        ],
                      )
                    );
                  },
                  separatorBuilder: (BuildContext cxt, int idx) {
                    return SizedBox(width: 20); //간격박스 크기 (옆으로 리스트뷰)
                  }
                  
                ),
              ),
            ],
          )
        ),

        SizedBox(height: 30),



        Container(
          height: tempHeight,
          width: screenWidth,
          child : Column(
            children: [
              Container(
                height: 60,
                width: screenWidth,
                child: Text("이런 음식은 어때요?",style: TextStyle(fontSize: 30,color: Colors.black,decoration: TextDecoration.none),textAlign: TextAlign.left,)
              ),
              Container(
                height: tempHeight-70, width: screenWidth,
                child: ListView.separated( //가로 리스트 만들기
                  scrollDirection: Axis.horizontal,
                  itemCount: explore.length,
                  itemBuilder: (BuildContext ctx, int idx) {
                    return GestureDetector( //도형 클릭 감지
                      onTap: () {
                        setState(() {
                          explore[idx].move();
                          explore.removeAt(idx);
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context) => cookingInfo())); //화면 넘김
                      },

                      child: Stack(
                        children: [
                           Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(239, 190, 111,1),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            height: tempHeight-70, width: (tempHeight-100),

                            child: Column(
                              children: [
                                Container(
                                  height: tempHeight-110,
                                ),
                                Text(explore[idx].name,style: TextStyle(fontSize: 20,color: Colors.black,decoration: TextDecoration.none),textAlign: TextAlign.left) 
                              ],
                            ),
                          ),
                          Container(
                            height: tempHeight-110, width: (tempHeight-70),
                            child: Row(
                              children: [
                                SizedBox(width: 40),
                                Expanded(child: explore[idx].img)
                              ],
                            ),
                          ),
                        ],
                      )
                    );
                  },
                  separatorBuilder: (BuildContext cxt, int idx) {
                    return SizedBox(width: 20); //간격박스 크기 (옆으로 리스트뷰)
                  }
                  
                ),
              ),
            ],
          )
        ),

        SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () async {
                await showDialog(context: context, barrierDismissible: true, builder: (context) { 
                  return AlertDialog(
                    content: addOverrary(),
                  );
                }).then((value) => {  //클릭 후 오버레이 갔다가 돌아와서 실행
                  setState(() {})
                });
              },
              child: Container(
                height: tempHeight*0.5-50,
                child: Text("조리법 추가",style: TextStyle(fontSize: 20,color: Colors.black,decoration: TextDecoration.none),textAlign: TextAlign.left),  
              ),
            ),

            IconButton(onPressed: () async { //블루투스 버튼
              Navigator.push(context, MaterialPageRoute(builder: (context) => connect())).then((value) => {
                if(deviceStatus == 2)  readroop()  //갔다 와서 연결되었을시 읽기 시작
              });
            }, icon: Icon(Icons.bluetooth))

          ],
        )

        
      ],
    );
  }
}

void readroop() {
  //그냥 블루투스 계속 읽는 코드
  bluetoothClassicPlugin.onDeviceDataReceived().listen((event) {

    data = Uint8List.fromList(event);
    preS = S;
    S = String.fromCharCodes(data);
    
    try {
      int k = int.parse(S);
    } catch(e) {
      if(double.parse(S) - double.parse(preS) < -15) {
        S = preS;
      } //이전 값 대비 값이 튀면 버림 (블루투스 print 값 누락 문제 대응)

      
    } //값이 실수값이 아니면 버림 (블루투스 print 값 누락 문제 대응)

    debugPrint(S);
  });
}




class addOverrary extends StatelessWidget { //음식 추가 오버레이

  addOverrary();

  TextEditingController h = TextEditingController(); //heat
  TextEditingController t = TextEditingController(); //time
  TextEditingController n = TextEditingController(); //name


  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;


    return Container(
      width: screenwidth*0.5,
      height : screenheight*0.25,
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
                        child : Column(
                          children: [
                            Container( //입력창 이름
                              width: screenwidth*0.5/1.2,
                              child:TextField(
                                controller: n,
                                autofocus: true,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(labelText: "이름"),
                              ), 
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container( //입력창 온도
                                  width: screenwidth*0.5/3,
                                  child:TextField(
                                    controller: h,
                                    autofocus: true,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(labelText: "온도"),
                                  ), 
                                ),

                                Container( //입력창 시간
                                  width: screenwidth*0.5/3,
                                  child:TextField(
                                    controller: t,
                                    autofocus: true,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(labelText: "시간"),
                                  ), 
                                ),
                              ],
                            ),
                          ],
                        )
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(onPressed: () {
                        //음식 목록에 추가
                        explore.add(Explore(name: n.text, time: [int.parse(t.text),int.parse(t.text)], heat: [int.parse(h.text),int.parse(h.text)], img: Image.asset("assets/temp.png")));
                        Navigator.pop(context); //현재화면(오버레이) 삭제
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