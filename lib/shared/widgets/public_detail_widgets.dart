import 'dart:convert';
import 'dart:math' as math;

import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/home/presentation/widgets/home_style.dart';
import 'package:entao_bora/feature/places/domain/entities/menu_item_entity.dart';
import 'package:entao_bora/shared/enum/oppening_hours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class PublicDetailShell extends StatelessWidget {
  const PublicDetailShell({
    super.key,
    required this.child,
    required this.onNavigate,
    required this.onLogin,
    this.user,
  });

  final Widget child;
  final UserSummaryEntity? user;
  final ValueChanged<String> onNavigate;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) => Theme(
    data: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: HomeStyle.background,
      fontFamily: 'Arial',
      fontFamilyFallback: const ['Helvetica', 'Arimo', 'sans-serif'],
      colorScheme: const ColorScheme.dark(
        primary: HomeStyle.accent,
        surface: HomeStyle.surface,
      ),
      splashFactory: NoSplash.splashFactory,
    ),
    child: Scaffold(
      backgroundColor: HomeStyle.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, viewport) {
            final width = viewport.maxWidth;
            final mobile = width <= 760;
            final inset = mobile
                ? 18.0
                : width <= 1250
                ? 28.0
                : 0.0;
            return SingleChildScrollView(
              child: Column(
                children: [
                  _header(context, mobile, width),
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 1200,
                        minHeight: math.max(0, viewport.maxHeight - 210),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          inset,
                          mobile
                              ? 30
                              : width <= 1250
                              ? 36
                              : 48,
                          inset,
                          mobile
                              ? 30
                              : width <= 1250
                              ? 50
                              : 60,
                        ),
                        child: child,
                      ),
                    ),
                  ),
                  _footer(mobile, width),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );

  Widget _brand(bool mobile, {bool footer = false}) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (!footer) ...[
        ClipOval(
          child: Image.asset(
            'assets/images/home_logo.png',
            width: mobile ? 33 : 44,
            height: mobile ? 33 : 44,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 8),
      ],
      Text.rich(
        textScaler: TextScaler.noScaling,
        TextSpan(
          children: const [
            TextSpan(text: 'então'),
            TextSpan(
              text: 'bora',
              style: TextStyle(color: HomeStyle.brand),
            ),
          ],
        ),
        style: HomeStyle.type(
          footer
              ? 20
              : mobile
              ? 22
              : 25,
          weight: FontWeight.w900,
          tracking: -1.7,
        ),
      ),
    ],
  );

  Widget _header(BuildContext context, bool mobile, double width) {
    final padding = mobile ? 18.0 : math.max(28.0, (width - 1200) / 2);
    final loginLabel = user == null
        ? 'Entrar'
        : '${user!.name.split(' ').first} · Sair';
    return Container(
      constraints: BoxConstraints(minHeight: mobile ? 72 : 88),
      padding: EdgeInsets.symmetric(horizontal: padding),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF242424))),
      ),
      child: Row(
        children: [
          _brand(mobile),
          const Spacer(),
          if (!mobile)
            TextButton(
              onPressed: () => onNavigate('/'),
              child: Text('Explorar', style: HomeStyle.type(13)),
            ),
          if (!mobile) const SizedBox(width: 20),
          OutlinedButton(
            onPressed: onLogin,
            style: OutlinedButton.styleFrom(
              foregroundColor: HomeStyle.text,
              minimumSize: const Size(104, 38),
              side: const BorderSide(color: Color(0xFF333333)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(loginLabel, style: HomeStyle.type(14)),
          ),
        ],
      ),
    );
  }

  Widget _footer(bool mobile, double width) => Container(
    width: double.infinity,
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: Color(0xFF242424))),
    ),
    padding: EdgeInsets.symmetric(
      horizontal: mobile ? 18 : math.max(28, (width - 1200) / 2),
      vertical: 28,
    ),
    child: Row(
      children: [
        _brand(mobile, footer: true),
        const SizedBox(width: 20),
        Flexible(
          child: Text(
            'A vida acontece lá fora. Bora?',
            style: HomeStyle.type(12, color: const Color(0xFF777777)),
          ),
        ),
      ],
    ),
  );
}

class PublicDetailView extends StatelessWidget {
  const PublicDetailView({
    super.key,
    required this.article,
    required this.aside,
    this.cover,
  });
  final Widget? cover;
  final Widget article;
  final Widget aside;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final mobile = MediaQuery.sizeOf(context).width <= 760;
      final columns = mobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                KeyedSubtree(
                  key: const ValueKey('public-detail-article'),
                  child: article,
                ),
                const SizedBox(height: 20),
                KeyedSubtree(
                  key: const ValueKey('public-detail-aside'),
                  child: aside,
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: KeyedSubtree(
                    key: const ValueKey('public-detail-article'),
                    child: article,
                  ),
                ),
                const SizedBox(width: 40),
                SizedBox(
                  key: const ValueKey('public-detail-aside'),
                  width: 320,
                  child: aside,
                ),
              ],
            );
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                Modular.to.navigate('/');
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF777777),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              '← Voltar para explorar',
              style: HomeStyle.type(11, color: const Color(0xFF777777)),
            ),
          ),
          if (cover != null) cover!,
          const SizedBox(height: 28),
          columns,
        ],
      );
    },
  );
}

