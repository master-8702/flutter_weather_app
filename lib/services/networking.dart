import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  NetworkHelper(this.url);

  final String url;

  Future getData() async {
    Uri parseduUrl = Uri.parse(url);
    http.Response response = await http.get(parseduUrl);

    if (response.statusCode == 200) {
      String responseData = response.body;
// the jsonDecode method comes from dart:covert library
      var decodedData = jsonDecode(responseData);
      return decodedData;
    } else {
      print(response.statusCode);
    }
  }
}
