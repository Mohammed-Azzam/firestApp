class SinglePostAdditionalInfo {
  // {"id":15,"counter":3,"limit_counter":6,"text":"start"}

  // late final int id;
  late final int post_id;
  late final int counter;
  late final int limit_counter;
  late final String status;

  SinglePostAdditionalInfo({
    // required this.id,
    required this.post_id,
    required this.counter,
    required this.limit_counter,
    required this.status,
  });

  SinglePostAdditionalInfo.fromJson(json) {
    // this.id = json['id'];
    this.post_id = json['post_id'];
    this.counter = json['counter'];
    this.limit_counter = json['limit_counter'];
    this.status = json['text'];
  }

  Map<String, dynamic> toMap() {
    return {
      // "id": id,
      "post_id": post_id,
      "counter": counter,
      "limit_counter": limit_counter,
      "text": status
    };
  }
}
