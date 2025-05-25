import 'package:capy_car/ui/components/appBar.dart';
import 'package:capy_car/ui/components/appBottomNavigation.dart';
import 'package:capy_car/ui/components/appDrawer.dart';
import 'package:flutter/material.dart';

class CaronasUsuarioPage extends StatefulWidget {
  const CaronasUsuarioPage({super.key});

  @override
  State<CaronasUsuarioPage> createState() => _CaronasUsuarioPageState();
}

class _CaronasUsuarioPageState extends State<CaronasUsuarioPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(greeting: 'Suas Caronas Ativas', isPop: false),
      drawer: AppDrawer(),
      bottomNavigationBar: AppBottomNavigation(index: 2),
      body: Container(width: double.infinity),
    );
  }
}
