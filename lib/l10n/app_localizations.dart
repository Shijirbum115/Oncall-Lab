import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_mn.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('mn'),
  ];

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @phoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'99123456'**
  String get phoneNumberHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @passwordResetComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Password reset coming soon!'**
  String get passwordResetComingSoon;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @registerAsPatient.
  ///
  /// In en, this message translates to:
  /// **'Register as Patient'**
  String get registerAsPatient;

  /// No description provided for @registerAsDoctor.
  ///
  /// In en, this message translates to:
  /// **'Register as Doctor'**
  String get registerAsDoctor;

  /// No description provided for @pleaseEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterPhoneNumber;

  /// No description provided for @enterValidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter 8 digit number (e.g. 99123456)'**
  String get enterValidPhoneNumber;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @patientRegistration.
  ///
  /// In en, this message translates to:
  /// **'Patient Registration'**
  String get patientRegistration;

  /// No description provided for @doctorRegistration.
  ///
  /// In en, this message translates to:
  /// **'Doctor Registration'**
  String get doctorRegistration;

  /// No description provided for @createPatientAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Patient Account'**
  String get createPatientAccount;

  /// No description provided for @createDoctorAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Doctor Account'**
  String get createDoctorAccount;

  /// No description provided for @patientAccountCreated.
  ///
  /// In en, this message translates to:
  /// **'Patient account created successfully!'**
  String get patientAccountCreated;

  /// No description provided for @doctorAccountCreated.
  ///
  /// In en, this message translates to:
  /// **'Doctor account created successfully!'**
  String get doctorAccountCreated;

  /// No description provided for @stepByStepOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Step-by-step onboarding for a smoother experience.'**
  String get stepByStepOnboarding;

  /// No description provided for @basics.
  ///
  /// In en, this message translates to:
  /// **'Basics'**
  String get basics;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @continue_.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_;

  /// No description provided for @alreadyHaveAccountSignIn.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get alreadyHaveAccountSignIn;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailOptional.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get emailOptional;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @permanentAddress.
  ///
  /// In en, this message translates to:
  /// **'Permanent Address'**
  String get permanentAddress;

  /// No description provided for @registrationNumber.
  ///
  /// In en, this message translates to:
  /// **'Registration Number'**
  String get registrationNumber;

  /// No description provided for @mongolianCitizen.
  ///
  /// In en, this message translates to:
  /// **'Mongolian Citizen'**
  String get mongolianCitizen;

  /// No description provided for @foreignCitizen.
  ///
  /// In en, this message translates to:
  /// **'Foreign Citizen'**
  String get foreignCitizen;

  /// No description provided for @passportNumber.
  ///
  /// In en, this message translates to:
  /// **'Passport Number'**
  String get passportNumber;

  /// No description provided for @allergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies (medications, injections, etc.)'**
  String get allergies;

  /// No description provided for @allergiesOptional.
  ///
  /// In en, this message translates to:
  /// **'Allergies (optional)'**
  String get allergiesOptional;

  /// No description provided for @profilePhotoOptional.
  ///
  /// In en, this message translates to:
  /// **'Profile photo (optional)'**
  String get profilePhotoOptional;

  /// No description provided for @uploadProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload profile photo'**
  String get uploadProfilePhoto;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get changePhoto;

  /// No description provided for @profession.
  ///
  /// In en, this message translates to:
  /// **'Profession/Specialty'**
  String get profession;

  /// No description provided for @licenseNumber.
  ///
  /// In en, this message translates to:
  /// **'License Number'**
  String get licenseNumber;

  /// No description provided for @academicDegree.
  ///
  /// In en, this message translates to:
  /// **'Academic Degree'**
  String get academicDegree;

  /// No description provided for @workExperience.
  ///
  /// In en, this message translates to:
  /// **'Work Experience (years)'**
  String get workExperience;

  /// No description provided for @professionalDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Professional Development'**
  String get professionalDevelopment;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @passwordsMustMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords must match'**
  String get passwordsMustMatch;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @requests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requests;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @labServices.
  ///
  /// In en, this message translates to:
  /// **'Lab Services'**
  String get labServices;

  /// No description provided for @directServices.
  ///
  /// In en, this message translates to:
  /// **'Direct Services'**
  String get directServices;

  /// No description provided for @laboratories.
  ///
  /// In en, this message translates to:
  /// **'Laboratories'**
  String get laboratories;

  /// No description provided for @findLabTests.
  ///
  /// In en, this message translates to:
  /// **'Find Lab Tests'**
  String get findLabTests;

  /// No description provided for @bookDiagnostics.
  ///
  /// In en, this message translates to:
  /// **'Book Diagnostics & Nursing'**
  String get bookDiagnostics;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchServices.
  ///
  /// In en, this message translates to:
  /// **'Search services...'**
  String get searchServices;

  /// No description provided for @searchDoctors.
  ///
  /// In en, this message translates to:
  /// **'Search doctors...'**
  String get searchDoctors;

  /// No description provided for @clinicVisit.
  ///
  /// In en, this message translates to:
  /// **'Clinic visit'**
  String get clinicVisit;

  /// No description provided for @makeAnAppointment.
  ///
  /// In en, this message translates to:
  /// **'Make an appointment'**
  String get makeAnAppointment;

  /// No description provided for @homeVisit.
  ///
  /// In en, this message translates to:
  /// **'Home visit'**
  String get homeVisit;

  /// No description provided for @callTheDoctorHome.
  ///
  /// In en, this message translates to:
  /// **'Call the doctor home'**
  String get callTheDoctorHome;

  /// No description provided for @availableTests.
  ///
  /// In en, this message translates to:
  /// **'Available Tests'**
  String get availableTests;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @errorLoadingData.
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get errorLoadingData;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @serviceCategories.
  ///
  /// In en, this message translates to:
  /// **'Service Categories'**
  String get serviceCategories;

  /// No description provided for @labTest.
  ///
  /// In en, this message translates to:
  /// **'Lab Test'**
  String get labTest;

  /// No description provided for @diagnosticProcedure.
  ///
  /// In en, this message translates to:
  /// **'Diagnostic Procedure'**
  String get diagnosticProcedure;

  /// No description provided for @nursingCare.
  ///
  /// In en, this message translates to:
  /// **'Nursing Care'**
  String get nursingCare;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @priceInMNT.
  ///
  /// In en, this message translates to:
  /// **'{price} MNT'**
  String priceInMNT(int price);

  /// No description provided for @estimatedDuration.
  ///
  /// In en, this message translates to:
  /// **'Estimated Duration'**
  String get estimatedDuration;

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes'**
  String durationMinutes(int minutes);

  /// No description provided for @durationHours.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours'**
  String durationHours(int hours);

  /// No description provided for @preparationInstructions.
  ///
  /// In en, this message translates to:
  /// **'Preparation Instructions'**
  String get preparationInstructions;

  /// No description provided for @sampleType.
  ///
  /// In en, this message translates to:
  /// **'Sample Type'**
  String get sampleType;

  /// No description provided for @equipmentNeeded.
  ///
  /// In en, this message translates to:
  /// **'Equipment Needed'**
  String get equipmentNeeded;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @laboratoryTestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Laboratory Tests'**
  String get laboratoryTestsTitle;

  /// No description provided for @searchTests.
  ///
  /// In en, this message translates to:
  /// **'Search for tests...'**
  String get searchTests;

  /// No description provided for @singleTestAvailable.
  ///
  /// In en, this message translates to:
  /// **'1 test available'**
  String get singleTestAvailable;

  /// No description provided for @testsAvailable.
  ///
  /// In en, this message translates to:
  /// **'{count} tests available'**
  String testsAvailable(int count);

  /// No description provided for @errorLoadingServices.
  ///
  /// In en, this message translates to:
  /// **'Error loading services'**
  String get errorLoadingServices;

  /// No description provided for @noServicesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No services available'**
  String get noServicesAvailable;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @noServicesMatchSearch.
  ///
  /// In en, this message translates to:
  /// **'No services match your search'**
  String get noServicesMatchSearch;

  /// No description provided for @pleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Please try again later'**
  String get pleaseTryAgainLater;

  /// No description provided for @tryDifferentKeywords.
  ///
  /// In en, this message translates to:
  /// **'Try searching with different keywords'**
  String get tryDifferentKeywords;

  /// No description provided for @preparationRequired.
  ///
  /// In en, this message translates to:
  /// **'Preparation required'**
  String get preparationRequired;

  /// No description provided for @allLaboratories.
  ///
  /// In en, this message translates to:
  /// **'All Laboratories'**
  String get allLaboratories;

  /// No description provided for @laboratoryDetails.
  ///
  /// In en, this message translates to:
  /// **'Laboratory Details'**
  String get laboratoryDetails;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @phoneContact.
  ///
  /// In en, this message translates to:
  /// **'Phone Contact'**
  String get phoneContact;

  /// No description provided for @operatingHours.
  ///
  /// In en, this message translates to:
  /// **'Operating Hours'**
  String get operatingHours;

  /// No description provided for @unableToLoadLaboratories.
  ///
  /// In en, this message translates to:
  /// **'Unable to load laboratories'**
  String get unableToLoadLaboratories;

  /// No description provided for @noLaboratoriesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No laboratories available right now'**
  String get noLaboratoriesAvailable;

  /// No description provided for @searchLaboratories.
  ///
  /// In en, this message translates to:
  /// **'Search laboratories...'**
  String get searchLaboratories;

  /// No description provided for @noLaboratoriesMatchQuery.
  ///
  /// In en, this message translates to:
  /// **'No laboratories match \"{query}\".'**
  String noLaboratoriesMatchQuery(String query);

  /// No description provided for @laboratoryFallback.
  ///
  /// In en, this message translates to:
  /// **'Laboratory'**
  String get laboratoryFallback;

  /// No description provided for @addressNotProvided.
  ///
  /// In en, this message translates to:
  /// **'Address not provided'**
  String get addressNotProvided;

  /// No description provided for @addressNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Address not available'**
  String get addressNotAvailable;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @coordinates.
  ///
  /// In en, this message translates to:
  /// **'Coordinates'**
  String get coordinates;

  /// No description provided for @acceptingRequests.
  ///
  /// In en, this message translates to:
  /// **'Accepting requests'**
  String get acceptingRequests;

  /// No description provided for @temporarilyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Temporarily unavailable'**
  String get temporarilyUnavailable;

  /// No description provided for @availableServices.
  ///
  /// In en, this message translates to:
  /// **'Available Services'**
  String get availableServices;

  /// No description provided for @servicesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} services'**
  String servicesCount(int count);

  /// No description provided for @availableDoctors.
  ///
  /// In en, this message translates to:
  /// **'Available Doctors'**
  String get availableDoctors;

  /// No description provided for @noDoctorsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No doctors available at the moment'**
  String get noDoctorsAvailable;

  /// No description provided for @doctorDetails.
  ///
  /// In en, this message translates to:
  /// **'Doctor Details'**
  String get doctorDetails;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @experience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experience;

  /// No description provided for @yearsExperience.
  ///
  /// In en, this message translates to:
  /// **'{years} years'**
  String yearsExperience(int years);

  /// No description provided for @completedRequests.
  ///
  /// In en, this message translates to:
  /// **'Completed Requests'**
  String get completedRequests;

  /// No description provided for @totalReviews.
  ///
  /// In en, this message translates to:
  /// **'Total Reviews'**
  String get totalReviews;

  /// No description provided for @reviewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews'**
  String reviewsCount(int count);

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @certifications.
  ///
  /// In en, this message translates to:
  /// **'Certifications'**
  String get certifications;

  /// No description provided for @directDoctorServices.
  ///
  /// In en, this message translates to:
  /// **'Direct Doctor Services'**
  String get directDoctorServices;

  /// No description provided for @bookService.
  ///
  /// In en, this message translates to:
  /// **'Book Service'**
  String get bookService;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTime;

  /// No description provided for @selectTimeSlot.
  ///
  /// In en, this message translates to:
  /// **'Select Time Slot'**
  String get selectTimeSlot;

  /// No description provided for @selectDoctor.
  ///
  /// In en, this message translates to:
  /// **'Select Doctor'**
  String get selectDoctor;

  /// No description provided for @anyAvailableDoctor.
  ///
  /// In en, this message translates to:
  /// **'Any Available Doctor'**
  String get anyAvailableDoctor;

  /// No description provided for @yourAddress.
  ///
  /// In en, this message translates to:
  /// **'Your Address'**
  String get yourAddress;

  /// No description provided for @addressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full address'**
  String get addressHint;

  /// No description provided for @collectionAddress.
  ///
  /// In en, this message translates to:
  /// **'Collection Address'**
  String get collectionAddress;

  /// No description provided for @typeDifferentAddress.
  ///
  /// In en, this message translates to:
  /// **'Type a different address'**
  String get typeDifferentAddress;

  /// No description provided for @useSavedAddress.
  ///
  /// In en, this message translates to:
  /// **'Use saved address'**
  String get useSavedAddress;

  /// No description provided for @additionalNotes.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes'**
  String get additionalNotes;

  /// No description provided for @additionalNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes (optional)'**
  String get additionalNotesOptional;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Any special instructions or requirements'**
  String get notesHint;

  /// No description provided for @specialInstructionsHint.
  ///
  /// In en, this message translates to:
  /// **'Any special instructions...'**
  String get specialInstructionsHint;

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBooking;

  /// No description provided for @requestSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Request submitted successfully!'**
  String get requestSubmitted;

  /// No description provided for @bookingSummary.
  ///
  /// In en, this message translates to:
  /// **'Booking Summary'**
  String get bookingSummary;

  /// No description provided for @service.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @doctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctor;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @resultsReadyHours.
  ///
  /// In en, this message translates to:
  /// **'~{hours}h for results'**
  String resultsReadyHours(int hours);

  /// No description provided for @myRequests.
  ///
  /// In en, this message translates to:
  /// **'My Requests'**
  String get myRequests;

  /// No description provided for @pendingRequests.
  ///
  /// In en, this message translates to:
  /// **'Pending Requests'**
  String get pendingRequests;

  /// No description provided for @activeRequests.
  ///
  /// In en, this message translates to:
  /// **'Active Requests'**
  String get activeRequests;

  /// No description provided for @requestHistory.
  ///
  /// In en, this message translates to:
  /// **'Request History'**
  String get requestHistory;

  /// No description provided for @requestDetails.
  ///
  /// In en, this message translates to:
  /// **'Request Details'**
  String get requestDetails;

  /// No description provided for @requestId.
  ///
  /// In en, this message translates to:
  /// **'Request ID'**
  String get requestId;

  /// No description provided for @patient.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get patient;

  /// No description provided for @patientInfo.
  ///
  /// In en, this message translates to:
  /// **'Patient Information'**
  String get patientInfo;

  /// No description provided for @patientAddress.
  ///
  /// In en, this message translates to:
  /// **'Patient Address'**
  String get patientAddress;

  /// No description provided for @patientNotes.
  ///
  /// In en, this message translates to:
  /// **'Patient Notes'**
  String get patientNotes;

  /// No description provided for @scheduledFor.
  ///
  /// In en, this message translates to:
  /// **'Scheduled For'**
  String get scheduledFor;

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get createdAt;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @acceptRequest.
  ///
  /// In en, this message translates to:
  /// **'Accept Request'**
  String get acceptRequest;

  /// No description provided for @rejectRequest.
  ///
  /// In en, this message translates to:
  /// **'Reject Request'**
  String get rejectRequest;

  /// No description provided for @updateStatus.
  ///
  /// In en, this message translates to:
  /// **'Update Status'**
  String get updateStatus;

  /// No description provided for @cancelRequest.
  ///
  /// In en, this message translates to:
  /// **'Cancel Request'**
  String get cancelRequest;

  /// No description provided for @cancellationReason.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Reason'**
  String get cancellationReason;

  /// No description provided for @reasonHint.
  ///
  /// In en, this message translates to:
  /// **'Please provide a reason'**
  String get reasonHint;

  /// No description provided for @noActiveRequests.
  ///
  /// In en, this message translates to:
  /// **'No active requests'**
  String get noActiveRequests;

  /// No description provided for @noCompletedRequests.
  ///
  /// In en, this message translates to:
  /// **'No completed requests'**
  String get noCompletedRequests;

  /// No description provided for @noCancelledRequests.
  ///
  /// In en, this message translates to:
  /// **'No cancelled requests'**
  String get noCancelledRequests;

  /// No description provided for @requestHomeServicePrompt.
  ///
  /// In en, this message translates to:
  /// **'Request a home service to get started'**
  String get requestHomeServicePrompt;

  /// No description provided for @labTestServiceLabel.
  ///
  /// In en, this message translates to:
  /// **'Lab Test Service'**
  String get labTestServiceLabel;

  /// No description provided for @directHomeServiceLabel.
  ///
  /// In en, this message translates to:
  /// **'Direct Home Service'**
  String get directHomeServiceLabel;

  /// No description provided for @scheduledAt.
  ///
  /// In en, this message translates to:
  /// **'Scheduled: {date} {time}'**
  String scheduledAt(String date, String time);

  /// No description provided for @labTestCollection.
  ///
  /// In en, this message translates to:
  /// **'Lab Test Collection'**
  String get labTestCollection;

  /// No description provided for @homeServiceRequest.
  ///
  /// In en, this message translates to:
  /// **'Home Service Request'**
  String get homeServiceRequest;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get accepted;

  /// No description provided for @onTheWay.
  ///
  /// In en, this message translates to:
  /// **'On the Way'**
  String get onTheWay;

  /// No description provided for @sampleCollected.
  ///
  /// In en, this message translates to:
  /// **'Sample Collected'**
  String get sampleCollected;

  /// No description provided for @deliveredToLab.
  ///
  /// In en, this message translates to:
  /// **'Delivered to Lab'**
  String get deliveredToLab;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// No description provided for @medicalInformation.
  ///
  /// In en, this message translates to:
  /// **'Medical Information'**
  String get medicalInformation;

  /// No description provided for @professionalInformation.
  ///
  /// In en, this message translates to:
  /// **'Professional Information'**
  String get professionalInformation;

  /// No description provided for @changeAvatar.
  ///
  /// In en, this message translates to:
  /// **'Change Avatar'**
  String get changeAvatar;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @uploadingAvatar.
  ///
  /// In en, this message translates to:
  /// **'Uploading avatar...'**
  String get uploadingAvatar;

  /// No description provided for @updatingProfile.
  ///
  /// In en, this message translates to:
  /// **'Updating profile...'**
  String get updatingProfile;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @noPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'No phone number'**
  String get noPhoneNumber;

  /// No description provided for @changeProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change profile photo'**
  String get changeProfilePhoto;

  /// No description provided for @changeProfilePhotoConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to change your profile photo?'**
  String get changeProfilePhotoConfirm;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @useThisPhoto.
  ///
  /// In en, this message translates to:
  /// **'Use this photo?'**
  String get useThisPhoto;

  /// No description provided for @profilePhotoPreview.
  ///
  /// In en, this message translates to:
  /// **'This is how your profile photo will look.'**
  String get profilePhotoPreview;

  /// No description provided for @profilePhotoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile photo updated'**
  String get profilePhotoUpdated;

  /// No description provided for @failedToUpdatePhoto.
  ///
  /// In en, this message translates to:
  /// **'Failed to update photo'**
  String get failedToUpdatePhoto;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @savedAddresses.
  ///
  /// In en, this message translates to:
  /// **'Saved addresses'**
  String get savedAddresses;

  /// No description provided for @editAddress.
  ///
  /// In en, this message translates to:
  /// **'Edit address'**
  String get editAddress;

  /// No description provided for @addAddress.
  ///
  /// In en, this message translates to:
  /// **'Add address'**
  String get addAddress;

  /// No description provided for @newAddress.
  ///
  /// In en, this message translates to:
  /// **'New address'**
  String get newAddress;

  /// No description provided for @saveAddress.
  ///
  /// In en, this message translates to:
  /// **'Save address'**
  String get saveAddress;

  /// No description provided for @removeAddress.
  ///
  /// In en, this message translates to:
  /// **'Remove address'**
  String get removeAddress;

  /// No description provided for @noDefaultAddressSaved.
  ///
  /// In en, this message translates to:
  /// **'No default address saved'**
  String get noDefaultAddressSaved;

  /// No description provided for @addressSaved.
  ///
  /// In en, this message translates to:
  /// **'Address saved'**
  String get addressSaved;

  /// No description provided for @savedAddressRemoved.
  ///
  /// In en, this message translates to:
  /// **'Saved address removed'**
  String get savedAddressRemoved;

  /// No description provided for @pleaseEnterAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter your address'**
  String get pleaseEnterAddress;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @totalRequests.
  ///
  /// In en, this message translates to:
  /// **'Total Requests'**
  String get totalRequests;

  /// No description provided for @completedCount.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedCount;

  /// No description provided for @pendingCount.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingCount;

  /// No description provided for @cancelledCount.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelledCount;

  /// No description provided for @inProgressCount.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgressCount;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @adminPanel.
  ///
  /// In en, this message translates to:
  /// **'Admin Panel'**
  String get adminPanel;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @patients.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get patients;

  /// No description provided for @doctors.
  ///
  /// In en, this message translates to:
  /// **'Doctors'**
  String get doctors;

  /// No description provided for @allRequests.
  ///
  /// In en, this message translates to:
  /// **'All Requests'**
  String get allRequests;

  /// No description provided for @systemSettings.
  ///
  /// In en, this message translates to:
  /// **'System Settings'**
  String get systemSettings;

  /// No description provided for @adminComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Admin experience coming soon!'**
  String get adminComingSoon;

  /// No description provided for @adminDescription.
  ///
  /// In en, this message translates to:
  /// **'We are finalizing the dedicated dashboard for this role. Please check back later or sign out to switch accounts.'**
  String get adminDescription;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @markAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get markAsRead;

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllAsRead;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number or password'**
  String get invalidCredentials;

  /// No description provided for @phoneAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'This phone number is already registered'**
  String get phoneAlreadyRegistered;

  /// No description provided for @rateLimitExceeded.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later'**
  String get rateLimitExceeded;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection'**
  String get networkError;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get unknownError;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmail;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get invalidPhoneNumber;

  /// No description provided for @invalidAge.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid age'**
  String get invalidAge;

  /// No description provided for @mustBeAtLeast.
  ///
  /// In en, this message translates to:
  /// **'Must be at least {min}'**
  String mustBeAtLeast(int min);

  /// No description provided for @mustBeAtMost.
  ///
  /// In en, this message translates to:
  /// **'Must be at most {max}'**
  String mustBeAtMost(int max);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'mn'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'mn':
      return AppLocalizationsMn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
