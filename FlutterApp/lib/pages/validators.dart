String? validateNgayNhap(String? val) {
  if (val == null || val.trim().isEmpty) {
    return 'Vui lòng nhập ngày nhập';
  }

  try {
    final regex = RegExp(r'^\d{1,2}-\d{1,2}-\d{4}$');
    if (!regex.hasMatch(val)) {
      return 'Ngày không đúng định dạng dd-mm-yyyy';
    }
    final parts = val.split('-');
    if (parts.length != 3) {
      return 'Ngày không đúng định dạng dd-mm-yyyy';
    }
    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);
    if (day < 1 || day > 31 || month < 1 || month > 12) {
      return 'Ngày không hợp lệ';
    }
    final inputDate = DateTime(year, month, day);
    if (inputDate.day != day ||
        inputDate.month != month ||
        inputDate.year != year) {
      return 'Ngày không hợp lệ';
    }
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final currentDate = DateTime(
      todayOnly.year,
      todayOnly.month,
      todayOnly.day,
    );
    if (inputDate.isAfter(currentDate)) {
      return 'Ngày nhập phải trước hoặc bằng ngày hiện tại';
    }
  } catch (_) {
    return 'Ngày không hợp lệ';
  }
  return null;
}

String? validatePhone(String? val) {
  if (val == null || val.trim().isEmpty) {
    return 'Số điện thoại không được bỏ trống';
  }
  final phone = val.trim().replaceAll(' ', '');
  final phoneRegExp = RegExp(r'^\d{10,11}$');
  if (!phoneRegExp.hasMatch(phone)) {
    return 'Số điện thoại phải có 10 hoặc 11 chữ số';
  }
  return null;
}

String? validateName(String? val) {
  if (val == null || val.trim().isEmpty) {
    return 'Họ và tên không được bỏ trống';
  }
  return null;
}

String? validatePass(String? val) {
  if (val == null || val.trim().isEmpty) {
    return 'Mật khẩu không được để trống';
  }
  if (val.length < 8) {
    return 'Mật khẩu phải có ít nhất 8 ký tự';
  }
  final hasLetter = RegExp(r'[A-Za-z]').hasMatch(val);
  final hasNumber = RegExp(r'[0-9]').hasMatch(val);
  if (!hasLetter || !hasNumber) {
    return 'Mật khẩu phải bao gồm cả chữ cái và số';
  }
  final specialChar = RegExp(r'[^A-Za-z0-9]');
  if (specialChar.hasMatch(val)) {
    return 'Mật khẩu không được chứa ký tự đặc biệt';
  }
  return null;
}

String? validateRePass(String? val, String? originalPass) {
  if (val == null || val.trim().isEmpty) {
    return 'Vui lòng nhập lại mật khẩu';
  }
  if (val != originalPass) {
    return 'Mật khẩu nhập lại không khớp';
  }
  return null;
}
