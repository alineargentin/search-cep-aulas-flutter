import 'package:flutter/material.dart';
import 'package:search_cep/theme.dart';
import 'package:search_cep/views/home_page.dart';
import 'package:dynamic_theme/dynamic_theme.dart';


void main() {
  runApp(new CepApp());
}

class CepApp extends StatelessWidget {
  const CepApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
        return new DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => myLightTheme,
      themedWidgetBuilder: (context, theme) {
        return new MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: theme,
          home: HomePage(),
        );
      }
    );
  }
}