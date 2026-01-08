import 'package:flutter/material.dart';

class NewArrivalsRow extends StatelessWidget {
  const NewArrivalsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "New Arrivals",
          style: Theme.of(
            context,
          ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w600),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "See all",
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(color: Colors.grey.shade700),
          ),
        ),
      ],
    );
  }
}
