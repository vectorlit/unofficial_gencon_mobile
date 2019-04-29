import 'package:unofficial_gencon_mobile/themes.dart';
import 'package:flutter/material.dart';
import 'scales.dart';

class ConventionOptions {
  ConventionOptions({
    this.theme,
    this.textScaleFactor
  });

  final ConventionTheme theme;
  final ConventionTextScaleValue textScaleFactor;
}

class ConventionOptionsPage extends StatelessWidget {
  const ConventionOptionsPage({
    Key key,
    this.options,
  }): super (key: key);

  final ConventionOptions options;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return DefaultTextStyle(
      style: theme.primaryTextTheme.subhead,
      child: ListView(),
    );
  }
}