import 'package:speed_and_success/DataModels/single_post_additional_info.dart';

class PostsAdditionalInfo {
  // {"response":
  // [{"id":15,"counter":3,"limit_counter":6,"text":"start"},
  // {"id":22,"counter":5,"limit_counter":6,"text":"start"}]
  // }

  late final List<SinglePostAdditionalInfo> additionalInfoList;

  PostsAdditionalInfo({
    required this.additionalInfoList,
  });

  PostsAdditionalInfo.fromJson(json) {
    this.additionalInfoList = [];
    List<dynamic> l = json['response'];
    l.forEach((element) {
      this.additionalInfoList.add(SinglePostAdditionalInfo.fromJson(element));
    });
  }

  Map<String, dynamic> toMap() {
    return {
      "response": additionalInfoList,
    };
  }
}
