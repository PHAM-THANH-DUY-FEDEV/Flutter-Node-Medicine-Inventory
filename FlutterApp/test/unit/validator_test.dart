import 'package:flutter_test/flutter_test.dart';
import 'package:medication_management_app/pages/validators.dart';

void main() {
  group('Kiểm tra validateNgayNhap', () {
    test('Ngày nhập rỗng', () {
      expect(validateNgayNhap(null), 'Vui lòng nhập ngày nhập');
      expect(validateNgayNhap(''), 'Vui lòng nhập ngày nhập');
      expect(validateNgayNhap('   '), 'Vui lòng nhập ngày nhập');
    });

    test('Sai định dạng ngày', () {
      expect(
        validateNgayNhap('2024-12-01'),
        'Ngày không đúng định dạng dd-mm-yyyy',
      );
      expect(
        validateNgayNhap('01/13-2024'),
        'Ngày không đúng định dạng dd-mm-yyyy',
      );
      expect(validateNgayNhap('abc'), 'Ngày không đúng định dạng dd-mm-yyyy');
    });

    test('Ngày nhập sau hôm nay', () {
      expect(
        validateNgayNhap("15-08-2025"),
        'Ngày nhập phải trước hoặc bằng ngày hiện tại',
      );
    });

    test('Ngày nhập là hôm nay', () {
      final today = DateTime.now();
      final todayOnly = DateTime(today.year, today.month, today.day);
      final dateStr = '${todayOnly.day}-${todayOnly.month}-${todayOnly.year}';
      expect(validateNgayNhap(dateStr), null);
    });

    test('Ngày nhập trước hôm nay', () {
      expect(validateNgayNhap("13-08-2025"), null);
    });
  });
  group('validatePhone', () {
    test('Số điện thoại trống', () {
      expect(validatePhone(''), 'Số điện thoại không được bỏ trống');
    });

    test('Số điện thoại không đủ ký tự', () {
      expect(
        validatePhone('123456789'),
        'Số điện thoại phải có 10 hoặc 11 chữ số',
      );
    });

    test('Số điện thoại có ký tự không phải số', () {
      expect(
        validatePhone('12345abcde'),
        'Số điện thoại phải có 10 hoặc 11 chữ số',
      );
    });

    test('Số điện thoại hợp lệ 10 số', () {
      expect(validatePhone('0123456789'), null);
    });

    test('Số điện thoại hợp lệ 11 số', () {
      expect(validatePhone('01234567890'), null);
    });
  });
  group('validateName', () {
    test('Tên trống', () {
      expect(validateName(''), 'Họ và tên không được bỏ trống');
    });

    test('Tên hợp lệ', () {
      expect(validateName('Nguyễn Văn A'), null);
    });
  });

  group('validatePass', () {
    test('Mật khẩu trống', () {
      expect(validatePass(''), 'Mật khẩu không được để trống');
    });

    test('Mật khẩu ít hơn 8 ký tự', () {
      expect(validatePass('abc123'), 'Mật khẩu phải có ít nhất 8 ký tự');
    });

    test('Mật khẩu không chứa số', () {
      expect(
        validatePass('abcdefgh'),
        'Mật khẩu phải bao gồm cả chữ cái và số',
      );
    });

    test('Mật khẩu không chứa chữ cái', () {
      expect(
        validatePass('12345678'),
        'Mật khẩu phải bao gồm cả chữ cái và số',
      );
    });

    test('Mật khẩu chứa ký tự đặc biệt', () {
      expect(
        validatePass('abc123!@#'),
        'Mật khẩu không được chứa ký tự đặc biệt',
      );
    });

    test('Mật khẩu hợp lệ', () {
      expect(validatePass('abc12345'), null);
    });
  });
  group('validateRePass', () {
    test('Nhập lại mật khẩu trống', () {
      expect(validateRePass('', 'abc12345'), 'Vui lòng nhập lại mật khẩu');
    });

    test('Nhập lại mật khẩu không khớp', () {
      expect(
        validateRePass('abc12346', 'abc12345'),
        'Mật khẩu nhập lại không khớp',
      );
    });

    test('Nhập lại mật khẩu khớp', () {
      expect(validateRePass('abc12345', 'abc12345'), null);
    });
  });
}
