import 'package:freezed_annotation/freezed_annotation.dart';

part 'pvs_qr_generate_request_model.freezed.dart';
part 'pvs_qr_generate_request_model.g.dart';

@freezed
class PvsQrGenerateRequest with _$PvsQrGenerateRequest {
  const factory PvsQrGenerateRequest({
    @JsonKey(name: 'amount') required double amount,
    @JsonKey(name: 'externalId') required String externalId,
    @JsonKey(name: 'reference') required String reference,
  }) = _PvsQrGenerateRequest;

  factory PvsQrGenerateRequest.fromJson(Map<String, dynamic> json) =>
      _$PvsQrGenerateRequestFromJson(json);
}
