import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/screens/page_not_found.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'model/diary.dart';
import 'screens/get_started_page.dart';
import 'screens/login_page.dart';
import 'screens/main_page.dart';

//https://firebase.google.com/codelabs/get-started-firebase-emulators-and-flutter#0
//https://firebase.google.com/docs/flutter/setup?platform=web
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      await FirebaseStorage.instance.useStorageEmulator('localhost', 9091);
    } catch (e) {
      print(e);
    }
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final userDiaryDataStream =
      FirebaseFirestore.instance.collection('diaries').snapshots()
          // ignore: top_level_function_literal_block
          .map((diaries) {
    return diaries.docs.map((diary) {
      return Diary.fromDocument(diary);
    }).toList();
  });

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider(
            create: (context) => FirebaseAuth.instance.idTokenChanges(),
            initialData: null),
        StreamProvider<List<Diary>>(
            create: (context) => userDiaryDataStream, initialData: List.empty())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Diary Book',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primarySwatch: Colors.green,
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) {
              return RouteController(settingsName: settings.name!);
            },
          );
        },
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => const PageNotFound(),
        ),
        //home: TesterApp(),
      ),
    );
  }
}

class TesterApp extends StatelessWidget {
  const TesterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference booksCollection =
        FirebaseFirestore.instance.collection('diaries');
    return Scaffold(
        appBar: AppBar(
          title: const Text('Main Page'),
        ),
        body: Center(
          child: StreamBuilder<QuerySnapshot>(
            stream: booksCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final bookListStream = snapshot.data!.docs.map((book) {
                return Diary.fromDocument(book);
              }).toList();
              for (var item in bookListStream) {
                print(item.entry!);
              }
              return ListView.builder(
                itemCount: bookListStream.length,
                itemBuilder: (context, index) {
                  return Text(bookListStream[index].entry!);
                },
              );
            },
          ),
        ));
  }
}

class RouteController extends StatelessWidget {
  final String settingsName;

  const RouteController({Key? key, required this.settingsName})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final userSignedIn = Provider.of<User?>(context) != null;
    print(settingsName);

    final signedInGotoMain = userSignedIn && settingsName == '/main';
    final notSignedInGotoMain = !userSignedIn && settingsName == '/main';

    if (settingsName == '/') {
      return const GettingStartedPage();
    } else if (settingsName == '/main' || notSignedInGotoMain) {
      return const LoginPage();
    } else if (settingsName == '/login' || notSignedInGotoMain) {
      return const LoginPage();
    } else if (signedInGotoMain) {
      return const MainPage();
    } else {
      return const PageNotFound();
    }
  }
}
