import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      home: const MyHomePage(title: 'Flutter Puzzle Mobile'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int rounds = 0; // Numero de Jogadas
  int level = 4; // Nível do Puzzle

  void incrementRounds() {
    setState(() {
      rounds++;
    });
  }

  @override
  Widget build(BuildContext context) {
    int length = (level * level);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.title, 
          style: 
            TextStyle(
              color: Theme.of(context).colorScheme.onPrimary),),
      ),
      body: Center(
        child: Column(
          verticalDirection: VerticalDirection.down,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Número de jogadas: $rounds'),
            Expanded(child: 
              GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: level),
                padding: EdgeInsets.all(64),
                children: List.generate(length, (index) {
                  var value = index + 1;
              
                  return ElevatedButton(
                    onPressed: value >= length ? () => incrementRounds() : null,
                    style: ElevatedButton.styleFrom(
                      shape: LinearBorder(),
                    ),
                    child: 
                      Text(value < length ? "$value" : ""), 
                  );
                })
                ,
              ),
            )
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.shuffle),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
