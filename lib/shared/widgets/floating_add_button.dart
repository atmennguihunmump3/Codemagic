import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/permission_helper.dart';

class FloatingAddButton extends StatelessWidget {
  final AccessLevel accessLevel;
  final VoidCallback onTap;

  const FloatingAddButton({
    super.key,
    required this.accessLevel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final canAdd = PermissionHelper.canAdd(accessLevel);
    if (!canAdd) return const SizedBox();

    return FloatingActionButton(
      onPressed: onTap,
      backgroundColor: AppColors.accentBlue,
      child: const Icon(Icons.add, color: Colors.white, size: 26),
    );
  }
}