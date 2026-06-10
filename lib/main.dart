import 'package:flutter/material.dart';
import 'screens/liste_screen.dart';
import 'screens/membre_detail_screen.dart';
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
          case '/membre':
            final nom = settings.arguments as String?;
            if (nom == null)
              return MaterialPageRoute(builder: (context) => ListeScreen());
            return MaterialPageRoute(
              builder: (context) => MembreDetailScreen(membreNom: nom),
            );
          case '/form':
            final args = settings.arguments;
            String? id;
            String? prefillMembre;
            if (args is Map) {
              id = args['id'];
              prefillMembre = args['prefillMembre'];
            } else if (args is String?) {
              id = args;
            }
            return MaterialPageRoute(
              builder: (context) => FormulaireScreen(
                cotisationId: id,
                prefillMembre: prefillMembre,
              ),
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
