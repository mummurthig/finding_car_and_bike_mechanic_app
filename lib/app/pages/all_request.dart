import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:userend/app/pages/home/customer_home_page.dart';
import 'package:userend/app/pages/mechaniclist/mechaniclist.dart';
import 'package:userend/app/pages/profile/profile_page.dart';
import 'package:userend/app/pages/service_request_detail.dart';
import 'package:userend/app/utils/auth_utils.dart';
import 'package:userend/app/utils/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class AllRequestPage extends StatefulWidget {


  @override
  _AllRequestPageState createState() => _AllRequestPageState();
}

class Data {
  final String request_id;
  final String customer_id;
  final String customer_name;
  final String phone_number;
  final String location;
  final String landmark;
  final String mechnaic_id;
  final String date_time;
  final String status;
  final String pincode;


  Data({this.request_id, this.mechnaic_id, this.date_time, this.status, this.pincode, this.customer_id, this.customer_name, this.phone_number, this.location, this.landmark});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      request_id: json['request_id'],
      customer_id: json['customer_id'],
      customer_name: json['customer_name'],
      phone_number: json['phone_number'],
      location: json['location'],
      landmark: json['landmark'],
      mechnaic_id: json['mechnaic_id'],
      date_time: json['date_time'],
      status: json['status'],
      pincode: json['pincode'],
    );
  }
}
class _AllRequestPageState extends State<AllRequestPage> {

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  SharedPreferences _sharedPreferences;
  var _authToken, _id, _name, _homeResponse;
  Future<List<Data>> futureData;
  @override
  void initState() {
    super.initState();
    _fetchSessionAndNavigate();
    futureData = fetchData(_id);
  }

  _fetchSessionAndNavigate() async {
    _sharedPreferences = await _prefs;
    String authToken = AuthUtils.getToken(_sharedPreferences);
    var id = _sharedPreferences.getString(AuthUtils.userIdKey);
    var name = _sharedPreferences.getString(AuthUtils.nameKey);

    print(authToken);

    _fetchHome(authToken);

    setState(() {
      _authToken = authToken;
      _id = id;
      _name = name;

    });


  }

  _fetchHome(String authToken) async {
    var responseJson = await NetworkUtils.fetch(authToken);

    if(responseJson == null) {

      NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');

    } else if(responseJson == 'NetworkError') {

      NetworkUtils.showSnackBar(_scaffoldKey, null);

    } else if(responseJson['errors'] != null) {



    }

    setState(() {
      _homeResponse = responseJson.toString();
    });
  }

  Future<List<Data>> fetchData(String userid) async {
    var userid;
    final response = await http.get(
        'https://helloworldhosur.000webhostapp.com/service_app/v2/get_my_service_request.php?userid=1');

    print(userid);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => new Data.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Requests"),
      ),
      body: Center(
        child: FutureBuilder<List<Data>>(
          future: futureData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Data> data = snapshot.data;
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: <Widget>[
                        InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ViewServiceDetail(
                                customer_name: data[index].customer_name,
                                status: data[index].status,
                                phone_number: data[index].phone_number,
                                landmark: data[index].landmark,
                                location: data[index].location,
                                date_time: data[index].date_time,
                                pincode: data[index].pincode,
                                mechnaic_id: data[index].mechnaic_id,
                              )),
                            );
                          },
                          child: ListTile(
                            title: Row(
                              children: <Widget>[
                                Expanded(child: Text(data[index].customer_name, style: TextStyle(fontWeight: FontWeight.bold),)),
                                SizedBox(
                                  width: 16.0,
                                ),

                                Text(data[index].location),

                              ],
                            ),
                            subtitle: Text("PIN CODE : ${data[index].pincode}", style: TextStyle(fontWeight: FontWeight.bold),),

                          ),
                        ),
                      ],
                    );
                  });
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
