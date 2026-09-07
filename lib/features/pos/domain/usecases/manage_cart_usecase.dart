import '../entities/cart_item.dart';
import '../entities/cart_log_entry.dart';
import '../entities/product.dart';

class ManageCartUsecase {
  List<CartItem> addToCart(
    List<CartItem> currentCart,
    Product product,
    int quantity, {
    bool isWeighted = false,
    double? weightKg,
    double? pricePerKg,
  }) {
    final List<CartItem> newCart = List.from(currentCart);

    final existingItemIndex = newCart.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingItemIndex != -1) {
      final existing = newCart[existingItemIndex];

      if (isWeighted || (existing.isWeighted ?? false)) {
        // Mismo producto pesado: acumular kilos y total de línea.
        final mergedWeight =
            (existing.weightKg ?? 0.0) + (weightKg ?? 0.0);
        final mergedLineTotal =
            (existing.pricePerKg ?? 0.0) + (pricePerKg ?? 0.0);

        newCart[existingItemIndex] = existing.copyWith(
          quantity: existing.quantity + quantity,
          isWeighted: true,
          weightKg: mergedWeight,
          pricePerKg: mergedLineTotal,
        );
      } else {
        newCart[existingItemIndex] = existing.copyWith(
          quantity: existing.quantity + quantity,
        );
      }
    } else {
      newCart.add(CartItem(
        product: product,
        quantity: quantity,
        iva: product.vat,
        isWeighted: isWeighted,
        weightKg: weightKg,
        pricePerKg: pricePerKg,
      ));
    }

    return newCart;
  }

  List<CartItem> removeQuantityFromCart(
    List<CartItem> currentCart,
    String productId,
    int quantityToRemove, {
    bool isWeighted = false,
    double? weightKg,
    double? pricePerKg,
  }) {
    final List<CartItem> newCart = List.from(currentCart);

    final existingItemIndex = newCart.indexWhere(
      (item) => item.product.id.toString() == productId,
    );

    if (existingItemIndex == -1) return newCart;

    final currentItem = newCart[existingItemIndex];

    if (isWeighted || (currentItem.isWeighted ?? false)) {
      final remainingWeight =
          (currentItem.weightKg ?? 0.0) - (weightKg ?? 0.0);
      final remainingLineTotal =
          (currentItem.pricePerKg ?? 0.0) - (pricePerKg ?? 0.0);
      final remainingQuantity = currentItem.quantity - quantityToRemove;

      if (remainingWeight <= 0.0001 || remainingQuantity <= 0) {
        newCart.removeAt(existingItemIndex);
      } else {
        newCart[existingItemIndex] = currentItem.copyWith(
          quantity: remainingQuantity,
          weightKg: remainingWeight,
          pricePerKg: remainingLineTotal < 0 ? 0.0 : remainingLineTotal,
        );
      }
      return newCart;
    }

    final newQuantity = currentItem.quantity - quantityToRemove;

    if (newQuantity <= 0) {
      newCart.removeAt(existingItemIndex);
    } else {
      newCart[existingItemIndex] =
          currentItem.copyWith(quantity: newQuantity);
    }

    return newCart;
  }

  double calculateTotal(List<CartItem> cart) {
    return cart.fold(0.0, (total, item) => total + item.totalPrice);
  }

  int getTotalItems(List<CartItem> cart) {
    return cart.fold(0, (total, item) => total + item.quantity);
  }

  /// Reconstruye el carrito neto aplicando altas y bajas en orden.
  List<CartItem> rebuildFromLog(List<CartLogEntry> log) {
    List<CartItem> cart = [];
    for (final entry in log) {
      final isWeighted = entry.item.isWeighted ?? false;
      if (entry.type == CartActionType.add) {
        cart = addToCart(
          cart,
          entry.item.product,
          entry.item.quantity,
          isWeighted: isWeighted,
          weightKg: entry.item.weightKg,
          pricePerKg: entry.item.pricePerKg,
        );
      } else {
        cart = removeQuantityFromCart(
          cart,
          entry.item.product.id.toString(),
          entry.item.quantity,
          isWeighted: isWeighted,
          weightKg: entry.item.weightKg,
          pricePerKg: entry.item.pricePerKg,
        );
      }
    }
    return cart;
  }
}
