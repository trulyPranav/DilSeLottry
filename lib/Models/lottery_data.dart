class Lottery {
  final String id;
  final String image;
  final int value;
  final String url;
  Lottery({required this.id, required this.image, required this.value,required this.url});

  factory Lottery.fromJson(Map<String, dynamic> json) {
    return Lottery(
      id: json['id'],
      image: json['image'],
      value: json['value'],
      url: json['url']
    );
  }
}
