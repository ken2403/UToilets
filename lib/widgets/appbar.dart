import 'package:flutter/material.dart';

PreferredSizeWidget customAppbar(BuildContext ctx, String title) {
  return AppBar(
    elevation: 1,
    backgroundColor: Theme.of(ctx).colorScheme.surface,
    title: Text(
      title,
      style: TextStyle(
        fontSize: Theme.of(ctx).textTheme.headline6!.fontSize,
        color: Theme.of(ctx).colorScheme.primary,
      ),
    ),
  );
}
