import 'package:flutter/material.dart';

SnackBar showsnackBar(String content)
{
  return SnackBar(
    backgroundColor: Colors.yellow,
    duration: Duration(seconds: 1),
      content: Text(content)
  );

}