import 'package:flutter/material.dart';

class TabelCellComfortable extends StatelessWidget {
  final String query;
  const TabelCellComfortable({
    super.key,
    required this.query,
  });
  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Center(
        child: Text(
          query,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
