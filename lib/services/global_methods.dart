import 'package:flutter/material.dart';

class GlobalMethods{
  static void showErrorDialog({required String error, required BuildContext ctx}) {
    showDialog(
        context: ctx,
        builder: (context){
          return AlertDialog(
            title: const Row(
              children: [
                Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.logout,
                      size: 22,
                    ),
                ),
                Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      "Shhh! There's an Error",
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                )
              ],
            ),
              content: Text(
                error,
                ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.red
                    ),
                  )
              )
            ],
          );
        }
    );
  }

}
