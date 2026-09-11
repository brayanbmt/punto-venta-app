import 'package:punto_venta_app/core/utils/enums.dart';
import 'package:punto_venta_app/features/pos/domain/entities/payment_method.dart';

bool isMercadoPagoQrMethod(PaymentMethod paymentMethod) {
  return paymentMethod.qrType == QrType.mp;
}

bool isPvsQrMethod(PaymentMethod paymentMethod) {
  return paymentMethod.qrType == QrType.pvs;
}

bool isDynamicQrMethod(PaymentMethod paymentMethod) {
  return isMercadoPagoQrMethod(paymentMethod) || isPvsQrMethod(paymentMethod);
}

String? extractQrOrderId(PaymentMethod? paymentMethod) {
  final orderId = paymentMethod?.details?.orderId;
  if (orderId != null && orderId.isNotEmpty) return orderId;
  return null;
}

/// Alias histórico; usa [extractQrOrderId].
String? extractMpOrderId(PaymentMethod? paymentMethod) =>
    extractQrOrderId(paymentMethod);

String? extractMpOrderIdFromTicketPayments(List<PaymentMethod>? paymentMethods) {
  if (paymentMethods == null) return null;
  for (final pm in paymentMethods) {
    final orderId = extractQrOrderId(pm);
    if (orderId != null) return orderId;
  }
  return null;
}

String? extractPvsOrderIdFromTicketPayments(
    List<PaymentMethod>? paymentMethods) {
  if (paymentMethods == null) return null;
  for (final pm in paymentMethods) {
    if (!isPvsQrMethod(pm)) continue;
    final orderId = extractQrOrderId(pm);
    if (orderId != null) return orderId;
  }
  return null;
}

PaymentMethod? findPvsPaymentMethod(List<PaymentMethod>? paymentMethods) {
  if (paymentMethods == null) return null;
  for (final pm in paymentMethods) {
    if (isPvsQrMethod(pm)) return pm;
  }
  return null;
}

bool ticketHasMercadoPagoQr(List<PaymentMethod>? paymentMethods) {
  if (paymentMethods == null) return false;
  for (final pm in paymentMethods) {
    if (isMercadoPagoQrMethod(pm)) return true;
    if (extractQrOrderId(pm) != null && pm.qrType == QrType.mp) return true;
  }
  return false;
}

bool ticketHasPvsQr(List<PaymentMethod>? paymentMethods) {
  if (paymentMethods == null) return false;
  for (final pm in paymentMethods) {
    if (isPvsQrMethod(pm)) return true;
  }
  return false;
}
