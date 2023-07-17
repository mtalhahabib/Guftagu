import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:guftagu/pages/Authentication/auth_page.dart';
import 'package:guftagu/pages/chatting/chat.dart';
import 'package:guftagu/pages/home.dart';
import 'package:guftagu/pages/profile.dart';
import 'package:guftagu/pages/splash.dart';
import 'constants/theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  Rang color = Rang();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Guftagu',
      theme: ThemeData(

      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/splash': (context) => SplashScreen(),
        '/register' : (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),


      },
    );
  }
}

class ProfileScreen {
}
