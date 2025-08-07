import 'package:happy/common/index.dart';

class OptionDetailNavModel {
  String? guessPairsName;
  List<ScenePairList>? scenePairList;

  OptionDetailNavModel({this.guessPairsName, this.scenePairList});

  factory OptionDetailNavModel.fromJson(Map<String, dynamic> json) {
    return OptionDetailNavModel(
      guessPairsName: DataUtils.toStr(json['guessPairsName']),
      scenePairList: (json['scenePairList'] as List<dynamic>?)?.map((e) => ScenePairList.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'guessPairsName': guessPairsName,
        'scenePairList': scenePairList?.map((e) => e.toJson()).toList(),
      };
}
