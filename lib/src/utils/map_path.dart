class MapPath {
  static bool _isNumeric(String s) {
    return int.tryParse(s) != null;
  }

  static dynamic getIn(Map<String, dynamic> map, String path) {
    if (path.isEmpty) return null;
    final keys = path.split('.');
    dynamic current = map;

    for (final key in keys) {
      if (current is Map<String, dynamic> && current.containsKey(key)) {
        current = current[key];
      } else if (current is List && _isNumeric(key)) {
        final index = int.parse(key);
        if (index >= 0 && index < current.length) {
          current = current[index];
        } else {
          return null;
        }
      } else {
        return null;
      }
    }

    return current;
  }

  static Map<String, dynamic> setIn(
    Map<String, dynamic> map,
    String path,
    dynamic value,
  ) {
    if (path.isEmpty) return map;
    final keys = path.split('.');
    final newMap = Map<String, dynamic>.from(map);

    _setInRecursive(newMap, keys, 0, value);
    return newMap;
  }

  static void _setInRecursive(
    dynamic current,
    List<String> keys,
    int index,
    dynamic value,
  ) {
    if (index >= keys.length - 1) {
      final lastKey = keys.last;
      if (current is Map<String, dynamic>) {
        current[lastKey] = value;
      } else if (current is List && _isNumeric(lastKey)) {
        final listIdx = int.parse(lastKey);
        if (listIdx >= 0 && listIdx < current.length) {
          current[listIdx] = value;
        }
      }
      return;
    }

    final key = keys[index];
    final nextKeyIsNumeric = _isNumeric(keys[index + 1]);

    if (current is Map<String, dynamic>) {
      if (!current.containsKey(key) || current[key] == null) {
        current[key] = nextKeyIsNumeric ? <dynamic>[] : <String, dynamic>{};
      } else if (nextKeyIsNumeric && current[key] is! List) {
        current[key] = <dynamic>[];
      } else if (!nextKeyIsNumeric && current[key] is! Map<String, dynamic>) {
        current[key] = <String, dynamic>{};
      }

      if (current[key] is List) {
        current[key] = List<dynamic>.from(current[key] as List);
      } else if (current[key] is Map<String, dynamic>) {
        current[key] =
            Map<String, dynamic>.from(current[key] as Map<String, dynamic>);
      }

      _setInRecursive(current[key], keys, index + 1, value);
    } else if (current is List && _isNumeric(key)) {
      final listIdx = int.parse(key);
      if (listIdx >= 0 && listIdx < current.length) {
        if (current[listIdx] == null) {
          current[listIdx] =
              nextKeyIsNumeric ? <dynamic>[] : <String, dynamic>{};
        }

        if (current[listIdx] is List) {
          current[listIdx] = List<dynamic>.from(current[listIdx] as List);
        } else if (current[listIdx] is Map<String, dynamic>) {
          current[listIdx] = Map<String, dynamic>.from(
              current[listIdx] as Map<String, dynamic>);
        }

        _setInRecursive(current[listIdx], keys, index + 1, value);
      }
    }
  }

  static Map<String, dynamic> deleteIn(Map<String, dynamic> map, String path) {
    if (path.isEmpty) return map;
    final newMap = Map<String, dynamic>.from(map);
    final keys = path.split('.');

    _deleteInRecursive(newMap, keys, 0);
    return newMap;
  }

  static void _deleteInRecursive(
      dynamic current, List<String> keys, int index) {
    if (index >= keys.length - 1) {
      final lastKey = keys.last;
      if (current is Map<String, dynamic>) {
        current.remove(lastKey);
      } else if (current is List && _isNumeric(lastKey)) {
        final listIdx = int.parse(lastKey);
        if (listIdx >= 0 && listIdx < current.length) {
          current.removeAt(listIdx);
        }
      }
      return;
    }

    final key = keys[index];
    if (current is Map<String, dynamic> && current.containsKey(key)) {
      if (current[key] is List) {
        current[key] = List<dynamic>.from(current[key] as List);
      } else if (current[key] is Map<String, dynamic>) {
        current[key] =
            Map<String, dynamic>.from(current[key] as Map<String, dynamic>);
      }
      _deleteInRecursive(current[key], keys, index + 1);
    } else if (current is List && _isNumeric(key)) {
      final listIdx = int.parse(key);
      if (listIdx >= 0 && listIdx < current.length) {
        if (current[listIdx] is List) {
          current[listIdx] = List<dynamic>.from(current[listIdx] as List);
        } else if (current[listIdx] is Map<String, dynamic>) {
          current[listIdx] = Map<String, dynamic>.from(
              current[listIdx] as Map<String, dynamic>);
        }
        _deleteInRecursive(current[listIdx], keys, index + 1);
      }
    }
  }
}
