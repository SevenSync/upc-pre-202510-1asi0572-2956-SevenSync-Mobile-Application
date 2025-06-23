import 'package:flutter/material.dart';
import 'injections.dart'; 
import 'app_routes.dart';        

void main() {

  setupLocator(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Macetech',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true, 
      ),
  
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

// El widget MyHomePage y _MyHomePageState han sido eliminados por no ser necesarios.