import 'package:dio/dio.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medired/features/appointments/appointments_export.dart';
import 'package:medired/features/appointments/data/data_source/remote/medical_test_repo_impl.dart';
import 'package:medired/features/appointments/domain/repository/medical_test_repo.dart';
import 'package:medired/features/appointments/domain/usecases/get_remote_medical_tests.dart';
import 'package:medired/features/appointments/domain/usecases/get_remote_pending_appointments.dart';
import 'package:medired/features/authentication/data/data_source/remote/broker_repository_impl.dart';
import 'package:medired/features/authentication/domain/usecases/remote/get_remote_facebook_auth.dart';
import 'package:medired/features/authentication/domain/usecases/remote/listen_remote_patient.dart';
import 'package:medired/features/authentication/domain/usecases/remote/send_email_password_reset.dart';
import 'package:medired/features/authentication/domain/usecases/remote/update_remote_member.dart';
import 'package:medired/features/authentication/domain/usecases/remote/update_remote_patient.dart';
import 'package:medired/features/massive_upload/data/data_source/local/user_excel_repo_impl.dart';
import 'package:medired/features/massive_upload/domain/repository/user_excel_repo.dart';
import 'package:medired/features/massive_upload/domain/usecases/get_excel_patients.dart';
import 'package:medired/features/payment/data/ds/cardnet_ds.dart';
import 'package:medired/features/payment/data/ds/payment_ds.dart';
import 'package:medired/features/payment/domain/repository/payment_repo.dart';
import 'package:medired/features/payment/domain/usecases/get_response_code.dart';
import 'package:medired/features/payment/domain/usecases/get_test_response_code.dart';
import 'package:medired/features/payment/domain/usecases/validate_payment.dart';
import 'package:medired/features/payments/data/services/payments_service.dart';
import 'package:medired/features/payments/data/usecases/listen_last_unprocessed_payment.dart';
import 'package:medired/features/payment/domain/usecases/post_test_to_cardnet.dart';
import 'package:medired/features/payment/domain/usecases/post_to_cardnet.dart';
import 'package:medired/features/payment/domain/usecases/save_payment.dart';
import 'package:medired/features/payment/domain/usecases/save_session.dart';
import 'package:medired/features/payment/domain/usecases/send_email.dart';
import 'package:medired/features/payments/data/usecases/start_listening_payments.dart';
import 'package:medired/features/payments/data/usecases/stop_listening_payments.dart';
import 'package:medired/features/points/domain/usecases/save_points.dart';
import 'package:medired/features/single_appointment/single_appointment_export.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/features/subscription/data/data_source/remote/subscription_repo_impl.dart';
import 'package:medired/features/subscription/data/ds/subscription_ds.dart';
import 'package:medired/features/subscription/domain/repository/subscription_repo.dart';
import 'package:medired/features/subscription/domain/services/subscription_service.dart';
import 'package:medired/features/subscription/domain/usecases/create_subscription.dart';
import 'package:medired/features/subscription/domain/usecases/get_active_subscriptions.dart';
import 'package:medired/features/subscription/domain/usecases/get_subscription.dart';
import 'package:medired/features/subscription/domain/usecases/listen_subscription.dart';
import 'package:medired/features/subscription/domain/usecases/start_listening_subscription.dart';
import 'package:medired/features/subscription/domain/usecases/stop_listening_subscription.dart';
import 'package:medired/features/subscription/domain/usecases/update_payed_subscription.dart';
import 'package:medired/features/subscription/domain/usecases/update_subscription.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medired/core/database/app_database.dart';
import 'package:sembast/sembast.dart';

GetIt sl = GetIt.instance;

