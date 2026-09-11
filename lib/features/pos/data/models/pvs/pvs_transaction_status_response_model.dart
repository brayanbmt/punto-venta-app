import 'package:freezed_annotation/freezed_annotation.dart';

part 'pvs_transaction_status_response_model.freezed.dart';
part 'pvs_transaction_status_response_model.g.dart';

@freezed
class PvsTransactionStatusResponse with _$PvsTransactionStatusResponse {
  const factory PvsTransactionStatusResponse({
    @JsonKey(name: 'code') String? code,
    @JsonKey(name: 'ok') bool? ok,
    @JsonKey(name: 'data') PvsTransactionData? data,
  }) = _PvsTransactionStatusResponse;

  factory PvsTransactionStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$PvsTransactionStatusResponseFromJson(json);
}

@freezed
class PvsTransactionData with _$PvsTransactionData {
  const factory PvsTransactionData({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'qrId') String? qrId,
    @JsonKey(name: 'stateId') int? stateId,
    @JsonKey(name: 'state') String? state,
    @JsonKey(name: 'amount') String? amount,
    @JsonKey(name: 'currencyCode') String? currencyCode,
    @JsonKey(name: 'paymentStatus') String? paymentStatus,
    @JsonKey(name: 'wallet') String? wallet,
    @JsonKey(name: 'createdAt') String? createdAt,
  }) = _PvsTransactionData;

  factory PvsTransactionData.fromJson(Map<String, dynamic> json) =>
      _$PvsTransactionDataFromJson(json);
}
