import 'package:hive/hive.dart';
import '../models/search_history_model.dart';

class SearchRepository {
  static const String boxName = 'searchBox';

  Future<Box<SearchHistory>> _getBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<SearchHistory>(boxName);
    }
    return await Hive.openBox<SearchHistory>(boxName);
  }

  Future<List<SearchHistory>> getHistory() async {
    final box = await _getBox();
    // Return sorted by recent
    final list = box.values.toList();
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }

  Future<void> addSearchTerm(String term) async {
    final box = await _getBox();
    // Check duplicates? User didn't specify, but usually we don't want duplicate recent searches.
    // Simple implementation:
    final newEntry = SearchHistory(term: term, timestamp: DateTime.now());
    await box.add(newEntry);
  }

  Future<void> clearHistory() async {
    final box = await _getBox();
    await box.clear();
  }
}
