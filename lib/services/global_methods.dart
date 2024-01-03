import 'dart:js';

import 'package:flutter/material.dart';



//ahile etikai matra ho
class GlobalMethods{
  static void showErrorDialog({required String error, required BuildContext ctx}) {
    showDialog(
        context: ctx,
        builder: (context){
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.logout,
                      size: 35,
                    ),
                ),
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Shhh! There's an Error"
                    ),
                )
              ],
            ),
              content: Text(
                '$error',
                ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.red
                    ),
                  )
              )
            ],
              ),
          )
        }
    )
  }

}
