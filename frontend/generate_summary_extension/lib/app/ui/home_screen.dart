import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SummaryScreen extends StatelessWidget {
  final String url;
  final bool points;
  const SummaryScreen(this.url, {super.key, this.points = false});
  Future<String> fetchSummary(String webUrl) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.68.227:3010/?input=$webUrl&points=$points'),
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
      appBar: AppBar(),
      body: FutureBuilder<String>(
        future: fetchSummary(url),
        builder: (context, snapshotSummary) {
          if (snapshotSummary.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshotSummary.hasError) {
            return Text('Error: ${snapshotSummary.error}');
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Website URL:- $url',
                    textAlign: TextAlign.center,
                  ),
                  Text('Summary: ${snapshotSummary.data}'),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
