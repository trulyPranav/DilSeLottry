class Lottery {
  final String id;
  final String image;
  final int value;

  Lottery({required this.id, required this.image, required this.value});

  factory Lottery.fromJson(Map<String, dynamic> json) {
    return Lottery(
      id: json['id'],
      image: json['image'],
      value: json['value'],
    );
  }
}
