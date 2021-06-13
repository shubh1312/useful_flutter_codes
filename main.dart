import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    title: "Goodly",
    // theme:,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return TryThings();
  }
}

class TryThings extends StatefulWidget {
  const TryThings({Key key}) : super(key: key);

  @override
  _TryThingsState createState() => _TryThingsState();
}

class _TryThingsState extends State<TryThings> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: body(),
    );
  }
}

Widget body() {
  var stream = FirebaseFirestore.instance.collection('English').snapshots();
  return StreamBuilder(
    stream: stream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.none:
        case ConnectionState.waiting:
          return center('please wait...');
        default:
          if (snapshot.hasData) {
            if (snapshot.data.docs.length == 0) {
              return center("No records found");
            } else {
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    String id = snapshot.data.docs[index].id;
                    return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('English')
                          .doc(id)
                          .collection('Suvichar')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snap) {
                        switch (snap.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return center('please wait...');
                          default:
                            if (snap.hasData) {
                              if (snap.data.docs.length == 0) {
                                return center("No records found");
                              } else {
                                return ListView.builder(
                                  shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics: ScrollPhysics(),
                                    itemCount: snap.data.docs.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      String id = snap.data.docs[index]['quoteText'];
                                      return center('$id');
                                    });
                              }
                            } else {
                              return center("Getting Error");
                            }
                        }
                      },
                    );
                  });
            }
          } else {
            return center("Getting Error");
          }
      }
    },
  );
}

Widget center(String text) {
// Size size = MediaQuery.of(context).size;
  return Container(

    alignment: Alignment.center,
    child: Text(
      '$text',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w400,
        // color:
      ),
    ),
  );
}
// Widget center(String text){
// Size size = MediaQuery.of(context).size;
// return Container(
// height: size.height,
//   width: size.width,
//   alignment: Alignment.center,
//   child: Text(
//     '$text',
//     style: TextStyle(
//       fontSize: size.height*0.025,
//       fontWeight: FontWeight.w400,
//       // color:
//     ),
//   ),
// );
// }
