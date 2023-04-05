
class Frog {
  final String id;
  final double lat;
  final double lng;
  final String status;
  final String address;
  
  Frog(this.id, this.lat, this.lng, this.status, this.address);
    
  Frog.fromHit(Map<String, dynamic> hit)
    : id = hit['id'],
      lat = hit['_geoloc']['lat'],
      lng = hit['_geoloc']['lng'],
      status = hit['status'],
      address = hit['address'];
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'lat': lat,
    'lng': lng,
    'status': status,
    'address': address,
  };
}