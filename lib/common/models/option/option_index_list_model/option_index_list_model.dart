import 'package:happy/common/index.dart';

class OptionIndexListModel {
  String? guessTimeName;
  List<OptionIndexListModelScenePairList>? scenePairList;

  OptionIndexListModel({this.guessTimeName, this.scenePairList});

  factory OptionIndexListModel.fromJson(Map<String, dynamic> json) {
    return OptionIndexListModel(
      guessTimeName: DataUtils.toStr(json['guessTimeName']),
      scenePairList:
          (json['scenePairList'] as List<dynamic>?)?.map((e) => OptionIndexListModelScenePairList.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'guessTimeName': guessTimeName,
        'scenePairList': scenePairList?.map((e) => e.toJson()).toList(),
      };
}
