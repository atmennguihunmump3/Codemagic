enum AccessLevel { viewer, executer }

class PermissionHelper {
  static bool canAdd(AccessLevel level) => level == AccessLevel.executer;
  static bool canDelete(AccessLevel level) => level == AccessLevel.executer;
  static bool canEdit(AccessLevel level) => level == AccessLevel.executer;
}