import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Tags{
  String? appName;
  String? environment;
  String? businessUnit;

  Tags(this.appName, this.environment, this.businessUnit);

  @override
  String toString() {
    return 'Tags{ appName: $appName \nenvironment: $environment \nbusinessUnit: $businessUnit}';
  }
}
class Resource{
  String consumedQuantity;
  String cost;
  String date;
  String instanceId;
  String meterCategory;
  String resourceGroup;
  String resourceLocation;
  Tags tags;
  String unitOfMeasure;
  String location;
  String serviceName;

  Resource(
      this.date,
      this.instanceId,
      this.meterCategory,
      this.resourceGroup,
      this.resourceLocation,
      this.tags,
      this.unitOfMeasure,
      this.location,
      this.serviceName,
      this.consumedQuantity,
      this.cost,
      );

  @override
  String toString() {
    return 'Resource{ConsumedQuantity: $consumedQuantity \nCost: $cost \nDate: $date \nInstanceId: $instanceId \nMeterCategory: $meterCategory \nResourceGroup: $resourceGroup \nResourceLocation: $resourceLocation \n${tags.toString()} \nunitOfMeasurment: $unitOfMeasure \nLocation: $location \nServiceName: $serviceName}\n\n';
  }
}

class back_end{
  List<String> applicationList = ["Macao",
    "Delaware-deposit-Plastic",
    "index-Consultant-blue",
    "Integrated-SDD",
    "Accountability-Clothing",
    "Philippines-THX",
    "info-mediaries",
    "AI-Administrator-capability",
    "firewall-Towels-compressing",
    "Officer",
    "Triple-buffered-Brand",
    "program-compelling",
    "Corporate-Electronics",
    "Multi-tiered",
    "global-Rustic",
    "Cambridgeshire-next-Springs",
    "Bike-Hawaii-Naira",
    "Health",
    "seamless-Arkansas-payment",
    "Markets-payment-Shoes",
    "Solutions",
    "Industrial",
    "Locks-integrated",
    "EXE",
    "redundant-copy-action-items",
    "Regional-Table",
    "Licensed-Account-paradigms",
    "auxiliary-Granite",
    "calculating",
    "zero",
    "markets-reboot-Avon",
    "Account-Pizza-cross-media",
    "Computers",
    "Granite",
    "Computers-Fresh",
    "User-centric",
    "Palau-redundant-solution-oriented",
    "Dakota-Future-proofed-SCSI",
    "Maine-Avon",
    "Loti",
    "Wooden-Health",
    "Table-Flats-Electronics",
    "Territory-e-markets",
    "forecast-Games",
    "Gloves",
    "red-Facilitator",
    "1080p-Lock",
    "mobile-transmit",
    "interface-deliver"];
  String request = 'https://engineering-task.elancoapps.com/api/';


  Future<List<Resource>> applicationsByAppName (appName) async{ //takes application name, returns list of resources part of that application
    List<Resource> resources=[];
    request = 'https://engineering-task.elancoapps.com/api/applications/'+appName;
    var response = await http.get(Uri.parse(request)); //initial response
    var maps = jsonDecode(response.body);
     for (var map in maps){
      Resource r = Resource(
        checkIfString(map["Date"]),
        checkIfString(map["InstanceId"]),
        map["MeterCategory"],
        map["ResourceGroup"],
        map["ResourceLocation"],
        Tags(map["Tags"]["app-name"], map["Tags"]["environment"], map["Tags"]["business-unit"]),
        map["UnitOfMeasure"],
        map["Location"],
        map["ServiceName"],
        checkIfString(map["ConsumedQuantity"]),
        checkIfString(map["Cost"]),
      );
      resources.add(r);
    }

    return resources;
  }

  Future<List<Resource>> resourceByName (name) async{ //takes application name, returns list of resources part of that application
    List<Resource> resources=[];

    print(name);
    request = 'https://engineering-task.elancoapps.com/api/resources/'+name;
    var response = await http.get(Uri.parse(request)); //initial response
    var maps = jsonDecode(response.body);
    for (var map in maps){
      Resource r = Resource(
        checkIfString(map["Date"]),
        checkIfString(map["InstanceId"]),
        map["MeterCategory"],
        map["ResourceGroup"],
        map["ResourceLocation"],
        Tags(map["Tags"]["app-name"], map["Tags"]["environment"], map["Tags"]["business-unit"]),
        map["UnitOfMeasure"],
        map["Location"],
        map["ServiceName"],
        checkIfString(map["ConsumedQuantity"]),
        checkIfString(map["Cost"]),
      );
      resources.add(r);
    }

    return resources;
  }

  String checkIfString(possibleString){
    if (possibleString is int ){
      return "$possibleString";
    } else if (possibleString is String) {
      return possibleString;
    } else {
      return "";
    }
  }

  Future<List<Resource>?>? applicationsSearch (appName) async{ //takes application name, returns list of resources of the application of that application
    if (applicationList.contains(appName)){
      return applicationsByAppName(appName);
    }
   return null;
  }

  Future<List<Resource>?>? resourceSearch(resourceName) async{
    List<dynamic> allResources = await getResourceNames();
    if (allResources.contains(resourceName)){
      return resourceByName(resourceName);
    }else{return null;}
  }

  Future<List> getResourceNames()async{
    var allResourcesRequest = await http.get(Uri.parse("https://engineering-task.elancoapps.com/api/resources"));
    List<dynamic> allResources = jsonDecode(allResourcesRequest.body);
    return allResources;
  }

  void sortListByCost(List<Resource> resources) {
    resources.sort((a, b) => double.parse(a.cost).compareTo(double.parse(b.cost)));
  }

  void sortListByConsumedQuantity(List<Resource> resources){
    resources.sort((a, b) => double.parse(a.consumedQuantity).compareTo(double.parse(b.consumedQuantity)));
  }

  void sortListByDate(List<Resource> resources) {
    resources.sort((a, b) => a.date.compareTo(b.date));
  }
}
