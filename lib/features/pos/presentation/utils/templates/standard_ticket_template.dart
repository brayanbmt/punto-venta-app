import 'package:punto_venta_app/core/utils/extensions.dart';
import 'package:punto_venta_app/features/pos/presentation/utils/templates/base_ticket_template.dart';

/// Template estándar para tickets (implementación original)
/// Usado para reimprimir tickets guardados
class StandardTicketTemplate extends BaseTicketTemplate {
  StandardTicketTemplate({required super.printJob});

  @override
  Future<List<TicketCommand>> build() async {
    final commands = <TicketCommand>[];

    // === ENCABEZADO ===
    commands.addAll(buildHeader(isValidInvoice: false));

    // === INFORMACIÓN DE LA ORDEN ===
    commands.addAll(buildOrderInfo());

    // === ITEMS ===
    commands.addAll(
        buildItemsDetailed(showPricesWithTax: printJob.showPricesWithTax));

    // === TOTALES ===
    commands.addAll(_buildTotals());

    // === INFORMACIÓN ADICIONAL ===
    commands.addAll(buildAdditionalInfo());

    // === CÓDIGO DE BARRAS ===
    commands.addAll(buildBarcode());

    // === PIE DE PÁGINA ===
    commands.addAll(buildFooter());

    return commands;
  }

  /// Construye los totales (implementación original del template standard)
  List<TicketCommand> _buildTotals() {
    final commands = <TicketCommand>[];

    // Calcular subtotal restando todos los impuestos
    final subtotalAmount = (printJob.total - 
        printJob.totalTax - 
        printJob.iibbTax - 
        printJob.vatPerception -
        printJob.internalTax).formatToCurrency();

    // Subtotal siempre se muestra
    commands.add(TicketCommand.lineWithValue("Subtotal:", subtotalAmount));

    // IVA si es mayor a 0
    if (printJob.totalTax > 0) {
      final taxAmount = printJob.totalTax.formatToCurrency();
      commands.add(TicketCommand.lineWithValue("IVA:", taxAmount));
    }

    // Percepción IIBB si es mayor a 0
    if (printJob.iibbTax > 0) {
      final iibbAmount = printJob.iibbTax.formatToCurrency();
      final iibbLabel = printJob.iibbTaxPercentage != null
          ? "Percep. IIBB (${printJob.iibbTaxPercentage}%):"
          : "Percep. IIBB:";
      commands.add(TicketCommand.lineWithValue(iibbLabel, iibbAmount));
    }

    // Percepción IVA si es mayor a 0
    if (printJob.vatPerception > 0) {
      final vatPercepAmount = printJob.vatPerception.formatToCurrency();
      commands.add(TicketCommand.lineWithValue("Percep. IVA:", vatPercepAmount));
    }

    // Impuesto Interno si es mayor a 0
    if (printJob.internalTax > 0) {
      final internalTaxAmount = printJob.internalTax.formatToCurrency();
      final internalTaxLabel = printJob.internalTaxRate != null && printJob.internalTaxRate! > 0
          ? "Imp. Interno (${printJob.internalTaxRate}%):"
          : "Imp. Interno:";
      commands.add(TicketCommand.lineWithValue(internalTaxLabel, internalTaxAmount));
    }

    commands.add(TicketCommand.text(buildSeparator('_')));
    commands.add(TicketCommand.feedLine());

    if (printJob.receivedAmount != null && printJob.change != null) {
      final receivedAmount = printJob.receivedAmount!.formatToCurrency();
      final changeAmount = printJob.change!.formatToCurrency();

      commands.add(TicketCommand.feedLine());
      commands.add(TicketCommand.lineWithValue("Recibido:", receivedAmount));
      commands.add(TicketCommand.lineWithValue("Cambio:", changeAmount));
    }

    // Total siempre se muestra
    commands.add(TicketCommand.feedLine());
    commands.add(TicketCommand.bold(true));
    commands.add(TicketCommand.doubleHeight(true));
    commands.add(TicketCommand.lineWithValue(
        "TOTAL:", printJob.total.formatToCurrency()));
    commands.add(TicketCommand.doubleHeight(false));
    commands.add(TicketCommand.bold(false));
    commands.add(TicketCommand.text(buildSeparator('_')));
    commands.add(TicketCommand.feedLine());

    return commands;
  }
}