class PublicDetailImage extends StatelessWidget {
  const PublicDetailImage(
    this.source, {
    super.key,
    required this.height,
    this.width = double.infinity,
    this.radius = 14,
  });
  final String source;
  final double height, width, radius;

  @override
  Widget build(BuildContext context) {
    Widget image;
    try {
      image = source.startsWith('http://') || source.startsWith('https://')
          ? Image.network(source, fit: BoxFit.cover)
          : Image.memory(
              source.startsWith('data:')
                  ? UriData.parse(source).contentAsBytes()
                  : base64Decode(source),
              fit: BoxFit.cover,
            );
    } catch (_) {
      image = const SizedBox.shrink();
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(width: width, height: height, child: image),
    );
  }
}

class PublicChips extends StatelessWidget {
  const PublicChips(this.labels, {super.key});
  final Iterable<String> labels;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: labels
          .map(
            (label) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFF222222),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(label, style: HomeStyle.type(11)),
            ),
          )
          .toList(),
    ),
  );
}

class PublicGallery extends StatelessWidget {
  const PublicGallery(this.sources, {super.key});
  final List<String> sources;
  @override
  Widget build(BuildContext context) {
    if (sources.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 180,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 25),
        scrollDirection: Axis.horizontal,
        itemCount: sources.length,
        separatorBuilder: (_, _) => const SizedBox(width: 15),
        itemBuilder: (_, index) => PublicDetailImage(
          sources[index],
          height: 130,
          width: 180,
          radius: 8,
        ),
      ),
    );
  }
}

class PublicExpansion extends StatelessWidget {
  const PublicExpansion({super.key, required this.title, required this.child});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(vertical: 18),
    decoration: BoxDecoration(
      color: HomeStyle.surface,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 18),
        childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        title: Text(title, style: HomeStyle.type(14, weight: FontWeight.w700)),
        children: [child],
      ),
    ),
  );
}

class PublicMenu extends StatelessWidget {
  const PublicMenu(this.items, {super.key});
  final List<MenuItemEntity> items;
  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Cardápio ainda não disponível.',
          style: HomeStyle.type(14, color: HomeStyle.muted),
        ),
      );
    }
    final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return Column(
      children: items
          .map(
            (item) => Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFF333333))),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.category.trim().isEmpty
                              ? 'Geral'
                              : item.category,
                          style: HomeStyle.type(11, color: HomeStyle.muted),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.title,
                          style: HomeStyle.type(
                            19,
                            weight: FontWeight.w700,
                            tracking: -.85,
                          ),
                        ),
                        if (item.description.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            item.description,
                            style: HomeStyle.type(
                              14,
                              color: HomeStyle.muted,
                              height: 1.65,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    currency.format(item.price),
                    style: HomeStyle.type(14, weight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class PublicHours extends StatelessWidget {
  const PublicHours(this.hours, {super.key});
  final List<OpeningHours> hours;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: hours
        .map(
          (item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              '${item.weekday.label}: ${item.formatted}',
              style: HomeStyle.type(14, color: HomeStyle.muted),
            ),
          ),
        )
        .toList(),
  );
}

class PublicAside extends StatelessWidget {
  const PublicAside({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: HomeStyle.box(border: const Color(0xFF333333), radius: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _spaced(children, 15),
    ),
  );
}

List<Widget> _spaced(List<Widget> widgets, double gap) {
  if (widgets.isEmpty) return const [];
  return [
    for (var i = 0; i < widgets.length; i++) ...[
      if (i > 0) SizedBox(height: gap),
      widgets[i],
    ],
  ];
}

class PublicButton extends StatelessWidget {
  const PublicButton(
    this.label, {
    super.key,
    required this.onPressed,
    this.icon,
    this.filled = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool filled;
  @override
  Widget build(BuildContext context) {
    final child = icon == null
        ? Text(label)
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 17),
              const SizedBox(width: 8),
              Flexible(child: Text(label)),
            ],
          );
    final style = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size.fromHeight(46)),
      foregroundColor: const WidgetStatePropertyAll(HomeStyle.text),
      backgroundColor: WidgetStatePropertyAll(
        filled ? HomeStyle.accent : Colors.transparent,
      ),
      side: WidgetStatePropertyAll(
        BorderSide(color: filled ? HomeStyle.accent : const Color(0xFF444444)),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      textStyle: WidgetStatePropertyAll(
        HomeStyle.type(13, weight: FontWeight.w700),
      ),
    );
    return OutlinedButton(onPressed: onPressed, style: style, child: child);
  }
}

TextStyle publicTitle(bool mobile) => HomeStyle.type(
  mobile ? 32 : 40,
  weight: FontWeight.w700,
  tracking: mobile ? -1.44 : -1.8,
  height: 1.1,
);
TextStyle publicSectionTitle() =>
    HomeStyle.type(26, weight: FontWeight.w700, tracking: -1.17);
TextStyle publicBody() =>
    HomeStyle.type(14, color: HomeStyle.muted, height: 1.65);
