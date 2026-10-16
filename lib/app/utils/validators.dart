import '../constants/app_strings.dart';

/// One line of the Sign-Up password checklist. Each rule knows its label and
/// how to test a password, so the checklist and the validator never disagree.
enum PasswordRule {
  minLength(AppStrings.ruleMinLength),
  letter(AppStrings.ruleLetter),
  digit(AppStrings.ruleDigit);

  const PasswordRule(this.label);

  final String label;

  static const int minPasswordLength = 8;
  static final RegExp _letter = RegExp(r'[A-Za-z]');
  static final RegExp _digit = RegExp(r'\d');

  bool isMetBy(String password) {
    switch (this) {
      case PasswordRule.minLength:
        return password.length >= minPasswordLength;
      case PasswordRule.letter:
        return _letter.hasMatch(password);
      case PasswordRule.digit:
        return _digit.hasMatch(password);
    }
  }
}

/// Pure form validators. They return an [AppStrings] message, or null when
/// the value is valid, so they plug straight into `TextFormField.validator`.
class Validators {
  Validators._();

  static final RegExp _emailRegex = RegExp(
    r'^[\w.+-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z]{2,}$',
  );

  /// The form used as the Firestore document ID in emails/{email}.
  static String normalizeEmail(String email) => email.trim().toLowerCase();

  static bool isValidEmail(String email) => _emailRegex.hasMatch(email.trim());

  /// True when every [PasswordRule] is satisfied.
  static bool isStrongPassword(String password) =>
      PasswordRule.values.every((rule) => rule.isMetBy(password));

  static String? name(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return AppStrings.nameRequired;
    if (name.length < 2) return AppStrings.nameTooShort;
    return null;
  }

  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return AppStrings.emailRequired;
    if (!isValidEmail(email)) return AppStrings.emailInvalid;
    return null;
  }

  /// Login only checks the password is present, so accounts created before
  /// the 8-character rule can still log in.
  static String? loginPassword(String? value) {
    if ((value ?? '').isEmpty) return AppStrings.passwordRequired;
    return null;
  }

  /// Sign-Up enforces every [PasswordRule].
  static String? signupPassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return AppStrings.passwordRequired;
    if (!isStrongPassword(password)) return AppStrings.passwordTooWeak;
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    final confirm = value ?? '';
    if (confirm.isEmpty) return AppStrings.confirmPasswordRequired;
    if (confirm != password) return AppStrings.passwordsDoNotMatch;
    return null;
  }
}
