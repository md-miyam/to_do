class Urls {
  // static const String baseUrl =
  //     'https://skilly-server-7zcwn7tfb-nabilsiddik70-1653s-projects.vercel.app/api/v1';
  static const String baseUrl = 'https://skilly-server.vercel.app/api/v1';
  // auth
  static const String login = '$baseUrl/auth/login';
  static const String signUp = '$baseUrl/users';
  static const String verifyOTP = '$baseUrl/auth/verify-otp';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String resetPassword = '$baseUrl/auth/reset-password';
  static const String changePassword = '$baseUrl/auth/change-password';
  static const String logout = '$baseUrl/auth/logout';
  static const String resendOtp = '$baseUrl/auth/resend-otp';
  static const String getProfile = '$baseUrl/auth/profile';
  static const String updateProfile = '$baseUrl/users/profile';

  // top professionals
  static const String topProfessionals = '$baseUrl/users/top-professionals';
  static const String getProfessionalDetails = '$baseUrl/users/professional';

  // business profile
  static const String getBusinessProfile = '$baseUrl/users/business-profile';
  //shifts
  static const String createShift = '$baseUrl/shift';

  // notifications
  static const String getAllNotifications = '$baseUrl/notifications/all-noti';

  // reviews
  static const String getProfessionalReviews = '$baseUrl/review/professional';

  //leaderboard
  static const String getLeaderboard = '$baseUrl/admin/leaderboard';
  static const String getUserLeaderboardProfile = '$baseUrl/users/professional';

  //web socket
  static const String socketUrl = 'wss://p7vl5x44-5000.use.devtunnels.ms';

  // Shift Management
  static const String getMyShifts = '$baseUrl/shift/my-shift';
  static const String getShifts = '$baseUrl/shift';
  static String getShiftDetails(String id) => '$baseUrl/shift/$id';
  static String checkInShift(String id) => '$baseUrl/shift/$id/check-in';
  static String checkOutShift(String id) => '$baseUrl/shift/$id/check-out';
  static String cancelShift(String id) => '$baseUrl/shift/$id/cancel';
  static String applyForShift(String id) => '$baseUrl/shift/$id/apply';

  static String acceptApplication(String id) => '$baseUrl/shift/applications/$id/accept';
  static String rejectApplication(String id) => '$baseUrl/shift/applications/$id/reject';
  static String acceptRejectInvitation(String applicationId) => '$baseUrl/shift/respond-invite/$applicationId';

  static String updateShift(String id) => '$baseUrl/shift/$id';

  static String inviteToShift(String professionalId) =>
      '$baseUrl/shift/invite-professional/$professionalId';

  // Business Analytics
  static String getBusinessAnalytics(String filter) =>
      '$baseUrl/users/business/analytics?filter=$filter';

  // Review submit
  static const String submitReview = '$baseUrl/review';

  // Send payment otp
  static String sentPaymentOtp(String shiftId) => '$baseUrl/shift/payment-otp/$shiftId';  
  // Verify payment otp
  static String verifyPaymentOtp(String shiftId) => '$baseUrl/shift/verify-payment/$shiftId';
}
