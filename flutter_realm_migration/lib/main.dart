import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';
import 'models/user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Realm Migration',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Realm Migration'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<User> users = [];
  String realmPath = '';
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkRealmPath();
  }

  Future<void> _checkRealmPath() async {
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final path = '${documentsDir.path}/default.realm';

      setState(() {
        realmPath = path;
      });

      print("📂 Flutter Realm file path: $path");
      await _loadRealm();
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
      print("❌ Error: $e");
    }
  }

  Future<void> _loadRealm() async {
    try {
      if (!File(realmPath).existsSync()) {
        setState(() {
          errorMessage = "Realm file not found at: $realmPath";
          isLoading = false;
        });
        print("❌ Realm file not found at: $realmPath");
        return;
      }

      final config = Configuration.local([User.schema], path: realmPath);
      final realm = Realm(config);

      final loadedUsers = realm.all<User>();

      setState(() {
        users = loadedUsers.toList();
        isLoading = false;
      });

      for (var user in users) {
        print("✅ User: ${user.name}, Age: ${user.age}");
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
      print("❌ Error loading Realm: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Realm Path: $realmPath',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Error: $errorMessage',
                        style: const TextStyle(color: Colors.red)),
                  ),
                Expanded(
                  child: users.isEmpty
                      ? const Center(
                          child: Text('No users found in Realm database'),
                        )
                      : ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return ListTile(
                              title: Text(user.name),
                              subtitle: Text('Age: ${user.age}'),
                              leading: CircleAvatar(
                                child: Text(user.name[0]),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
