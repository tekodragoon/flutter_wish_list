import 'package:flutter/material.dart';

class EmptyData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No data found.',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 30.0, color: Colors.red, fontStyle: FontStyle.italic),
      ),
    );
  }
}
