import 'package:unofficial_gencon_mobile/app_state_model.dart';
import 'package:unofficial_gencon_mobile/home.dart';
import 'package:scoped_model/scoped_model.dart';

import 'options.dart';
import 'themes.dart';
import 'package:flutter/material.dart';

class ConventionApp extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Title',
    );
  }

  @override
  State<StatefulWidget> createState() => _ConventionAppState();
}

class _ConventionAppState extends State<ConventionApp> {
  ConventionOptions _options;

  AppStateModel model;

  @override
  void initState() {
    super.initState();
    _options = ConventionOptions(theme: kLightConventionTheme);

    model = AppStateModel();
  }

  @override
  Widget build(BuildContext context) {
    Widget home = ConventionHome(
      optionsPage: ConventionOptionsPage(
        options: _options,
      ),
    );
    return ScopedModel<AppStateModel>(
      model: model,
      child: MaterialApp(home: home),
    );
  }
}
