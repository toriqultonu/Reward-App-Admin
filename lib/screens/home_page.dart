
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
            child: Column(
              children: [

                Text('UserID : $scannedResult'),
                SizedBox(height: 30,),
              Row(
                children: [
                  Text('Add Points: $points'),
                  // Spacer(),
                  // TextField()
                ],),
                SizedBox(height: 30,),
                Row(
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
                        updateUserDetails("points", 50, scannedResult);
                      },
                      child: Text('Submit'),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
