import 'package:flutter/material.dart';
import 'back_end.dart';
import 'dart:core';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';


//Reference to List kept here
//searchBox not working!!!
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp (
    const MaterialApp(
      home: MyFlutterApp(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class MyFlutterApp extends StatefulWidget {
  const MyFlutterApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyFlutterState();
  }
}
class MyFlutterState extends State<MyFlutterApp> with TickerProviderStateMixin {

  //WRITE VARIABLES AND EVENT HANDLERS HERE
  String applicationResourcesText = "";
  List<Resource>? ListOfResources = [];
  Color backgroundColour = Color(0xff3a21d9);
  final textController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  void sortByConsumedQuantity(){
    back_end().sortListByConsumedQuantity(ListOfResources!);
    var box = '';
    for (int i = 0; i < ListOfResources!.length;i++){
      box = (box! + ListOfResources![i].toString())!;
    }
    setState((){
      applicationResourcesText = box!;
    });
  }

  void sortByDate(){
    back_end().sortListByDate(ListOfResources!);
    var box = '';
    for (int i = 0; i < ListOfResources!.length;i++){
      box = (box! + ListOfResources![i].toString())!;
    }
    setState((){
      applicationResourcesText = box!;
    });
  }

  void sortByCost(){
    back_end().sortListByCost(ListOfResources!);
    var box = '';
    for (int i = 0; i < ListOfResources!.length;i++){
      box = (box! + ListOfResources![i].toString())!;
    }
    setState((){
      applicationResourcesText = box!;
    });
  }

  void displayAppsAlphabetically(){
    List<String> listOfNames = back_end().applicationList;
    listOfNames.sort();
    String box = '';
    for(String name in listOfNames){
      box = '$box$name\n';
    }
    setState((){
      applicationResourcesText = box!;
    });
  }

  void displayResourcesAlphabetically() async{
    List<dynamic> listOfNames = await back_end().getResourceNames();
    listOfNames.sort();
    String box = '';
    for(String name in listOfNames){
      box = '$box$name\n';
    }
    setState((){
      applicationResourcesText = box!;
    });
  }

  void searchFunction(String searchText) async{
    String? box = "";
    if (searchText.toLowerCase().contains('application')){
      searchText=searchText.split(':')[1].trim();
      ListOfResources = await back_end().applicationsSearch(searchText);
    }
    if (searchText.toLowerCase().contains('resource')){
      searchText=searchText.split(':')[1].trim();
      ListOfResources = await back_end().resourceSearch(searchText);
    }
    if (ListOfResources != null){
      for (int i = 0; i < ListOfResources!.length;i++){
        print(ListOfResources![i].toString());
        box = (box! + ListOfResources![i].toString())!;
      }
      setState(() {
        applicationResourcesText = box!;
      });
    }
    else{
      setState(() {
        applicationResourcesText = 'app or resource name not found';
      });
    }

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColour,
        body: Align(
          alignment: Alignment.center,
          child: SizedBox( // main body of the web app
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Stack( // main container for all the widgets
                  alignment: Alignment.topLeft,
                  children: [
                    Align(
                      alignment: const Alignment(-0.8, 0.35),
                      child: MaterialButton( // order by date
                        onPressed:(){ sortByDate();},
                        color: const Color(0xfffffdfd),
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        textColor: const Color(0xff3a21d9),
                        height: 60,
                        minWidth: 200,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: const Text(
                          "sort by date",
                          overflow: TextOverflow.fade,
                          maxLines: 2,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(-0.8, -0.45),
                      child: MaterialButton( // display app names button
                        onPressed:(){ displayAppsAlphabetically();},
                        color: const Color(0xfffffdfd),
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        textColor: const Color(0xff3a21d9),
                        height: 60,
                        minWidth: 200,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: const Text(
                          "view App names",
                          overflow: TextOverflow.fade,
                          maxLines: 2,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(-0.8, -0.25),
                      child: MaterialButton( // display resource names button
                        onPressed:(){ displayResourcesAlphabetically();},
                        color: const Color(0xfffffdfd),
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        textColor: const Color(0xff3a21d9),
                        height: 60,
                        minWidth: 200,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: const Text(
                          "view resource names",
                          overflow: TextOverflow.fade,
                          maxLines: 2,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(-0.8, 0.15),
                      child: MaterialButton( // order by consumed quantity
                        onPressed:(){ sortByConsumedQuantity();},
                        color: const Color(0xfffffdfd),
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        textColor: const Color(0xff3a21d9),
                        height: 60,
                        minWidth: 200,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: const Text(
                          "sort by consumed quantity",
                          overflow: TextOverflow.fade,
                          maxLines: 2,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0, -0.65),
                      child: MaterialButton( // Search Button
                        onPressed:(){ searchFunction(textController.text);},
                        color: const Color(0xfffffdfd),
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        textColor: const Color(0xff3a21d9),
                        height: 60,
                        minWidth: 100,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: const Text(
                          "Search",
                          overflow: TextOverflow.fade,
                          maxLines: 2,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(-0.8, -0.05),
                      child: MaterialButton( // Sort by cost button
                        onPressed:(){ sortByCost();},
                        color: const Color(0xfffffdfd),
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        textColor: const Color(0xff3a21d9),
                        height: 60,
                        minWidth: 200,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: const Text(
                          "sort by cost",
                          overflow: TextOverflow.fade,
                          maxLines: 2,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment(0, -0.9),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width*0.8,
                          child: TextField(
                            controller: textController,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              hintText: 'Enter application or resource in the format(application: application)',
                            ),
                          ),
                        )
                    ),
                    Align(
                      alignment: const Alignment(0.5, -0.5),
                      child: SizedBox( // Display text
                          child: Align(alignment: const Alignment(0.8, 0.7),
                              child: Container(
                                color: Colors.white,
                                height: MediaQuery.of(context).size.height*0.7,
                                width: MediaQuery.of(context).size.width*0.5,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(applicationResourcesText)
                                  ),
                              ),
                              )
                          )
                      )
                    ),
                  ])
          ),
        )
    );
  }
}
