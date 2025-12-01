/// Validation utilities for user input
/// Provides email, password, and input sanitization functions
class Validators {
  Validators._(); // Private constructor to prevent instantiation

  /// Email validation regex pattern
  /// Validates standard email format: user@domain.extension
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Check if email is valid (returns boolean)
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    return _emailRegex.hasMatch(email.trim());
  }

  /// Check if password is valid (returns boolean)
  static bool isValidPassword(String password) {
    return password.length >= 8;
  }

  /// Validate email address format
  /// Returns null if valid, error message if invalid
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }

    final trimmedEmail = email.trim();

    if (!_emailRegex.hasMatch(trimmedEmail)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validate password strength
  /// Minimum 8 characters required
  /// Returns null if valid, error message if invalid
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }

  /// Validate required field
  /// Returns null if valid, error message if invalid
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate phone number (optional, basic validation)
  /// Returns null if valid or empty, error message if invalid format
  static String? validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) {
      return null; // Phone is optional
    }

    final trimmedPhone = phone.trim();

    // Basic phone validation: at least 10 digits
    final digitsOnly = trimmedPhone.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length < 10) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  /// Sanitize input by trimming whitespace
  /// Removes leading and trailing whitespace
  static String sanitizeInput(String input) {
    return input.trim();
  }

  /// Sanitize email by converting to lowercase and trimming
  static String sanitizeEmail(String email) {
    return email.trim().toLowerCase();
  }

  /// Check if string contains only whitespace
  static bool isWhitespaceOnly(String? value) {
    if (value == null) return true;
    return value.trim().isEmpty;
  }

  /// Validate name field (letters, spaces, hyphens only)
  /// Returns null if valid, error message if invalid
  static String? validateName(String? name, String fieldName) {
    if (name == null || name.trim().isEmpty) {
      return '$fieldName is required';
    }

    final trimmedName = name.trim();

    if (trimmedName.length < 2) {
      return '$fieldName must be at least 2 characters';
    }

    // Allow letters, spaces, hyphens, and accented characters
    final nameRegex = RegExp(r'^[a-zA-ZÀ-ÿ\s\-]+$');
    if (!nameRegex.hasMatch(trimmedName)) {
      return '$fieldName can only contain letters, spaces, and hyphens';
    }

    return null;
  }

  /// Validate number of guests (positive integer)
  /// Returns null if valid, error message if invalid
  static String? validateGuestCount(String? count) {
    if (count == null || count.isEmpty) {
      return 'Number of guests is required';
    }

    final number = int.tryParse(count);

    if (number == null) {
      return 'Please enter a valid number';
    }

    if (number <= 0) {
      return 'Number of guests must be at least 1';
    }

    return null;
  }
}
