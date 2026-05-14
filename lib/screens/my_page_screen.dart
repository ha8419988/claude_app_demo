import 'package:flutter/material.dart';
import '../widgets/my_page_app_bar.dart';
import '../widgets/my_page_body.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      appBar: MyPageAppBar(),
      body: MyPageBody(),
    );
  }
}
