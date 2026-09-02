import 'package:intl/intl.dart';

class DsFormatters {
  DsFormatters._();

  static final _brl = NumberFormat.simpleCurrency(locale: 'pt_BR');

  static String brl(num value) {
    return _brl.format(value);
  }
}
