import 'dart:math';

String generateCreditCardNumber() {
  final Random random = Random();

  // Generate the first 7 random digits
  List<int> digits = List.generate(7, (_) => random.nextInt(10));

  // Compute the Luhn check digit
  int checkDigit = calculateLuhnCheckDigit(digits);

  // Append the check digit to form the 8-digit number
  digits.add(checkDigit);

  return digits.join();
}

int calculateLuhnCheckDigit(List<int> digits) {
  List<int> tempDigits = List.from(digits);

  // Double every second digit from right (starting index: len - 1, step: -2)
  for (int i = tempDigits.length - 1; i >= 0; i -= 2) {
    int doubled = tempDigits[i] * 2;
    tempDigits[i] = doubled > 9 ? doubled - 9 : doubled;
  }

  int sum = tempDigits.reduce((a, b) => a + b);

  return (10 - (sum % 10)) %
      10; // Ensure the last digit makes the sum a multiple of 10
}
