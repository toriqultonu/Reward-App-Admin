
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:reward_app_admin/styles.dart';
import 'package:reward_app_admin/widgets/crud_user.dart';
import 'package:reward_app_admin/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  Map<String, dynamic> userData = new Map();
  var points = 0;
  var username = '';
  var useremail = '';

  String scannedResult = '';
  startScan() async{
    var result;
    try{
      result = await FlutterBarcodeScanner.scanBarcode('#FFFFFF', 'Cancel', true, ScanMode.QR);
      DocumentSnapshot snapshot = await fetchUserData(result);
      userData = snapshot.data() as Map<String, dynamic>;

    }on PlatformException catch(e){
      result = 'Failed to get platform version';
      showToast(message: 'Error occured');
    }catch(e){
      showToast(message: 'Error occured ${e.toString()}');
    }
    if(!mounted) return;

    setState((){
      scannedResult = result;
      points = userData["points"];
      username = userData["name"];
      useremail = userData["email"];
    });

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            automaticallyImplyLeading: false,
            title: Center(child: Text("Dragon Court", style: TextStyle(color: Colors.white),)),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30,),
                  Text('User ID: ', style: TextStyle(fontSize: 20),),
                  SizedBox(height: 10,),
                  Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.8),
                            spreadRadius: 0.1,
                            blurRadius: 2,
                            offset: Offset(3, 3),
                          )
                        ]),
                    child: Text('$scannedResult', style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Text('User Email: ', style: TextStyle(fontSize: 18),),
                      Spacer(),
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.6,

                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.0),),
                        child: Text(useremail, style: TextStyle(fontSize: 18,),),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('User Name: ', style: TextStyle(fontSize: 18),),
                      Spacer(),
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.6,

                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.0),),
                        child: Text(username, style: TextStyle(fontSize: 18,),),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Points: ', style: TextStyle(fontSize: 18),),
                      Spacer(),
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.6,

                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.0),),
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: (){
                                setState(() {
                                  points--;
                                });
                              },
                              child:Text('-' , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                            ),
                            Spacer(),
                            Text('$points', style: TextStyle(fontSize: 25,),),
                            Spacer(),
                            ElevatedButton(
                              onPressed: (){
                                setState(() {
                                  points++;
                                });
                              },
                              child: Text('+' , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),

                  SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: (){
                            startScan();
                          },
                          child: Text('Start Scan'),
                        ),
                        Spacer(),
                        ElevatedButton(
                          onPressed: (){
                            /// Todo submit operation.
                            updateUserDetails("points", points, scannedResult);
                          },
                          child: Text('Submit'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
