import 'dart:convert';
import 'dart:core';
import '../device.dart';
import 'package:http/http.dart' as http;

class FrogScan {
  Uri? _url;
  Map<String, String>? _headers;
  String? _data;
  Device? _device;
  final int _radius;

  FrogScan(this._radius) {
    _radius.toString();
    _device = Device();
  }

  Future<Map<String, dynamic>> getResponse() async {
    _url = Uri.parse('https://apkykk0pza-dsn.algolia.net/1/indexes/prod_locator_prod_zabka/query?x-algolia-agent=Algolia%20for%20vanilla%20JavaScript%203.22.1&x-algolia-application-id=APKYKK0PZA&x-algolia-api-key=71ca67cda813cec86431992e5e67ede2');
    _headers = {
      'Connection': 'keep-alive',
      'Sec-Fetch-Dest': 'empty',
      'Sec-Fetch-Mode': 'cors',
      'Sec-Fetch-Site': 'cross-site',
      'accept': 'application/json',
      'content-type': 'application/x-www-form-urlencoded',
      'sec-ch-ua-mobile': '?0',
      'Accept-Encoding': 'gzip',
    };
    _data = await _getPayload();
    final res = await http.post(_url!, headers: _headers, body: _data);
    if (res.statusCode != 200) throw Exception('http.post error: statusCode=${res.statusCode}');
    return jsonDecode(res.body);
  }

  Future<String> _getPayload() async {
    final position = await _device?.getPosition();
    final lat = position?.latitude.toString();
    final lng = position?.longitude.toString();
    return '{"params":"query=&hitsPerPage=9999&facetFilters=%5B%5D&aroundLatLng=$lat,$lng&aroundRadius=$_radius"}';
  }
}