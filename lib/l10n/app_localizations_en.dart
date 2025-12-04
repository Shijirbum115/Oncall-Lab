// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInToContinue => 'Sign in to continue';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get phoneNumberHint => '99123456';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get passwordResetComingSoon => 'Password reset coming soon!';

  @override
  String get signIn => 'Sign In';

  @override
  String get or => 'OR';

  @override
  String get registerAsPatient => 'Register as Patient';

  @override
  String get registerAsDoctor => 'Register as Doctor';

  @override
  String get pleaseEnterPhoneNumber => 'Please enter your phone number';

  @override
  String get enterValidPhoneNumber => 'Enter 8 digit number (e.g. 99123456)';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get signOut => 'Sign Out';

  @override
  String get patientRegistration => 'Patient Registration';

  @override
  String get doctorRegistration => 'Doctor Registration';

  @override
  String get createPatientAccount => 'Create Patient Account';

  @override
  String get createDoctorAccount => 'Create Doctor Account';

  @override
  String get patientAccountCreated => 'Patient account created successfully!';

  @override
  String get doctorAccountCreated => 'Doctor account created successfully!';

  @override
  String get stepByStepOnboarding =>
      'Step-by-step onboarding for a smoother experience.';

  @override
  String get basics => 'Basics';

  @override
  String get security => 'Security';

  @override
  String get createAccount => 'Create Account';

  @override
  String get continue_ => 'Continue';

  @override
  String get alreadyHaveAccountSignIn => 'Already have an account? Sign in';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get email => 'Email';

  @override
  String get emailOptional => 'Email (optional)';

  @override
  String get age => 'Age';

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get other => 'Other';

  @override
  String get permanentAddress => 'Permanent Address';

  @override
  String get registrationNumber => 'Registration Number';

  @override
  String get mongolianCitizen => 'Mongolian Citizen';

  @override
  String get foreignCitizen => 'Foreign Citizen';

  @override
  String get passportNumber => 'Passport Number';

  @override
  String get allergies => 'Allergies (medications, injections, etc.)';

  @override
  String get allergiesOptional => 'Allergies (optional)';

  @override
  String get profilePhotoOptional => 'Profile photo (optional)';

  @override
  String get uploadProfilePhoto => 'Upload profile photo';

  @override
  String get changePhoto => 'Change photo';

  @override
  String get profession => 'Profession/Specialty';

  @override
  String get licenseNumber => 'License Number';

  @override
  String get academicDegree => 'Academic Degree';

  @override
  String get workExperience => 'Work Experience (years)';

  @override
  String get professionalDevelopment => 'Professional Development';

  @override
  String get register => 'Register';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordsMustMatch => 'Passwords must match';

  @override
  String get home => 'Home';

  @override
  String get services => 'Services';

  @override
  String get requests => 'Requests';

  @override
  String get profile => 'Profile';

  @override
  String get labServices => 'Lab Services';

  @override
  String get directServices => 'Direct Services';

  @override
  String get laboratories => 'Laboratories';

  @override
  String get findLabTests => 'Find Lab Tests';

  @override
  String get bookDiagnostics => 'Book Diagnostics & Nursing';

  @override
  String get viewAll => 'View All';

  @override
  String get search => 'Search';

  @override
  String get searchServices => 'Search services...';

  @override
  String get searchDoctors => 'Search doctors...';

  @override
  String get clinicVisit => 'Clinic visit';

  @override
  String get makeAnAppointment => 'Make an appointment';

  @override
  String get homeVisit => 'Home visit';

  @override
  String get callTheDoctorHome => 'Call the doctor home';

  @override
  String get availableTests => 'Available Tests';

  @override
  String get welcome => 'Welcome';

  @override
  String get errorLoadingData => 'Error loading data';

  @override
  String get retry => 'Retry';

  @override
  String get serviceCategories => 'Service Categories';

  @override
  String get labTest => 'Lab Test';

  @override
  String get diagnosticProcedure => 'Diagnostic Procedure';

  @override
  String get nursingCare => 'Nursing Care';

  @override
  String get price => 'Price';

  @override
  String priceInMNT(int price) {
    return '$price MNT';
  }

  @override
  String get estimatedDuration => 'Estimated Duration';

  @override
  String durationMinutes(int minutes) {
    return '$minutes minutes';
  }

  @override
  String durationHours(int hours) {
    return '$hours hours';
  }

  @override
  String get preparationInstructions => 'Preparation Instructions';

  @override
  String get sampleType => 'Sample Type';

  @override
  String get equipmentNeeded => 'Equipment Needed';

  @override
  String get bookNow => 'Book Now';

  @override
  String get laboratoryTestsTitle => 'Laboratory Tests';

  @override
  String get searchTests => 'Search for tests...';

  @override
  String get singleTestAvailable => '1 test available';

  @override
  String testsAvailable(int count) {
    return '$count tests available';
  }

  @override
  String get errorLoadingServices => 'Error loading services';

  @override
  String get noServicesAvailable => 'No services available';

  @override
  String get noResultsFound => 'No results found';

  @override
  String get noServicesMatchSearch => 'No services match your search';

  @override
  String get pleaseTryAgainLater => 'Please try again later';

  @override
  String get tryDifferentKeywords => 'Try searching with different keywords';

  @override
  String get preparationRequired => 'Preparation required';

  @override
  String get allLaboratories => 'All Laboratories';

  @override
  String get laboratoryDetails => 'Laboratory Details';

  @override
  String get address => 'Address';

  @override
  String get phoneContact => 'Phone Contact';

  @override
  String get operatingHours => 'Operating Hours';

  @override
  String get unableToLoadLaboratories => 'Unable to load laboratories';

  @override
  String get noLaboratoriesAvailable => 'No laboratories available right now';

  @override
  String get searchLaboratories => 'Search laboratories...';

  @override
  String noLaboratoriesMatchQuery(String query) {
    return 'No laboratories match \"$query\".';
  }

  @override
  String get laboratoryFallback => 'Laboratory';

  @override
  String get addressNotProvided => 'Address not provided';

  @override
  String get addressNotAvailable => 'Address not available';

  @override
  String get notSpecified => 'Not specified';

  @override
  String get coordinates => 'Coordinates';

  @override
  String get acceptingRequests => 'Accepting requests';

  @override
  String get temporarilyUnavailable => 'Temporarily unavailable';

  @override
  String get availableServices => 'Available Services';

  @override
  String servicesCount(int count) {
    return '$count services';
  }

  @override
  String get availableDoctors => 'Available Doctors';

  @override
  String get noDoctorsAvailable => 'No doctors available at the moment';

  @override
  String get doctorDetails => 'Doctor Details';

  @override
  String get rating => 'Rating';

  @override
  String get experience => 'Experience';

  @override
  String yearsExperience(int years) {
    return '$years years';
  }

  @override
  String get completedRequests => 'Completed Requests';

  @override
  String get totalReviews => 'Total Reviews';

  @override
  String reviewsCount(int count) {
    return '$count reviews';
  }

  @override
  String get available => 'Available';

  @override
  String get unavailable => 'Unavailable';

  @override
  String get bio => 'Bio';

  @override
  String get certifications => 'Certifications';

  @override
  String get directDoctorServices => 'Direct Doctor Services';

  @override
  String get bookService => 'Book Service';

  @override
  String get selectDate => 'Select Date';

  @override
  String get selectTime => 'Select Time';

  @override
  String get selectTimeSlot => 'Select Time Slot';

  @override
  String get selectDoctor => 'Select Doctor';

  @override
  String get anyAvailableDoctor => 'Any Available Doctor';

  @override
  String get yourAddress => 'Your Address';

  @override
  String get addressHint => 'Enter your full address';

  @override
  String get collectionAddress => 'Collection Address';

  @override
  String get typeDifferentAddress => 'Type a different address';

  @override
  String get useSavedAddress => 'Use saved address';

  @override
  String get additionalNotes => 'Additional Notes';

  @override
  String get additionalNotesOptional => 'Additional Notes (optional)';

  @override
  String get notesHint => 'Any special instructions or requirements';

  @override
  String get specialInstructionsHint => 'Any special instructions...';

  @override
  String get confirmBooking => 'Confirm Booking';

  @override
  String get requestSubmitted => 'Request submitted successfully!';

  @override
  String get bookingSummary => 'Booking Summary';

  @override
  String get service => 'Service';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get doctor => 'Doctor';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get confirm => 'Confirm';

  @override
  String resultsReadyHours(int hours) {
    return '~${hours}h for results';
  }

  @override
  String get myRequests => 'My Requests';

  @override
  String get pendingRequests => 'Pending Requests';

  @override
  String get activeRequests => 'Active Requests';

  @override
  String get requestHistory => 'Request History';

  @override
  String get requestDetails => 'Request Details';

  @override
  String get requestId => 'Request ID';

  @override
  String get patient => 'Patient';

  @override
  String get patientInfo => 'Patient Information';

  @override
  String get patientAddress => 'Patient Address';

  @override
  String get patientNotes => 'Patient Notes';

  @override
  String get scheduledFor => 'Scheduled For';

  @override
  String get createdAt => 'Created At';

  @override
  String get status => 'Status';

  @override
  String get acceptRequest => 'Accept Request';

  @override
  String get rejectRequest => 'Reject Request';

  @override
  String get updateStatus => 'Update Status';

  @override
  String get cancelRequest => 'Cancel Request';

  @override
  String get cancellationReason => 'Cancellation Reason';

  @override
  String get reasonHint => 'Please provide a reason';

  @override
  String get noActiveRequests => 'No active requests';

  @override
  String get noCompletedRequests => 'No completed requests';

  @override
  String get noCancelledRequests => 'No cancelled requests';

  @override
  String get requestHomeServicePrompt =>
      'Request a home service to get started';

  @override
  String get labTestServiceLabel => 'Lab Test Service';

  @override
  String get directHomeServiceLabel => 'Direct Home Service';

  @override
  String scheduledAt(String date, String time) {
    return 'Scheduled: $date $time';
  }

  @override
  String get labTestCollection => 'Lab Test Collection';

  @override
  String get homeServiceRequest => 'Home Service Request';

  @override
  String get pending => 'Pending';

  @override
  String get accepted => 'Accepted';

  @override
  String get onTheWay => 'On the Way';

  @override
  String get sampleCollected => 'Sample Collected';

  @override
  String get deliveredToLab => 'Delivered to Lab';

  @override
  String get completed => 'Completed';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get myProfile => 'My Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get contactInformation => 'Contact Information';

  @override
  String get medicalInformation => 'Medical Information';

  @override
  String get professionalInformation => 'Professional Information';

  @override
  String get changeAvatar => 'Change Avatar';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get uploadingAvatar => 'Uploading avatar...';

  @override
  String get updatingProfile => 'Updating profile...';

  @override
  String get user => 'User';

  @override
  String get noPhoneNumber => 'No phone number';

  @override
  String get changeProfilePhoto => 'Change profile photo';

  @override
  String get changeProfilePhotoConfirm =>
      'Do you want to change your profile photo?';

  @override
  String get change => 'Change';

  @override
  String get useThisPhoto => 'Use this photo?';

  @override
  String get profilePhotoPreview => 'This is how your profile photo will look.';

  @override
  String get profilePhotoUpdated => 'Profile photo updated';

  @override
  String get failedToUpdatePhoto => 'Failed to update photo';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully';

  @override
  String get savedAddresses => 'Saved addresses';

  @override
  String get editAddress => 'Edit address';

  @override
  String get addAddress => 'Add address';

  @override
  String get newAddress => 'New address';

  @override
  String get saveAddress => 'Save address';

  @override
  String get removeAddress => 'Remove address';

  @override
  String get noDefaultAddressSaved => 'No default address saved';

  @override
  String get addressSaved => 'Address saved';

  @override
  String get savedAddressRemoved => 'Saved address removed';

  @override
  String get pleaseEnterAddress => 'Please enter your address';

  @override
  String get statistics => 'Statistics';

  @override
  String get totalRequests => 'Total Requests';

  @override
  String get completedCount => 'Completed';

  @override
  String get pendingCount => 'Pending';

  @override
  String get cancelledCount => 'Cancelled';

  @override
  String get inProgressCount => 'In Progress';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get warning => 'Warning';

  @override
  String get info => 'Info';

  @override
  String get loading => 'Loading...';

  @override
  String get noData => 'No data available';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get done => 'Done';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get view => 'View';

  @override
  String get filter => 'Filter';

  @override
  String get sort => 'Sort';

  @override
  String get refresh => 'Refresh';

  @override
  String get required => 'Required';

  @override
  String get adminPanel => 'Admin Panel';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get users => 'Users';

  @override
  String get patients => 'Patients';

  @override
  String get doctors => 'Doctors';

  @override
  String get allRequests => 'All Requests';

  @override
  String get systemSettings => 'System Settings';

  @override
  String get adminComingSoon => 'Admin experience coming soon!';

  @override
  String get adminDescription =>
      'We are finalizing the dedicated dashboard for this role. Please check back later or sign out to switch accounts.';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get markAsRead => 'Mark as read';

  @override
  String get markAllAsRead => 'Mark all as read';

  @override
  String get clearAll => 'Clear all';

  @override
  String get invalidCredentials => 'Invalid phone number or password';

  @override
  String get phoneAlreadyRegistered =>
      'This phone number is already registered';

  @override
  String get rateLimitExceeded => 'Too many attempts. Please try again later';

  @override
  String get networkError => 'Network error. Please check your connection';

  @override
  String get unknownError => 'An unknown error occurred';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get invalidEmail => 'Please enter a valid email';

  @override
  String get invalidPhoneNumber => 'Please enter a valid phone number';

  @override
  String get invalidAge => 'Please enter a valid age';

  @override
  String mustBeAtLeast(int min) {
    return 'Must be at least $min';
  }

  @override
  String mustBeAtMost(int max) {
    return 'Must be at most $max';
  }
}
