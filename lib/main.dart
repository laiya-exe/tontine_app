import 'package:flutter/material.dart';
import 'screens/liste_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/form_screen.dart';
import 'screens/about_screen.dart';
import 'services/tontine_service.dart';

final TontineService tontineService = TontineService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await tontineService.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion Tontine',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => ListeScreen());
          case '/detail':
            final id = settings.arguments as String?;
            if (id == null) {
              return MaterialPageRoute(builder: (context) => ListeScreen());
            }
            return MaterialPageRoute(
              builder: (context) => DetailScreen(cotisationId: id),
            );
          case '/form':
            final id = settings.arguments as String?;
            return MaterialPageRoute(
              builder: (context) => FormulaireScreen(cotisationId: id),
            );
          case '/about':
            return MaterialPageRoute(builder: (context) => AboutScreen());
          default:
            return MaterialPageRoute(builder: (context) => ListeScreen());
        }
      },
    );
  }
}
