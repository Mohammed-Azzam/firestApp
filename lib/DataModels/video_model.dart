class VideoModel {
  late final List<dynamic> progressive;
  late final List<dynamic> streams_avc;
  late final List<dynamic> streams;
  late final Map<String, String> resolutions;

  VideoModel({
    required this.progressive,
    required this.streams_avc,
    required this.streams,
  }) {
    _getResolution();
  }

  VideoModel.fromJson(json) {
    final List<dynamic> _progressive = json['request']['files']['progressive'];
    final List<dynamic> _streams_avc = json['request']['files']['dash']['streams_avc'];
    final List<dynamic> _streams = json['request']['files']['dash']['streams'];
    final Map<String, String> _resolutions = {};

    _progressive.sort((a, b) => a['height'].compareTo(b['height']));
    _progressive.forEach((element) {
      _resolutions[element['height'].toString()] = element['url'];
      print('${element['height']}: ${element['url']}');
    });


    this.progressive = _progressive;
    this.streams_avc = _streams_avc;
    this.streams = _streams;
    this.resolutions = _resolutions;
  }

  Map<String, dynamic> toMap() {
    return {
      "progressive": progressive,
      "streams_avc": streams_avc,
      "streams": streams,
    };
  }

  void _getResolution() {
    this.resolutions = {};
    progressive.sort((a, b) => a['height'].compareTo(b['height']));
    progressive.forEach((element) {
      this.resolutions[element['height'].toString()] = element['url'];
      print('${element['height']}: ${element['url']}');
    });
  }
}
