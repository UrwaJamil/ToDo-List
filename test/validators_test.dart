import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/app/constants/app_strings.dart';
import 'package:todo_app/app/utils/validators.dart';

void main() {
  group('PasswordRule', () {
    test('minLength needs at least 8 characters', () {
      expect(PasswordRule.minLength.isMetBy('abc1234'), isFalse);
      expect(PasswordRule.minLength.isMetBy('abcd1234'), isTrue);
    });

    test('letter needs at least one A-Z or a-z', () {
      expect(PasswordRule.letter.isMetBy('12345678'), isFalse);
      expect(PasswordRule.letter.isMetBy('1234567a'), isTrue);
      expect(PasswordRule.letter.isMetBy('1234567Z'), isTrue);
    });

    test('digit needs at least one number', () {
      expect(PasswordRule.digit.isMetBy('abcdefgh'), isFalse);
      expect(PasswordRule.digit.isMetBy('abcdefg9'), isTrue);
    });

    test('every rule fails for an empty password', () {
      for (final rule in PasswordRule.values) {
        expect(rule.isMetBy(''), isFalse, reason: rule.name);
      }
    });
  });

  group('Validators.signupPassword', () {
    test('empty password asks for a password', () {
      expect(Validators.signupPassword(null), AppStrings.passwordRequired);
      expect(Validators.signupPassword(''), AppStrings.passwordRequired);
    });

    test('rejects passwords that miss any rule', () {
      for (final weak in ['abc123', 'abcdefgh', '12345678', 'a1']) {
        expect(
          Validators.signupPassword(weak),
          AppStrings.passwordTooWeak,
          reason: weak,
        );
      }
    });

    test('accepts 8+ characters with a letter and a digit', () {
      for (final strong in ['abcdefg1', 'PASSWORD9', '1234567x', 'my pass 1']) {
        expect(Validators.signupPassword(strong), isNull, reason: strong);
      }
    });

    test('does not require uppercase or special characters', () {
      expect(Validators.isStrongPassword('lowercase1'), isTrue);
    });
  });

  group('Validators.loginPassword', () {
    test('only checks that the password is not empty', () {
      expect(Validators.loginPassword(''), AppStrings.passwordRequired);
      // Old accounts with short or simple passwords must still log in.
      expect(Validators.loginPassword('abc'), isNull);
      expect(Validators.loginPassword('123456'), isNull);
    });
  });

  group('Validators.confirmPassword', () {
    test('must be present and match', () {
      expect(
        Validators.confirmPassword('', 'abcdefg1'),
        AppStrings.confirmPasswordRequired,
      );
      expect(
        Validators.confirmPassword('abcdefg2', 'abcdefg1'),
        AppStrings.passwordsDoNotMatch,
      );
      expect(Validators.confirmPassword('abcdefg1', 'abcdefg1'), isNull);
    });
  });

  group('Validators.email', () {
    test('required and well formed', () {
      expect(Validators.email(''), AppStrings.emailRequired);
      expect(Validators.email('not-an-email'), AppStrings.emailInvalid);
      expect(Validators.email('a@b'), AppStrings.emailInvalid);
      expect(Validators.email(' ali@example.com '), isNull);
    });

    test('normalizeEmail trims and lowercases (emails/{email} doc ID)', () {
      expect(
        Validators.normalizeEmail('  Ali@Example.COM '),
        'ali@example.com',
      );
    });
  });
}
