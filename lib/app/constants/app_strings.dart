/// Every user-facing piece of text. Views never contain string literals.
class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'My To-Do';
  static const String appTagline = 'Organize your day, one task at a time';
  static const String loading = 'Loading...';

  // Auth screens
  static const String welcomeBack = 'Welcome back';
  static const String loginSubtitle = 'Log in to continue';
  static const String createAccount = 'Create account';
  static const String signupSubtitle = 'Start managing your tasks';
  static const String nameLabel = 'Full Name';
  static const String nameHint = 'Enter your full name';
  static const String emailLabel = 'Email';
  static const String emailHint = 'Enter your email';
  static const String passwordLabel = 'Password';
  static const String passwordHint = 'Enter your password';
  static const String confirmPasswordLabel = 'Confirm Password';
  static const String confirmPasswordHint = 'Re-enter your password';
  static const String login = 'Log In';
  static const String signUp = 'Sign Up';
  static const String noAccount = "Don't have an account?";
  static const String haveAccount = 'Already have an account?';
  static const String logout = 'Logout';
  static const String logoutMessage = 'Are you sure you want to log out?';

  // Forgot password
  static const String forgotPassword = 'Forgot password?';
  static const String resetPasswordTitle = 'Reset password';
  static const String resetPasswordSubtitle =
      "Enter your email and we'll send you a reset link";
  static const String sendResetLink = 'Send reset link';
  static const String resetLinkSent =
      'If an account exists for this email, a password reset link has been '
      'sent. Check your inbox and spam folder.';
  static const String backToLogin = 'Back to Login';
  static const String rememberPassword = 'Remember your password?';

  // Email availability (Sign-Up)
  static const String emailAvailable = 'Email is available';
  static const String emailTaken = 'This email is already registered';

  // Password requirements (Sign-Up)
  static const String ruleMinLength = 'At least 8 characters';
  static const String ruleLetter = 'At least 1 letter';
  static const String ruleDigit = 'At least 1 number';

  // Validation
  static const String nameRequired = 'Please enter your name';
  static const String nameTooShort = 'Name must be at least 2 characters';
  static const String emailRequired = 'Please enter your email';
  static const String emailInvalid = 'Please enter a valid email address';
  static const String passwordRequired = 'Please enter your password';
  static const String passwordTooWeak =
      'Password must be at least 8 characters with 1 letter and 1 number';
  static const String confirmPasswordRequired = 'Please confirm your password';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String titleRequired = 'Please enter a task title';
  static const String titleTooLong = 'Title must be 100 characters or less';
  static const String dueDateRequired = 'Please select a due date';

  // Snackbar titles & messages
  static const String success = 'Success';
  static const String error = 'Error';
  static const String loginSuccess = 'Logged in successfully';
  static const String signupSuccess = 'Account created successfully';
  static const String logoutSuccess = 'You have been logged out';
  static const String taskAdded = 'Task added successfully';
  static const String taskUpdated = 'Task updated successfully';
  static const String taskDeleted = 'Task deleted successfully';
  static const String taskMarkedCompleted = 'Task marked as completed';
  static const String taskMarkedPending = 'Task marked as pending';

  // Error messages
  static const String errorInvalidEmail = 'The email address is not valid.';
  static const String errorUserDisabled = 'This account has been disabled.';
  static const String errorUserNotFound = 'No account found with this email.';
  static const String errorWrongPassword =
      'Incorrect password. Please try again.';
  static const String errorInvalidCredential = 'Invalid email or password.';
  static const String errorEmailInUse =
      'An account already exists with this email.';
  static const String errorWeakPassword =
      'The password is too weak. Use at least 8 characters with 1 letter '
      'and 1 number.';
  static const String errorTooManyRequests =
      'Too many attempts. Please try again later.';
  static const String errorNetwork =
      'Network error. Please check your internet connection.';
  static const String errorOperationNotAllowed =
      'Email/password sign-in is not enabled for this project.';
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNotLoggedIn = 'You must be logged in to do this.';
  static const String errorLoadTasks = 'Could not load your tasks.';
  static const String errorSaveTask = 'Could not save the task.';
  static const String errorUpdateTask = 'Could not update the task.';
  static const String errorDeleteTask = 'Could not delete the task.';

  // Bottom navigation
  static const String navHome = 'Home';
  static const String navCalendar = 'Calendar';
  static const String navProfile = 'Profile';

  // Calendar
  static const String calendarTitle = 'Calendar';
  static const String calendarSubtitle = 'Your tasks by due date';
  static const String previousMonth = 'Previous month';
  static const String nextMonth = 'Next month';
  static const String noTasksOnDayTitle = 'Nothing due';
  static const String noTasksOnDayMessage = 'No tasks are due on this day.';

  static String tasksOnDay(String day) => 'Due $day';

  // Home
  static const String myTasks = 'My Tasks';
  static const String total = 'Total';
  static const String completed = 'Completed';
  static const String pending = 'Pending';
  static const String searchHint = 'Search tasks by title...';
  static const String filterAll = 'All';
  static const String sortPriority = 'Priority';
  static const String sortDueDate = 'Due Date';
  static const String addTask = 'Add Task';
  static const String noTasksTitle = 'No tasks yet';
  static const String noTasksMessage =
      'Tap "Add Task" below to create your first task.';
  static const String noResultsTitle = 'No matching tasks';
  static const String noResultsMessage = 'Try a different search or filter.';
  static const String errorTitle = 'Oops!';
  static const String retry = 'Retry';
  static const String overdue = 'Overdue';

  static const String goodMorning = 'Good morning 👋';
  static const String goodAfternoon = 'Good afternoon 👋';
  static const String goodEvening = 'Good evening 👋';
  static const String guestName = 'Friend';
  static const String sortTasks = 'Sort tasks';

  static String sortBy(String option) => 'Sort by $option';

  // Add / Edit task
  static const String editTask = 'Edit Task';
  static const String taskTitleLabel = 'Title';
  static const String taskTitleHint = 'What do you need to do?';
  static const String descriptionLabel = 'Description';
  static const String descriptionHint = 'Add some details (optional)';
  static const String dueDateLabel = 'Due Date';
  static const String dueDateHint = 'Select a due date';
  static const String priorityLabel = 'Priority';
  static const String saveTask = 'Save Task';
  static const String updateTask = 'Update Task';
  static const String priorityLow = 'Low';
  static const String priorityMedium = 'Medium';
  static const String priorityHigh = 'High';

  // Task details
  static const String taskDetails = 'Task Details';
  static const String noDescription = 'No description provided.';
  static const String createdAt = 'Created';
  static const String updatedAt = 'Last Updated';
  static const String markCompleted = 'Mark as Completed';
  static const String markPending = 'Mark as Pending';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String cancel = 'Cancel';
  static const String deleteTaskTitle = 'Delete Task';

  static String deleteTaskMessage(String title) =>
      'Are you sure you want to delete "$title"? This cannot be undone.';

  static const String taskNotFound = 'This task no longer exists.';

  // Reminders (notifications)
  static const String reminderChannelName = 'Task Reminders';
  static const String reminderChannelDescription =
      'Reminds you one day before a task is due';
  static const String reminderTitle = 'Task due tomorrow';
  static const String reminderLabel = 'Reminder';
  static const String noReminder = 'No reminder';
  static const String reminderSentNow = 'Sent right away (due within a day)';

  static String reminderBody(String title, String dueDate) =>
      '$title • Due $dueDate';
}
