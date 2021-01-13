import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String _message;

  ErrorView(this._message);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Error Ocurred"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(_message, style: TextStyle(fontSize: 34),)
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 50,
            child: MaterialButton(
              onPressed: () => Navigator.pop(context),
              child: Text("go back", style: TextStyle(fontSize: 24)),
              color: Colors.blueAccent,
            ),
          )
        ],
      )
    );
  }
}
