import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/models/add_new_card.dart';

class CustomPaymentCard extends StatelessWidget {
  const CustomPaymentCard({super.key, required this.card, required this.onTap});

  final AddNewCard card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: ListTile(
          leading: CachedNetworkImage(
            imageUrl:
                'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/MasterCard_Logo.svg/1200px-MasterCard_Logo.svg.png',
            width: 50,
            height: 50,
            fit: BoxFit.contain,
          ),
          title: const Text('MasterCard'),
          subtitle: Text(card.cardNumber),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
