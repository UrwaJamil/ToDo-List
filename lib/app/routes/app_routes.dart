// Route names are upper-case constants as required by the lab specification.
// ignore_for_file: constant_identifier_names

/// Named route constants. Navigation always uses these, never raw strings.
abstract class Routes {
  Routes._();

  static const SPLASH = '/';
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const FORGOT_PASSWORD = '/forgot-password';

  /// Bottom-navigation shell: Home, Calendar and Profile tabs.
  static const MAIN = '/main';
  static const ADD_TASK = '/add-task';
  static const EDIT_TASK = '/edit-task';
  static const TASK_DETAILS = '/task-details';
}
