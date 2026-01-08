// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AddNewCard {
  final String id;
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String cvv;
  final bool isSelected;

  AddNewCard({
    required this.id,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cvv,
    this.isSelected = false,
  });
  AddNewCard copyWith({
    String? id,
    String? cardNumber,
    String? cardHolderName,
    String? expiryDate,
    String? cvv,
    bool? isSelected,
  }) {
    return AddNewCard(
      id: id ?? this.id,
      cardNumber: cardNumber ?? this.cardNumber,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'isSelected': isSelected,
    };
  }

  factory AddNewCard.fromMap(Map<String, dynamic> map) {
    return AddNewCard(
      id: map['id'] as String,
      cardNumber: map['cardNumber'] as String,
      cardHolderName: map['cardHolderName'] as String,
      expiryDate: map['expiryDate'] as String,
      cvv: map['cvv'] as String,
      isSelected: map['isSelected'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddNewCard.fromJson(String source) =>
      AddNewCard.fromMap(json.decode(source) as Map<String, dynamic>);
}

List<AddNewCard> paymentCards = [
  AddNewCard(
    id: '1',
    cardNumber: '1234 1234 1234 1231',
    cardHolderName: 'John Doe',
    expiryDate: '12/2020',
    cvv: '123',
  ),
  AddNewCard(
    id: '2',
    cardNumber: '1234 1234 1234 1232',
    cardHolderName: 'John Doe',
    expiryDate: '12/2020',
    cvv: '123',
  ),
  AddNewCard(
    id: '3',
    cardNumber: '1234 1234 1234 1233',
    cardHolderName: 'John Doe',
    expiryDate: '12/2020',
    cvv: '123',
  ),
  AddNewCard(
    id: '4',
    cardNumber: '1234 1234 1234 1234',
    cardHolderName: 'John Doe',
    expiryDate: '12/2020',
    cvv: '123',
  ),
];
