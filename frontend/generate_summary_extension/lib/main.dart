import 'package:flutter/material.dart';
import 'package:generate_summary_extension/app/ui/home_screen.dart';
import 'dart:js' as js;
import 'package:http/http.dart' as http;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  String webUrl = '';

  void getUrl() {
    var queryInfo = js.JsObject.jsify({'active': true, 'currentWindow': true});
    js.context['chrome']['tabs']?.callMethod('query', [
      queryInfo,
          (tabs) async {
        var url = tabs[0]['url'];
        setState(() {
          webUrl = url;
        });
      }
    ]);
  }

  @override
  void initState() {
    getUrl();
    super.initState();
  }
  Future<String> fetchSummary(String webUrl,{bool points = false}) async {
    try {
      final response = await http.get(
        Uri.parse('http://172.18.3.52:3010/?input=$webUrl&points=$points'),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load summary');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Summary Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 30,),
            Text(
              'Website URL:- $webUrl',
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SummaryScreen(webUrl),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
                        child: const Text(
                          'Get Summary',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 150.0,),
                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SummaryScreen(webUrl, points: true,),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
                        child: const Text(
                          'Significant points',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
