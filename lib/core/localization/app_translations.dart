import 'package:get/get.dart';
import 'languages/en_us.dart';
import 'languages/bn_bd.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUs,
        'bn_BD': bnBd,
      };
}
