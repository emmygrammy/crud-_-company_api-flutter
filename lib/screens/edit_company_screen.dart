import 'package:flutter/material.dart';

class EditCompanyScreen extends StatefulWidget {
  const EditCompanyScreen({super.key});

  @override
  State<EditCompanyScreen> createState() => _EditCompanyScreenState();
}

class _EditCompanyScreenState extends State<EditCompanyScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Company'),
        centerTitle: true,
      ),
    );
  }
}