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

  @override
  String get payment => 'Payment';

  @override
  String get orderSummary => 'Order Summary';

  @override
  String get qpayIntegrationComingSoon =>
      'QPay integration coming soon! For now, this is a demo payment flow.';

  @override
  String get payNow => 'Pay Now';

  @override
  String get paymentSuccessful => 'Payment Successful!';

  @override
  String get bookingConfirmed =>
      'Your booking has been confirmed. A doctor will be assigned to your request soon.';

  @override
  String get amountPaid => 'Amount Paid';

  @override
  String get laboratory => 'Laboratory';

  @override
  String get viewBookingDetails => 'View Booking Details';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get bookingConfirmation => 'Booking Confirmation';

  @override
  String get creatingYourBooking => 'Creating Your Booking';

  @override
  String get pleaseWait => 'Please wait a moment...';

  @override
  String get bookingID => 'Booking ID';

  @override
  String get bookingDetails => 'Booking Details';

  @override
  String get amount => 'Amount';

  @override
  String get doctorWillAcceptSoon =>
      'Your request is pending. A doctor will accept and process your request soon. You\'ll receive a notification once it\'s accepted.';

  @override
  String get notificationDetails => 'Notification Details';

  @override
  String get additionalInfo => 'Additional Information';

  @override
  String get viewRequest => 'View Request';

  @override
  String get goBack => 'Go Back';

  @override
  String get yearsExp => 'Years Exp.';

  @override
  String get reviews => 'Reviews';

  @override
  String get about => 'About';

  @override
  String get showLess => 'Show less';

  @override
  String get readMore => 'Read more';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get workingHours => 'Working Hours';

  @override
  String get closed => 'Closed';

  @override
  String get bookAppointment => 'Book Appointment';

  @override
  String get errorLoadingDoctorDetails => 'Error Loading Doctor Details';

  @override
  String get doctorProfileNotFound =>
      'Doctor profile not found. This doctor may not be available anymore.';

  @override
  String get notifRequestCreated => 'New Request Created';

  @override
  String get notifRequestAccepted => 'Request Accepted';

  @override
  String get notifRequestUpdated => 'Request Updated';

  @override
  String get notifStatusChanged => 'Status Changed';

  @override
  String get notifSystemAlert => 'System Alert';

  @override
  String notifDoctorAccepted(Object doctorName) {
    return '$doctorName has accepted your test request.';
  }

  @override
  String get notifDoctorOnTheWay => 'Doctor On The Way';

  @override
  String notifDoctorOnTheWayMsg(Object doctorName) {
    return 'Dr. $doctorName is on the way to your location.';
  }

  @override
  String get notifSampleCollected => 'Sample Collected';

  @override
  String get notifSampleCollectedMsg =>
      'Your sample has been collected successfully.';

  @override
  String get notifDeliveredToLab => 'Sample Delivered to Lab';

  @override
  String get notifDeliveredToLabMsg =>
      'Your sample has been delivered to the laboratory for testing.';

  @override
  String get notifTestCompleted => 'Test Completed';

  @override
  String get notifTestCompletedMsg => 'Your test results are now ready.';

  @override
  String get notifRequestCancelled => 'Request Cancelled';

  @override
  String get notifRequestCancelledMsg => 'The test request has been cancelled.';

  @override
  String get login => 'Login';

  @override
  String get healthcareAtYourDoorstep => 'Healthcare at your doorstep';

  @override
  String appVersion(String version) {
    return 'v$version';
  }

  @override
  String get joinAsDoctorLabTech => 'Join as Doctor / Lab Technician';

  @override
  String get provideAccurateDetails =>
      'Provide accurate details to pass verification.';

  @override
  String get profileStep => 'Profile';

  @override
  String get professionalStep => 'Professional';

  @override
  String get securityStep => 'Security';

  @override
  String get submitApplication => 'Submit Application';

  @override
  String get doctorApplicationSubmitted =>
      'Doctor application submitted! We will verify your credentials soon.';

  @override
  String get firstNameRequired => 'First name *';

  @override
  String get lastNameRequired => 'Last name *';

  @override
  String get phoneNumberRequired => 'Phone number *';

  @override
  String get professionRequired => 'Profession *';

  @override
  String get licenseNumberRequired => 'License number *';

  @override
  String get academicDegreeOptional => 'Academic degree (optional)';

  @override
  String get yearsOfExperience => 'Years of experience';

  @override
  String get professionalDevelopmentOptional =>
      'Professional development (optional)';

  @override
  String get passwordRequired => 'Password *';

  @override
  String get confirmPasswordRequired => 'Confirm password *';

  @override
  String get alreadyRegisteredSignIn => 'Already registered? Sign in';

  @override
  String get myDashboard => 'My Dashboard';

  @override
  String get availableTab => 'Available';

  @override
  String get myRequestsTab => 'My Requests';

  @override
  String get completedTab => 'Completed';

  @override
  String get noAvailableRequests => 'No available requests';

  @override
  String get newRequestsWillAppear => 'New requests will appear here';

  @override
  String get acceptRequestToStart => 'Accept a request to get started';

  @override
  String get completedRequestsWillAppear =>
      'Your completed requests will appear here';

  @override
  String get requestAcceptedSuccess => 'Request accepted successfully!';

  @override
  String get accept => 'Accept';

  @override
  String get scheduled => 'Scheduled';

  @override
  String priceMnt(int price) {
    return 'Price: $price MNT';
  }

  @override
  String statusUpdatedTo(String status) {
    return 'Status updated to $status';
  }

  @override
  String get failedToUpdateStatus => 'Failed to update status';

  @override
  String get requestCancelled => 'Request cancelled';

  @override
  String get collectSample => 'Collect Sample';

  @override
  String get deliverToLab => 'Deliver to Lab';

  @override
  String get completeRequest => 'Complete Request';

  @override
  String get requestType => 'Request Type';

  @override
  String get type => 'Type';

  @override
  String get schedule => 'Schedule';

  @override
  String get timeSlot => 'Time Slot';

  @override
  String get location => 'Location';

  @override
  String get provideCancellationReason =>
      'Please provide a reason for cancellation:';

  @override
  String get enterReason => 'Enter reason...';

  @override
  String get entrance => 'Entrance';

  @override
  String get floor => 'Floor';

  @override
  String get apartment => 'Apartment';

  @override
  String get doorNumber => 'Door';

  @override
  String entranceLabel(String value) {
    return 'Entrance: $value';
  }

  @override
  String floorLabel(String value) {
    return 'Floor: $value';
  }

  @override
  String apartmentLabel(String value) {
    return 'Apt: $value';
  }

  @override
  String doorLabel(String value) {
    return 'Door: $value';
  }

  @override
  String get selectDoctorOrAnyAvailable =>
      'Please select a doctor or choose \"Any Available Doctor\"';

  @override
  String get selectLocationOnMap => 'Please select your location on the map';

  @override
  String get errorLoadingService => 'Error loading service';

  @override
  String get firstAvailableDoctorWillAccept =>
      'First available doctor will accept your request';

  @override
  String get orChooseSpecificDoctor => 'Or choose a specific doctor:';

  @override
  String get noDoctorsAvailableForService =>
      'No doctors available for this service';

  @override
  String get tapToOpenMapSelectAddress =>
      'Tap to open map and select your address';

  @override
  String get specialInstructionsOrLandmarks =>
      'Any special instructions or landmarks';

  @override
  String get locationPermissionsDenied => 'Location permissions are denied';

  @override
  String get locationPermissionsPermanentlyDenied =>
      'Location permissions are permanently denied';

  @override
  String get failedToGetLocation => 'Failed to get current location';

  @override
  String get pleaseSelectLocationOnMap => 'Please select a location on the map';

  @override
  String get pleaseEnterAnAddress => 'Please enter an address';

  @override
  String get noNotificationsYet => 'No notifications yet';

  @override
  String get justNow => 'Just now';

  @override
  String get areYouSureLogout => 'Are you sure you want to logout?';

  @override
  String failedToUpdatePhotoError(String error) {
    return 'Failed to update photo: $error';
  }

  @override
  String get completedVisits => 'Completed visits';

  @override
  String get canceledVisits => 'Canceled visits';

  @override
  String get noVisitsScheduled => 'No visits scheduled';

  @override
  String get couldNotOpenMap => 'Could not open map';

  @override
  String get errorOpeningMap => 'Error opening map';

  @override
  String get openInMaps => 'Open in Maps';
}
