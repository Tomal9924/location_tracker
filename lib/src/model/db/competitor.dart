import 'package:hive/hive.dart';
import 'package:location_tracker/src/model/drop_down_item.dart';
import 'package:location_tracker/src/utils/constants.dart';

part 'competitor.g.dart';

@HiveType(adapterName: "CompetitorAdapter", typeId: tableCompetitor)
class Competitor {
  @HiveField(0)
  int id;
  @HiveField(1)
  String competitorId;
  @HiveField(2)
  String name;

  Competitor();

  Competitor.fromJSON(Map<String, dynamic> map) {
    id = map["Id"];
    competitorId = map["CompetitorId"];
    name = map["Name"];
  }

  DropDownItem get toDropDownItem => DropDownItem(text: name, value: competitorId);
}
