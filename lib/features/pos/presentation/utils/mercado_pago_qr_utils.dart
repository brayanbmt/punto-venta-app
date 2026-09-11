import 'package:punto_venta_app/features/pos/domain/entities/payment_method.dart';

bool isMercadoPagoQrMethod(PaymentMethod paymentMethod) {
  final desc = paymentMethod.description.toLowerCase();
  final shortDesc = paymentMethod.shortDescription.toLowerCase();
  return desc.contains('qr') ||
      shortDesc.contains('qr') ||
      desc.contains('mercado') ||
      shortDesc.contains('mercado');
}

String? extractMpOrderId(PaymentMethod? paymentMethod) {
  final orderId = paymentMethod?.details?.orderId;
  if (orderId != null && orderId.isNotEmpty) return orderId;
  return null;
}

String? extractMpOrderIdFromTicketPayments(List<PaymentMethod>? paymentMethods) {
  if (paymentMethods == null) return null;
  for (final pm in paymentMethods) {
    final orderId = extractMpOrderId(pm);
    if (orderId != null) return orderId;
    if (isMercadoPagoQrMethod(pm)) {
      return extractMpOrderId(pm);
    }
  }
  return null;
}

bool ticketHasMercadoPagoQr(List<PaymentMethod>? paymentMethods) {
  if (paymentMethods == null) return false;
  for (final pm in paymentMethods) {
    if (extractMpOrderId(pm) != null) return true;
    if (isMercadoPagoQrMethod(pm)) return true;
  }
  return false;
}