Future<void> setupLocator() async {
  sl.registerSingleton<Dio>(Dio());
  // Firebase
  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  sl.registerSingleton<FirebaseStorage>(FirebaseStorage.instance);
  sl.registerSingleton<GoogleSignIn>(GoogleSignIn());
    sl.registerSingleton<FacebookAuth>(FacebookAuth.instance);

  // Local database
  AppDatabase appDatabase = AppDatabase();
  await appDatabase.init();
  sl.registerSingleton<Database>(appDatabase.db!);
  sl.registerSingleton<AuthenticationDao>(
    AuthenticationDaoImpl(sl()),
  );

  sl.registerSingleton<PaymentDs>(PaymentDs(sl()));
  sl.registerSingleton<SubscriptionDs>(SubscriptionDs(sl()));
  sl.registerSingleton<CardNetDs>(CardNetDs(sl()));

  // Dependencies
  sl.registerSingleton<AuthRepo>(
    AuthRepoImpl(
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
    ),
  );
  sl.registerSingleton<MemberRepository>(
    MemberRepositoryImpl(sl(), sl()),
  );
  sl.registerSingleton<PatientRepository>(
    PatientRepositoryImpl(sl()),
  );
  sl.registerSingleton<ServiceProviderRepository>(
    ServiceProviderRepositoryImpl(sl()),
  );
  sl.registerSingleton<SingleAppointmentRepository>(
    SingleAppointmentRepositoryImpl(sl()),
  );
  sl.registerSingleton<AppointmentsRepository>(
    AppointmentsRepositoryImpl(sl()),
  );
  sl.registerSingleton<ARSRepository>(
    ARSRepositoryImpl(sl()),
  );
  sl.registerSingleton<BrokerRepository>(
    BrokerRepositoryImpl(sl()),
  );
  sl.registerSingleton<AdminRepo>(
    AdminRepoImpl(sl()),
  );
  sl.registerSingleton<UserExcelRepo>(
    UserExcelRepoImpl(),
  );
  sl.registerSingleton<MedicalTestRepo>(
    MedicalTestRepoImpl(sl()),
  );
  sl.registerSingleton<SubscriptionRepo>(
    SubscriptionRepoImpl(sl(), sl()),
  );
  sl.registerSingleton<PaymentRepo>(
    PaymentRepoImpl(sl(), sl(), sl()),
  );

  sl.registerSingleton<PaymentsService>(
    PaymentsServiceImpl(sl()),
  );
  sl.registerSingleton<SubscriptionService>(
    SubscriptionServiceImpl(sl()),
  );

  // UseCases
  // Auth-Firebase
  sl.registerSingleton<CreateRemoteAuthUseCase>(
    CreateRemoteAuthUseCase(sl()),
  );
  sl.registerSingleton<GetRemoteAuthUseCase>(
    GetRemoteAuthUseCase(sl()),
  );
  sl.registerSingleton<GetRemoteGoogleAuthUseCase>(
      GetRemoteGoogleAuthUseCase(sl()));

  sl.registerSingleton<GetRemoteFacebookAuthUseCase>(
      GetRemoteFacebookAuthUseCase(sl()));
  sl.registerSingleton<SendEmailPasswordResetUseCase>(
    SendEmailPasswordResetUseCase(sl()),
  );
  sl.registerSingleton<SendEmailVerificationUseCase>(
    SendEmailVerificationUseCase(sl()),
  );
  sl.registerSingleton<UnathenticateRemoteUserUseCase>(
    UnathenticateRemoteUserUseCase(sl()),
  );
  // member-remote
  sl.registerSingleton<GetRemoteMemberUseCase>(
    GetRemoteMemberUseCase(sl()),
  );
  sl.registerSingleton<UpdateRemoteMemberUseCase>(
      UpdateRemoteMemberUseCase(sl()));
  sl.registerSingleton<UpdateRemoteProfilePhotoUseCase>(
    UpdateRemoteProfilePhotoUseCase(sl()),
  );
  sl.registerSingleton<ListenRemotePatientUseCase>(
    ListenRemotePatientUseCase(sl()),
  );
  sl.registerSingleton<UpdateRemoteMemberSubscriptionUseCase>(
    UpdateRemoteMemberSubscriptionUseCase(sl()),
  );
  // patient-remote
  sl.registerSingleton<CreateRemotePatientUseCase>(
    CreateRemotePatientUseCase(sl()),
  );
  sl.registerSingleton<GetRemotePatientUseCase>(
    GetRemotePatientUseCase(sl()),
  );
  sl.registerSingleton<UpdateRemotePatientUseCase>(
    UpdateRemotePatientUseCase(sl()),
  );

  // service-provider-remote
  sl.registerSingleton<CreateRemoteServiceProviderUseCase>(
    CreateRemoteServiceProviderUseCase(sl()),
  );
  sl.registerSingleton<GetRemoteServiceProviderUseCase>(
    GetRemoteServiceProviderUseCase(sl()),
  );
  sl.registerSingleton<GetRemoteServiceProvidersUseCase>(
    GetRemoteServiceProvidersUseCase(sl()),
  );

  // ars-remote
  sl.registerSingleton<CreateRemoteARSUseCase>(
    CreateRemoteARSUseCase(sl()),
  );
  sl.registerSingleton<GetRemoteARSUseCase>(
    GetRemoteARSUseCase(sl()),
  );
  // broker-remote
  sl.registerSingleton<CreateRemoteBrokerUseCase>(
    CreateRemoteBrokerUseCase(sl()),
  );
  sl.registerSingleton<GetRemoteBrokerUseCase>(
    GetRemoteBrokerUseCase(sl()),
  );
  // admin-remote
  sl.registerSingleton<GetRemoteAdminUseCase>(
    GetRemoteAdminUseCase(sl()),
  );

  // Auth-local
  sl.registerSingleton<DeleteLocalAuthUseCase>(
    DeleteLocalAuthUseCase(sl()),
  );
  sl.registerSingleton<GetLocalAuthUseCase>(
    GetLocalAuthUseCase(sl()),
  );
  sl.registerSingleton<SaveLocalAuthUseCase>(
    SaveLocalAuthUseCase(sl()),
  );

  // Appointments-remote
  sl.registerSingleton<CreateRemoteSingleAppointmentUseCase>(
    CreateRemoteSingleAppointmentUseCase(sl()),
  );
  sl.registerSingleton<UpdateRemoteAppointmentStatusUseCase>(
    UpdateRemoteAppointmentStatusUseCase(sl()),
  );
  sl.registerSingleton<GetRemotePatientAppointmentsUseCase>(
    GetRemotePatientAppointmentsUseCase(sl()),
  );
  sl.registerSingleton<GetRemoteServiceProviderAppointmentsUseCase>(
    GetRemoteServiceProviderAppointmentsUseCase(sl()),
  );
  sl.registerSingleton<GetRemotePendingAppointmentsUseCase>(
    GetRemotePendingAppointmentsUseCase(sl()),
  );
  // User-excel
  sl.registerSingleton<GetExcelPatientsUseCase>(
    GetExcelPatientsUseCase(sl()),
  );
  // MedicalTest-remote
  sl.registerSingleton<GetRemoteMedicalTestsUseCase>(
    GetRemoteMedicalTestsUseCase(sl()),
  );

  // Subscription
  sl.registerSingleton<CreateSubscriptionUseCase>(
    CreateSubscriptionUseCase(sl()),
  );
  sl.registerSingleton<UpdateSubscriptionUseCase>(
    UpdateSubscriptionUseCase(sl()),
  );
  sl.registerSingleton<GetSubscriptionUseCase>(
    GetSubscriptionUseCase(sl()),
  );
  sl.registerSingleton<ListenSubscriptionUseCase>(
    ListenSubscriptionUseCase(sl()),
  );
  sl.registerSingleton<GetActiveSubscriptionsUseCase>(
    GetActiveSubscriptionsUseCase(sl()),
  );
  sl.registerSingleton<SavePointsUseCase>(
    SavePointsUseCase(sl()),
  );
  sl.registerSingleton<UpdatePayedSubscriptionUseCase>(
    UpdatePayedSubscriptionUseCase(sl()),
  );
  // Payment
  sl.registerSingleton<PostToCardnetUseCase>(
    PostToCardnetUseCase(sl()),
  );
  sl.registerSingleton<PostTestToCardnetUseCase>(
    PostTestToCardnetUseCase(sl()),
  );
  sl.registerSingleton<GetResponseCodeUseCase>(
    GetResponseCodeUseCase(sl()),
  );
  sl.registerSingleton<GetTestResponseCodeUseCase>(
    GetTestResponseCodeUseCase(sl()),
  );
  sl.registerSingleton<SendEmailUseCase>(
    SendEmailUseCase(sl()),
  );
  sl.registerSingleton<SavePaymentUseCase>(
    SavePaymentUseCase(sl()),
  );
  sl.registerSingleton<SaveSessionUseCase>(
    SaveSessionUseCase(sl()),
  );
  sl.registerSingleton<ListenLastUnprocessedPaymentUseCase>(
    ListenLastUnprocessedPaymentUseCase(sl()),
  );
  sl.registerSingleton<StartListeningPaymentsUseCase>(
    StartListeningPaymentsUseCase(sl()),
  );
  sl.registerSingleton<StopListeningPaymentsUseCase>(
    StopListeningPaymentsUseCase(sl()),
  );
  sl.registerSingleton<ValidatePaymentUseCase>(
    ValidatePaymentUseCase(sl()),
  );
  sl.registerSingleton<StartListeningSubscriptionUseCase>(
    StartListeningSubscriptionUseCase(sl()),
  );
  sl.registerSingleton<StopListeningSubscriptionUseCase>(
    StopListeningSubscriptionUseCase(sl()),
  );
}
