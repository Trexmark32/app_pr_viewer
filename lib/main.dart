import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:github_pr_viewer/features/auth/presentation/login_page.dart';
import 'package:github_pr_viewer/features/pr/presentation/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  runApp(MyApp(isLoggedIn: token != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Github PR',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark().copyWith(
        extensions: const [SkeletonizerConfigData.dark()],
      ),
      home: isLoggedIn
          ? const HomePage(title: 'Github PR Viewer')
          : const LoginPage(),
    );
  }
}
