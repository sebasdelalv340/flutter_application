import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'My App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  String currentText = "";

  void updateText(String newText) {
    currentText = newText;
    notifyListeners();
  }

  var tareas = <String>[];

  void toggleFavorite() {
    if (tareas.contains(currentText) || currentText.isEmpty) {
      tareas.remove(currentText);
    } else {
      tareas.add(currentText);
    }
    notifyListeners();
  }

  void removeTarea(String text) {
    tareas.remove(text);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = TareasPage();
        break;
      default:
        throw UnimplementedError('no widget para $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text(
              "My Tasks", // 📝 Título agregado en AppBar
                style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                ),
              ),
            ),
          ),
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.task),
                      label: Text('Tareas'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class GeneratorPage extends StatelessWidget {
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Center(
      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), // Bordes redondeados
              image: DecorationImage(
                image: AssetImage('assets/image_tareas.webp'),
                fit: BoxFit.cover, // Ajusta la imagen
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: "Ingresa tu tarea",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                appState.updateText(value);
              },
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                  textController.clear();
                },
                icon: Icon(Icons.save),
                label: Text('Guardar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class TareasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.tareas.isEmpty) {
      return Center(
        child: Text('No hay tareas.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('Tienes ${appState.tareas.length} tareas:'),
        ),
        for (var text in appState.tareas)
          ListTile(
            leading: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                appState.removeTarea(text);
              },
            ),
            title: Text(text),
          ),
      ],
    );
  }
}