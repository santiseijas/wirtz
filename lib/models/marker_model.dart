

class Markers {
  int id;
  String name;

  int latitude;
  int longitude;

  Markers( this.id,this.name, this.latitude, this.longitude, {markerId});

  Markers.fromMap(Map snapshot,String id) :

        id = snapshot['id'] ?? '',
        name = snapshot['name'] ?? '',
        latitude = snapshot['latitude'] ?? '',
        longitude = snapshot['longitude'] ?? '';





  toJson() {
    return {
      "id": id,
      "title": name,
      "latitude": latitude,
      "longitude":longitude,

    };
  }
}