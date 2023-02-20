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
  bool showPopUpExitButton = false;
  bool appNamePopUp = false;
  bool resourceNamePopUp = false;
  List<String> appNames = [];
  List<String> resourceNames = [];
  List<Resource>? ListOfResources = [];
  Color backgroundColour = Color(0xff3a21d9);
  final textController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  void showAppsList(){
    setState(() {
      appNamePopUp = true;
      resourceNamePopUp = false;
      showPopUpExitButton = true;
    });
  }

  void closePopUps() {
    setState(() {
      resourceNamePopUp = false;
      appNamePopUp = false;
      showPopUpExitButton = false;
    });
  }

  void showResourceList(){
    setState(() {
      resourceNamePopUp = true;
      showPopUpExitButton = true;
      appNamePopUp = false;
    });
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

  void getResourcesAndApps() async {
    resourceNames = (await back_end().getResourceNames()).toList().cast<String>();

  }

  List<Widget> _createResourceButtons(String appsOrResources) { // add functional
    getResourcesAndApps();
    List<Widget> buttons = [];
    if (appsOrResources == 'resources') {
      resourceNames.sort();
      for (String name in resourceNames) {
        if (name != null) {
          buttons.add(
            MaterialButton(
              color: Colors.indigo,
              minWidth: 200,
              child: Text(name,
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    color: Colors.white
                ),
              ),
              onPressed: () {
                searchFunction("resource:$name");
              },
            ),
          );
        } else {
          print('name not found');
        }
      }
      return buttons;
    }
      return buttons;
  }

  List<Widget> _createAppButtons(){
    List<String> listOfNames = back_end().applicationList;
    listOfNames.sort();
    List<Widget> buttons = [];
    listOfNames.sort();
    for (String name in listOfNames) {
      if (name != null) {
        buttons.add(
          MaterialButton(
            color: Colors.indigo,
            minWidth: 200,
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              searchFunction("application:$name");
            },
          ),
        );
      } else {
        print('name not found');
      }
    }
    return buttons;
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
                      child: MaterialButton( // display app name buttons
                        onPressed:(){ showAppsList();},
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
                        onPressed:(){ showResourceList();},
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
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: TextField( // search bar textField
                                  controller: textController,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter application or resource in the format(application: application, or resource: resource)',
                                  ),
                                ),
                              ),
                            ),
                            MaterialButton( // search button attached to the side of the textField
                              color: Colors.indigo,
                              height: 60,
                              child: const Text(
                                'Search',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: (){ searchFunction(textController.text);},
                            ),
                          ],
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
                    Align( // apps and resource list closing button
                      alignment: Alignment(-0.45,-0.55),
                      child: Visibility(
                        visible: showPopUpExitButton,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: (){closePopUps();} ,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(-0.35,0.7),
                      child: Visibility( // visibility widget used to hide and show resource list
                        visible: resourceNamePopUp,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height*0.7,
                          width: MediaQuery.of(context).size.width*0.2,
                          child: SingleChildScrollView(
                            child: Column(
                                children: _createAppButtons()
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(-0.35,0.7),
                      child: Visibility( // visibility widget used to hide and show apps list
                        visible: appNamePopUp,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height*0.7,
                          width: MediaQuery.of(context).size.width*0.2,
                          child: SingleChildScrollView(
                            child: Column(
                                children: _createResourceButtons('resources')
                            ),
                          ),
                        ),
                      ),
                    ),
                  ])
          ),
        )
    );
  }
}
