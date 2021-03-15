import 'package:flutter/cupertino.dart';

class Competitor {
  String competitorGUID = "";
  TextEditingController competitorTV;
  TextEditingController competitorAC;
  TextEditingController competitorRF;

  Competitor(this.competitorGUID, this.competitorTV, this.competitorAC, this.competitorRF);
}
