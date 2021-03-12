import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  static TextStyle overline({@required BuildContext context, @required Color color}) {
    return GoogleFonts.montserrat(
      textStyle: Theme.of(context).textTheme.overline.copyWith(color: color),
    );
  }

  static TextStyle caption({@required BuildContext context, @required Color color}) {
    return GoogleFonts.montserrat(
      textStyle: Theme.of(context).textTheme.caption.copyWith(color: color),
    );
  }

  static TextStyle body({@required BuildContext context, @required Color color}) {
    return GoogleFonts.montserrat(
      textStyle: Theme.of(context).textTheme.bodyText1.copyWith(color: color),
    );
  }

  static TextStyle subTitle({@required BuildContext context, @required Color color}) {
    return GoogleFonts.montserrat(
      textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: color),
    );
  }

  static TextStyle title({@required BuildContext context, @required Color color}) {
    return GoogleFonts.montserrat(
      textStyle: Theme.of(context).textTheme.headline6.copyWith(color: color),
    );
  }
}
