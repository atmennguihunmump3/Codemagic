import '../constants/app_constants.dart';

class SyntaxParser {
  static Map<String, dynamic>? parse(String title) {
    final t = title.trim();

    if (t.startsWith(AppConstants.deliveryPrefix)) {
      final content = t.replaceFirst(AppConstants.deliveryPrefix, "").trim();
      final parts = content.split(AppConstants.fieldDelimiter);
      return {
        "type": "delivery",
        "route": parts.isNotEmpty ? parts[0] : "",
        "driver": parts.length > 1 ? parts[1] : "",
        "destination": parts.length > 2 ? parts[2] : "",
      };
    }

    if (t.startsWith(AppConstants.productionPrefix)) {
      final content = t.replaceFirst(AppConstants.productionPrefix, "").trim();
      final parts = content.split(AppConstants.fieldDelimiter);
      return {
        "type": "production",
        "lineName": parts.isNotEmpty ? parts[0] : "",
        "taskDetails": parts.length > 1 ? parts[1] : "",
      };
    }

    if (t.startsWith(AppConstants.attendancePrefix)) {
      final content = t.replaceFirst(AppConstants.attendancePrefix, "").trim();
      final nameMatch = RegExp(r"(.+?)\s*\((.+)\)").firstMatch(content);
      if (nameMatch != null) {
        return {
          "type": "attendance",
          "employeeName": nameMatch.group(1)?.trim() ?? "",
          "status": nameMatch.group(2)?.trim() ?? "",
        };
      }
    }
    return null;
  }

  static String buildTitle(String type, Map<String, String> fields) {
    switch (type) {
      case "delivery":
        return "D# ${fields['route']} # ${fields['driver']} # ${fields['destination']}";
      case "production":
        return "P# ${fields['lineName']} # ${fields['taskDetails']}";
      case "attendance":
        return "A# ${fields['employeeName']} (${fields['status']})";
      default:
        return "";
    }
  }
}