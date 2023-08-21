import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  final String title;

  const HomeScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Summary Generator'),
      ),
      body: FutureBuilder<String>(
          future: getUrl(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SummaryScreen(snapshot.data ?? ''),
                        ),
                      );
                    },
                    child: const Text('Get Summary'),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return const SizedBox.shrink();
          }),
    );
  }

  Future<String> getUrl() async {
    try {
      var queryInfo =
          js.JsObject.jsify({'active': true, 'currentWindow': true});
      var url;
      await js.context['chrome']['tabs']?.callMethod('query', [
        queryInfo,
        (tabs) async {
          url = tabs[0]['url'];
        }
      ]);
      return url ?? 'https://en.wikipedia.org/wiki/Artificial_intelligence';
    } catch (e) {
      throw Exception('Unable to get website link...');
    }
  }
}

class SummaryScreen extends StatelessWidget {
  final String url;
  const SummaryScreen(this.url, {super.key});
  Future<String> fetchSummary(String webUrl) async {
    try {
      final response = await http.get(
        Uri.parse('http://172.18.3.52:3010/?input=$webUrl'),
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
      body: FutureBuilder<String>(
        future: fetchSummary(url),
        builder: (context, snapshotSummary) {
          if (snapshotSummary.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshotSummary.hasError) {
            return Text('Error: ${snapshotSummary.error}');
          } else {
            return Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Website URL:- $url',
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: Text('Summary: ${snapshotSummary.data}'),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
