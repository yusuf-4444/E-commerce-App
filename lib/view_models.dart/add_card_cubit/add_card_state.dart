part of 'add_card_cubit.dart';

class AddCardState {}

final class AddCardInitial extends AddCardState {}

final class AddCardLoading extends AddCardState {}

final class AddCardSuccess extends AddCardState {}

final class AddCardError extends AddCardState {
  final String message;
  AddCardError(this.message);
}

final class PaymentMethodsLoading extends AddCardState {}

final class PaymentMethodsSuccess extends AddCardState {
  final List<AddNewCard> cards;
  PaymentMethodsSuccess(this.cards);
}

final class PaymentMethodsError extends AddCardState {
  final String message;
  PaymentMethodsError(this.message);
}

final class PaymentMethodSelected extends AddCardState {
  final AddNewCard card;
  PaymentMethodSelected(this.card);
}

final class ConfirmPaymentLoading extends AddCardState {}

final class ConfirmPaymentSuccess extends AddCardState {}

final class ConfirmPaymentError extends AddCardState {
  final String message;
  ConfirmPaymentError(this.message);
}
