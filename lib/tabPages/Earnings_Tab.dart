import 'package:flutter/material.dart';

class EarningsTab extends StatefulWidget {
  const EarningsTab({super.key});

  @override
  State<EarningsTab> createState() => _EarningsTabState();
}

class _EarningsTabState extends State<EarningsTab> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("EarningsTab"),),
    );
  }
}