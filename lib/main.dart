import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String lectureName;
  int lectureCredit = 1;
  double lectureLetterValue = 4;
  List<Lecture> allLectures;
  double average = 0;
  var formKey = GlobalKey<FormState>();
  static int sayac = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allLectures = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false, //klavye acildiginda bazen sarariyo yani sari siyah bisey cikiyo onu engellemek icin
      appBar: AppBar(
        title: Text("Average Calculator"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
          }
        },
        child: Icon(Icons.add),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          //ekran yan cevrildiginde veya tablette falan duzgun gozukmesi icin
          if (orientation == Orientation.portrait) {
            return appBody();//ekran duzken bu caliscak
          } else {
            return appBodyLandscape(); //ekran yan donduyse bu caliscak
          }
        },
      ),
    );
  }

  Widget appBody() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment
            .stretch, //Column oldugu icin cross dedigmizde soldan saga yani yukseklik degil genisligi anlamaliyiz.
        children: <Widget>[
          //CONTAINER FOR FORM
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            color: Colors.white,
            child: Form(
                key: formKey,
                child: Column(
                  //dikeyse bu sekilde kalcak.
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Lecture Name",
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 20),
                        hintText: "Enter The Lecture Name",
                        hintStyle: TextStyle(fontSize: 20),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          borderSide: BorderSide(color: Colors.pink, width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value.length > 0) {
                          /* for (int i = 0; i < allLectures.length; i++) {
                            if (allLectures[i].name == value)
                              return "Already added same lecture name";
                          }*/
                          return null;
                        } else
                          return "Lecture field can not be empty";
                      },
                      onSaved: (newValue) {
                        lectureName = newValue;
                        setState(() {
                          allLectures.add(Lecture(
                              lectureName,
                              lectureLetterValue,
                              lectureCredit,
                              createRandomlyColor()));
                          average = 0;
                          calculateTheAverage();
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: DropdownButton<int>(
                            items: creditOfLectureItems(),
                            value: lectureCredit,
                            onChanged: (value) {
                              setState(() {
                                lectureCredit = value;
                              });
                            },
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          margin: EdgeInsets.only(top: 15),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                        Container(
                          child: DropdownButton<double>(
                            items: lectureLetterValueItems(),
                            value: lectureLetterValue,
                            onChanged: (value) {
                              setState(() {
                                lectureLetterValue = value;
                              });
                            },
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          margin: EdgeInsets.only(top: 15),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        )
                      ],
                    ),
                  ],
                )),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            height: 35,
            /*decoration: BoxDecoration(
              border: BorderDirectional(
                top: BorderSide(color: Colors.blue,width: 2),
                bottom: BorderSide(color: Colors.blue,width: 2)
              )
            ),*/
            width: MediaQuery.of(context)
                .size
                .width, //cihaza gore responsive olmasi icin
            color: Colors
                .white, //yukardaki yorum satirini acarsan bu color'i kapatmalisin
            child: Center(
                child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                    text: allLectures.length == 0
                        ? "You have not added any lecture yet"
                        : "Ortalama : ",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 25,
                    )),
                TextSpan(
                    text: allLectures.length == 0
                        ? ""
                        : "${average.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ))
              ]),
            )),
          ),
          RaisedButton(
            color: Colors.red,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Text(
              "Remove All",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            onPressed: () {
              setState(() {
                allLectures.clear();
              });
            },
          ),
          //CONTAINER FOR LIST
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                itemBuilder: _createListItems,
                itemCount: allLectures.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget appBodyLandscape() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  color: Colors.white,
                  child: Form(
                      key: formKey,
                      child: Column(
                        //dikeyse bu sekilde kalcak.
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Lecture Name",
                              labelStyle:
                                  TextStyle(color: Colors.black, fontSize: 20),
                              hintText: "Enter The Lecture Name",
                              hintStyle: TextStyle(fontSize: 20),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                borderSide:
                                    BorderSide(color: Colors.pink, width: 2),
                              ),
                            ),
                            validator: (value) {
                              if (value.length > 0) {
                                /* for (int i = 0; i < allLectures.length; i++) {
                                if (allLectures[i].name == value)
                                  return "Already added same lecture name";
                              }*/
                                return null;
                              } else
                                return "Lecture field can not be empty";
                            },
                            onSaved: (newValue) {
                              lectureName = newValue;
                              setState(() {
                                allLectures.add(Lecture(
                                    lectureName,
                                    lectureLetterValue,
                                    lectureCredit,
                                    createRandomlyColor()));
                                average = 0;
                                calculateTheAverage();
                              });
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                child: DropdownButton<int>(
                                  items: creditOfLectureItems(),
                                  value: lectureCredit,
                                  onChanged: (value) {
                                    setState(() {
                                      lectureCredit = value;
                                    });
                                  },
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                margin: EdgeInsets.only(top: 15),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 2),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                              Container(
                                child: DropdownButton<double>(
                                  items: lectureLetterValueItems(),
                                  value: lectureLetterValue,
                                  onChanged: (value) {
                                    setState(() {
                                      lectureLetterValue = value;
                                    });
                                  },
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                margin: EdgeInsets.only(top: 15),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 2),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              )
                            ],
                          ),
                        ],
                      )),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  height: 35,
                  /*decoration: BoxDecoration(
              border: BorderDirectional(
                top: BorderSide(color: Colors.blue,width: 2),
                bottom: BorderSide(color: Colors.blue,width: 2)
              )
            ),*/
                  width: MediaQuery.of(context)
                      .size
                      .width, //cihaza gore responsive olmasi icin
                  color: Colors
                      .white, //yukardaki yorum satirini acarsan bu color'i kapatmalisin
                  child: Center(
                      child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                          text: allLectures.length == 0
                              ? "You have not added any lecture yet"
                              : "Ortalama : ",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 25,
                          )),
                      TextSpan(
                          text: allLectures.length == 0
                              ? ""
                              : "${average.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ))
                    ]),
                  )),
                ),
                RaisedButton(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    "Remove All",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  onPressed: () {
                    setState(() {
                      allLectures.clear();
                    });
                  },
                ),
              ],
            ),
            flex: 1,
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                itemBuilder: _createListItems,
                itemCount: allLectures.length,
              ),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> creditOfLectureItems() {
    List<DropdownMenuItem<int>> credits = [];

    for (int i = 1; i <= 10; i++) {
      credits.add(DropdownMenuItem<int>(
          value: i,
          child: Text(
            "$i Credit",
            style: TextStyle(fontSize: 25),
          )));
    }

    return credits;
  }

  List<DropdownMenuItem<double>> lectureLetterValueItems() {
    List<DropdownMenuItem<double>> letters = [];
    letters.add(DropdownMenuItem(
      child: Text(
        "AA",
        style: TextStyle(fontSize: 25),
      ),
      value: 4.0,
    ));
    letters.add(DropdownMenuItem(
      child: Text(
        "BA",
        style: TextStyle(fontSize: 25),
      ),
      value: 3.5,
    ));
    letters.add(DropdownMenuItem(
      child: Text(
        "BB",
        style: TextStyle(fontSize: 25),
      ),
      value: 3.0,
    ));
    letters.add(DropdownMenuItem(
      child: Text(
        "CB",
        style: TextStyle(fontSize: 25),
      ),
      value: 2.5,
    ));
    letters.add(DropdownMenuItem(
      child: Text(
        "CC",
        style: TextStyle(fontSize: 25),
      ),
      value: 2.0,
    ));
    letters.add(DropdownMenuItem(
      child: Text(
        "DC",
        style: TextStyle(fontSize: 25),
      ),
      value: 1.5,
    ));
    letters.add(DropdownMenuItem(
      child: Text(
        "DD",
        style: TextStyle(fontSize: 25),
      ),
      value: 1.0,
    ));
    letters.add(DropdownMenuItem(
      child: Text(
        "FF",
        style: TextStyle(fontSize: 25),
      ),
      value: 0.0,
    ));

    return letters;
  }

  Widget _createListItems(BuildContext context, int index) {
    sayac++;
    return Dismissible(
      key: Key(sayac.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          allLectures.removeAt(index);
          calculateTheAverage();
        });
      },
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.blue, width: 1)),
        margin: EdgeInsets.all(4),
        child: ListTile(
          leading: Icon(
            Icons.done,
            size: 30,
            color: allLectures[index].color,
          ),
          trailing: Icon(
            Icons.arrow_right,
            color: allLectures[index].color,
          ),
          title: Text(allLectures[index].name),
          subtitle: Text("Credit: " +
              allLectures[index].credit.toString() +
              "  Letters Value: " +
              allLectures[index].letterValue.toString()),
        ),
      ),
    );
  }

  void calculateTheAverage() {
    double totalPoint = 0;
    double totalCredit = 0;
    for (var lecture in allLectures) {
      var credit = lecture.credit;
      var letterValue = lecture.letterValue;

      totalPoint += (letterValue * credit);
      totalCredit += credit;
    }

    average = totalPoint / totalCredit;
  }

  Color createRandomlyColor() {
    Random random = new Random();
    return Color.fromARGB(100 + random.nextInt(100), 100 + random.nextInt(100),
        100 + random.nextInt(100), 100 + random.nextInt(100));
  }
}

class Lecture {
  String name;
  double letterValue;
  int credit;
  Color color = Colors.blue;
  Lecture(this.name, this.letterValue, this.credit, this.color);
}
