class Joke {
  final  type, setup, punchline;
  final int id;
  Joke({this.id, this.type, this.setup, this.punchline});

  Joke.fromJson(Map<String, dynamic> json) :
        id = json["id"] as int,
        type=json["type"] as String,
        setup=json["setup"] as String,
        punchline=json['punchline'] as String;
}
