import 'dart:convert';

class Frog {
  final String coords;
  final String status;
  
  Frog(this.coords, this.status);
    
  Frog.fromHit(Map<String, dynamic> hit)
    : coords = jsonEncode(hit['_geoloc']),
      status = hit['status'];
  
  Map<String, dynamic> toJson() => {
    'coords': coords,
    'status': status,
  };
}