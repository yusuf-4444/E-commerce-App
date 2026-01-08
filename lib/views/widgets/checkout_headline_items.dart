import 'package:flutter/material.dart';

class CheckoutHeadlineItems extends StatelessWidget {
  const CheckoutHeadlineItems({
    super.key,
    required this.title,
    this.numOfProducts,
    this.onTap,
  });

  final String title;
  final int? numOfProducts;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Row(
          children: [
            Text(
              "$title ",
              style: Theme.of(
                context,
              ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w600),
            ),
            if (numOfProducts != null)
              Text(
                "($numOfProducts)",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        if (onTap != null)
          TextButton(
            onPressed: onTap,
            child: Text(
              "Edit",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(color: Colors.grey.shade700),
            ),
          ),
      ],
    );
  }
}
