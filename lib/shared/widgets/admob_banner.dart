import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Responsive AdMob banner for Android and iOS. It stays empty on web/desktop.
class AdMobBanner extends StatefulWidget {
  const AdMobBanner({super.key});

  @override
  State<AdMobBanner> createState() => _AdMobBannerState();
}

class _AdMobBannerState extends State<AdMobBanner> {
  static const _androidTestUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const _iosTestUnitId = 'ca-app-pub-3940256099942544/2934735716';

  BannerAd? _banner;
  int? _requestedWidth;

  bool get _supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  String get _adUnitId => defaultTargetPlatform == TargetPlatform.iOS
      ? _iosTestUnitId
      : _androidTestUnitId;

  Future<void> _load(int width) async {
    if (!_supported || width <= 0 || _requestedWidth == width) return;
    _requestedWidth = width;

    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      width,
    );
    if (!mounted || size == null) return;

    final banner = BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) setState(() => _banner = ad as BannerAd);
        },
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          if (mounted) setState(() => _requestedWidth = null);
        },
      ),
    );
    await banner.load();
  }

  @override
  void dispose() {
    _banner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_supported) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.floor();
        if (width > 0 && _requestedWidth != width) {
          scheduleMicrotask(() => _load(width));
        }

        final banner = _banner;
        if (banner == null || _requestedWidth != width) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Publicidade',
                  style: TextStyle(color: Color(0xFF777777), fontSize: 10),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: banner.size.width.toDouble(),
                height: banner.size.height.toDouble(),
                child: AdWidget(ad: banner),
              ),
            ],
          ),
        );
      },
    );
  }
}
