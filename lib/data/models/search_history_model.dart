import 'package:hive/hive.dart';

part 'search_history_model.g.dart';

@HiveType(typeId: 1)
class SearchHistory extends HiveObject {
  @HiveField(0)
  final String term;

  @HiveField(1)
  final DateTime timestamp;

  SearchHistory({
    required this.term,
    required this.timestamp,
  });
}
