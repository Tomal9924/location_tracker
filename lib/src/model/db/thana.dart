
import 'package:hive/hive.dart';
import 'package:location_tracker/src/model/drop_down_item.dart';
import 'package:location_tracker/src/utils/constants.dart';

part 'thana.g.dart';

@HiveType(adapterName: "ThanaAdapter", typeId: tableThana)
class Thana {
  @HiveField(0)
  int id;
  @HiveField(1)
  String parentDataKey;
  @HiveField(2)
  String dataKey;
  @HiveField(3)
  String displayText;
  @HiveField(4)
  String dataValue;

  Thana();

  Thana.fromJSON(Map<String, dynamic> map) {
    id= map["Id"];
    parentDataKey= map["ParentDataKey"];
    dataKey= map["DataKey"];
    displayText= map["DisplayText"];
    dataValue= map["DataValue"];
  }

  DropDownItem get toDropDownItem => DropDownItem(text: displayText, value: dataValue);
}