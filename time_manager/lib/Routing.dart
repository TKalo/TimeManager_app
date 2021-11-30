import 'dart:async';

import 'package:flutter/material.dart';
import 'AddActivity.dart';
import 'Home.dart';

enum routes { home, addActivity }

var views = <routes, Widget>{
  routes.home: const Home(),
  routes.addActivity: AddActivity()
};

StreamController<Widget> currentViewStream = StreamController()..add(views[routes.home] ?? Container());

Stream<Widget> getCurrentViewStream() => currentViewStream.stream.asBroadcastStream();

setCurrentView(routes route) => currentViewStream.sink.add(views[route] ?? Container());
