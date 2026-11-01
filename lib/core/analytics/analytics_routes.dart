import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';

NavigatorObserver createScreenAnalyticsObserver() => FirebaseAnalyticsObserver(
  analytics: FirebaseAnalytics.instance,
  nameExtractor: analyticsScreenName,
);

String? analyticsScreenName(RouteSettings settings) {
  final path = settings.name?.split('?').first;
  if (path == null || path.isEmpty) return null;

  if (path == '/') return 'explore';
  if (path == '/events/create') return 'event_create';
  if (path.startsWith('/events/')) return 'event_details';
  if (path == '/places/create') return 'place_create';
  if (path == '/places/manage') return 'places_manage';
  if (path == '/places/menu') return 'menu_management';
  if (path == '/partner-dashboard') return 'partner_dashboard';
  if (path == '/minha-area') return 'user_area';
  if (path == '/place' ||
      path.startsWith('/place/') ||
      path.startsWith('/places/')) {
    return 'place_details';
  }
  return null;
}
