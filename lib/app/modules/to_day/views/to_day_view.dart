import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/to_day_controller.dart';

class ToDayView extends GetView<ToDayController> {
  const ToDayView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDayView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ToDayView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
