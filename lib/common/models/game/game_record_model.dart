import 'package:happy/common/index.dart';

class GameRecordModel {
  int? id;
  int? userId;
  int? coinId;
  String? coinName;
  String? createdAt;
  String? updatedAt;
  String? amount;
  int? status;
  int? gameId;
  int? type;
  int? result;
  int? expect;
  double? win;
  String? serialNumber;
  String? number;
  int? blockId;
  String? hash;
  String? inviteUrl;

  GameRecordModel({
    this.id,
    this.userId,
    this.coinId,
    this.coinName,
    this.createdAt,
    this.updatedAt,
    this.amount,
    this.status,
    this.gameId,
    this.type,
    this.result,
    this.expect,
    this.win,
    this.serialNumber,
    this.number,
    this.blockId,
    this.hash,
    this.inviteUrl,
  });

  factory GameRecordModel.fromJson(Map<String, dynamic> json) {
    return GameRecordModel(
      id: DataUtils.toInt(json['id']),
      userId: DataUtils.toInt(json['user_id']),
      coinId: DataUtils.toInt(json['coin_id']),
      coinName: json['coin_name'] as String?,
      createdAt: DataUtils.toStr(json['created_at']),
      updatedAt: DataUtils.toStr(json['updated_at']),
      amount: DataUtils.toStr(json['amount']),
      status: DataUtils.toInt(json['status']),
      gameId: DataUtils.toInt(json['game_id']),
      type: DataUtils.toInt(json['type']),
      result: DataUtils.toInt(json['result']),
      expect: DataUtils.toInt(json['expect']),
      win: DataUtils.toDouble(json['win']),
      serialNumber: DataUtils.toStr(json['serial_number']),
      number: DataUtils.toStr(json['number']),
      blockId: DataUtils.toInt(json['block_id']),
      hash: DataUtils.toStr(json['hash']),
      inviteUrl: DataUtils.toStr(json['invite_url']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'coin_id': coinId,
        'coin_name': coinName,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'amount': amount,
        'status': status,
        'game_id': gameId,
        'type': type,
        'result': result,
        'expect': expect,
        'win': win,
        'serial_number': serialNumber,
        'number': number,
        'block_id': blockId,
        'hash': hash,
        'invite_url': inviteUrl,
      };
}
