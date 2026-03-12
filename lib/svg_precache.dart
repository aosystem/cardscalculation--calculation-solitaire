import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:cardscalculation/const_value.dart';
import 'package:cardscalculation/card_all.dart';
import 'package:cardscalculation/card_one.dart';

Future<void> precacheSvgAssets(BuildContext _) async {
  final CardAll cardAll = CardAll();
  final List<CardOne> cards = cardAll.getCards();
  final Set<String> paths = {
    ConstValue.imageBlank,
    ConstValue.imageBack,
    ConstValue.imageIcon,
    for (final c in cards) c.getImg(),
  };
  int i = 0;
  for (final p in paths) {
    try {
      final loader = SvgAssetLoader(p);
      await svg.cache.putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
    } catch (_) {
      // ignore precache failures
    }
    i++;
    if (i % 6 == 0) {
      await Future<void>.delayed(const Duration(milliseconds: 1));
    }
  }
}
