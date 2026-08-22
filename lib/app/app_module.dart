import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entao_bora/core/firestore/data/firestore_client.dart';
import 'package:entao_bora/core/firestore/data/firestore_client_impl.dart';
import 'package:entao_bora/core/location/data/data_source/location_data_source.dart';
import 'package:entao_bora/core/location/data/data_source/location_data_source_impl.dart';
import 'package:entao_bora/core/location/data/repositories/location_repository_impl.dart';
import 'package:entao_bora/core/location/domain/repositories/location_repository.dart';
import 'package:entao_bora/feature/auth/data/datasource/auth_datasource.dart';
import 'package:entao_bora/feature/auth/data/datasource/auth_datasource_impl.dart';
import 'package:entao_bora/feature/auth/data/repositories/auth_repositor_impl.dart';
import 'package:entao_bora/feature/auth/domain/repositries/auth_repository.dart';
import 'package:entao_bora/feature/auth/presentation/auth_viewmodel.dart';
import 'package:entao_bora/feature/auth/presentation/stores/session_store.dart';
import 'package:entao_bora/feature/events/data/data_source/events_data_source.dart';
import 'package:entao_bora/feature/events/data/data_source/events_datasource_impl.dart';
import 'package:entao_bora/feature/events/data/repositories/event_repository_impl.dart';
import 'package:entao_bora/feature/events/domain/repositories/event_repositor.dart';
import 'package:entao_bora/feature/events/presentation/pages/create_event_page.dart';
import 'package:entao_bora/feature/events/presentation/pages/event_details_page.dart';
import 'package:entao_bora/feature/events/presentation/pages/place_botton_sheet.dart';
import 'package:entao_bora/feature/events/presentation/viewmodels/create_event_viewmodel.dart';
import 'package:entao_bora/feature/events/presentation/viewmodels/event_details_viewmodel.dart';
import 'package:entao_bora/feature/events/presentation/viewmodels/place_events_viewmodel.dart';
import 'package:entao_bora/feature/home/presentation/pages/home.dart';
import 'package:entao_bora/feature/home/presentation/viewmodels/home_viewmodel.dart';
import 'package:entao_bora/feature/partner_dashboard/partner_dashboard_page.dart';
import 'package:entao_bora/feature/places/data/datasource/place_datasource.dart';
import 'package:entao_bora/feature/places/data/datasource/place_datasource.impl.dart';
import 'package:entao_bora/feature/places/data/repositories/place_repositor_impl.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/feature/places/domain/repositories/place_repository.dart';
import 'package:entao_bora/feature/places/presentation/create_place_page.dart';
import 'package:entao_bora/feature/places/presentation/create_place_viewmodel.dart';
import 'package:entao_bora/feature/places/presentation/place_details_page.dart';
import 'package:entao_bora/feature/splash/presentation/splash_page.dart';
import 'package:entao_bora/feature/user/domain/datasource/user_datasource.dart';
import 'package:entao_bora/feature/user/domain/datasource/user_datasource_impl.dart';
import 'package:entao_bora/shared/errors/log_events.dart';
import 'package:entao_bora/shared/errors/log_events_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    //==========================================================
    // FIRESTORE
    //==========================================================

    i.addSingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

    i.addSingleton<FirestoreClient>(() => FirestoreClientImpl(i()));
    i.addSingleton<LogEventsClient>(LogEventsClientImpl.new);
    //==========================================================
    // LOCATION
    //==========================================================
    i.addLazySingleton<HomeViewModel>(HomeViewModel.new);
    i.addSingleton<ILocationDatasource>(LocationDatasourceImpl.new);
    i.addSingleton<ILocationRepository>(
      () => LocationRepositoryImpl(datasource: i()),
    );
    i.add(CreatePlaceViewModel.new);
    i.add(PlaceEventsViewModel.new);
    i.add(CreateEventViewModel.new);
    i.add(EventDetailsViewModel.new);
    i.addSingleton(SessionStore.new);
    i.addSingleton<UserDatasource>(() => UserDatasourceImpl(i()));

    //==========================================================
    // PLACES
    //==========================================================

    i.addSingleton<IPlaceDatasource>(() => PlaceDatasourceImpl(i()));

    i.addSingleton<IPlaceRepository>(
      () => PlaceRepositoryImpl(datasource: i(), userDatasource: i()),
    );
    //==========================================================
    // EVENTS
    //==========================================================

    i.addSingleton<EventDatasource>(EventDatasourceImpl.new);
    i.addSingleton<IEventRepository>(
      EventRepositoryImpl.new,
    ); //==========================================================
    // AUTH
    //==========================================================

    i.addSingleton<AuthDatasource>(
      () => AuthDatasourceImpl(i<FirebaseAuth>(), i<UserDatasource>()),
    );
    i.addSingleton<IAuthRepository>(() => AuthRepositoryImpl(i(), i()));
    i.addSingleton<AuthViewModel>(AuthViewModel.new);
    i.addSingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  }

  @override
  void routes(RouteManager r) {
  //  r.child('/', child: (_) => const SplashPage());

    r.child(
      '/',
      child: (_) => HomePage(
        showLogin:
            (r.args.data as Map<String, dynamic>?)?['showLogin'] ?? false,
      ),
    );
    r.child('/places/create', child: (_) => const CreatePlacePage());

    r.child('/events/create', child: (_) => const CreateEventPage());
    
    r.child(
      '/place',
      child: (_) => PlaceDetailsPage(place: r.args.data as PlaceEntity),
    );
    r.child(
      '/partner-dashboard',
      child: (_) => PartnerDashboardPage(place: r.args.data as PlaceEntity),
    );
    // r.child(
    //   '/place',
    //   child: (_) => PlaceDetailsSheet(place: r.args.data as PlaceEntity),
    // );

    r.child(
      '/events/:id',
      child: (_) => EventsDetailsPage(id: r.args.params['id']!),
    );
  }
}
