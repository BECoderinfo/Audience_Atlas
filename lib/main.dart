import 'package:firebase_core/firebase_core.dart';
import 'dart:developer';
import 'package:audience_atlas/utils/import.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  await Firebase.initializeApp(
    name: 'com.audience.atlas.audience_atlas',
    options: const FirebaseOptions(
      apiKey: "AIzaSyBQ1lTPr9I7ZOCDOx7GA_AxWb5L_A3XPjM",
      appId: "1:1075654579926:android:5ca837359ad6fbc4701b77",
      messagingSenderId: "1075654579926",
      projectId: "audience-atlas-e7c07",
    ),
  );
  log("${(AppVariables.box.read(StorageKeys.isBiometric) ?? false)}");
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Audience Atlas',
      theme: appTheme,
      initialRoute: AppPages.initialRoute,
      getPages: AppPages.routes,
    );
  }
}
