import 'package:vagonetas_app/app.dart';
import 'core/locator.dart';
import 'package:flutter/material.dart';
void main() async {
  await LocatorInjector.setupLocator();
  runApp(App());
}