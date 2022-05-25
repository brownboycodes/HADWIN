String identifyCard(String cardNumber) {
  cardNumber = cardNumber.replaceAll('-', '');
  cardNumber = cardNumber.replaceAll(' ', '');
  String detectedBrand = 'default';
  Map<String, dynamic> cardRegexPatterns = {
    'american-express': r'^3[47][0-9]{13}$',
    'bcglobal': r'^(6541|6556)[0-9]{12}$',
    'carte-blanche': r'^389[0-9]{11}$',
    'diners-club': r'^3(?:0[0-5]|[68][0-9])[0-9]{11}$',
    'discover':
        r'^65[4-9][0-9]{13}|64[4-9][0-9]{13}|6011[0-9]{12}|(622(?:12[6-9]|1[3-9][0-9]|[2-8][0-9][0-9]|9[01][0-9]|92[0-5])[0-9]{10})$',
    'insta-payment': r'^63[7-9][0-9]{13}$',
    'jcb': r'^(?:2131|1800|35\d{3})\d{11}$',
    'korean-local': r'^9[0-9]{15}$',
    'laser': r'^(6304|6706|6709|6771)[0-9]{12,15}$',
    'maestro': r'^(5018|5020|5038|5893|6304|6759|6761|6762|6763)[0-9]{8,15}$',
    'mastercard':
        r'^(5[1-5][0-9]{14}|2(22[1-9][0-9]{12}|2[3-9][0-9]{13}|[3-6][0-9]{14}|7[0-1][0-9]{13}|720[0-9]{12}))$',
    'rupay': r'^6(?!011)(?:0[0-9]{14}|52[12][0-9]{12})$',
    'solo': r'^(6334|6767)[0-9]{12}|(6334|6767)[0-9]{14}|(6334|6767)[0-9]{15}$',
    'switch':
        r'^(4903|4905|4911|4936|6333|6759)[0-9]{12}|(4903|4905|4911|4936|6333|6759)[0-9]{14}|(4903|4905|4911|4936|6333|6759)[0-9]{15}|564182[0-9]{10}|564182[0-9]{12}|564182[0-9]{13}|633110[0-9]{10}|633110[0-9]{12}|633110[0-9]{13}$',
    'union-pay': r'^(62[0-9]{14,17})$',
    'visa': r'^4[0-9]{12}(?:[0-9]{3})?$',
  };

  for (MapEntry cp in cardRegexPatterns.entries) {
    if (RegExp(cp.value).hasMatch(cardNumber)) {
      detectedBrand = cp.key;
      break;
    }
  }

  return detectedBrand;
}

String identifyCardShorter(String cardNumber) {
  cardNumber = cardNumber.replaceAll('-', '');
  cardNumber = cardNumber.replaceAll(' ', '');
  String detectedBrand = 'default';
  Map<String, dynamic> cardRegexPatterns = {
    'american-express': r'^3[47][0-9]{1}',
    'discover':
        r'^65[4-9]|64[4-9]|6011|(622(?:12[6-9]|1[3-9][0-9]|[2-8][0-9][0-9]|9[01][0-9]|92[0-5])[0-9]{10})$',
    'maestro': r'^(5018|5020|5038|5893|6304|6759|6761|6762|6763)',
    'mastercard':
        r'^(5[1-5][0-9]{4}|2(22[1-9][0-9]{2}|2[3-9][0-9]{3}|[3-6][0-9]{4}|7[0-1][0-9]{3}|720[0-9]{2}))',
    'visa': r'^4[0-9]{3}',
  };

  for (MapEntry cp in cardRegexPatterns.entries) {
    if (RegExp(cp.value).hasMatch(cardNumber)) {
      detectedBrand = cp.key;
      break;
    }
  }

  return detectedBrand;
}
