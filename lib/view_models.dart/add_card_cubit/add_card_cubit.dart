import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_new_card.dart';
import 'package:flutter_ecommerce_app/services/payment_methods_service.dart';

part 'add_card_state.dart';

class AddCardCubit extends Cubit<AddCardState> {
  AddCardCubit() : super(AddCardInitial());

  final PaymentMethodsServiceImpl _paymentMethodsService =
      PaymentMethodsServiceImpl();

  String? selectedId;

  Future<void> addCard(
    String cardNumber,
    String cardHolderName,
    String expiryDate,
    String cvv,
  ) async {
    emit(AddCardLoading());
    try {
      final paymentCards = await _paymentMethodsService.getPaymentMethods();
      final card = AddNewCard(
        cardNumber: cardNumber,
        cardHolderName: cardHolderName,
        expiryDate: expiryDate,
        cvv: cvv,
        id: DateTime.now().toIso8601String(),
        isSelected: paymentCards.isEmpty,
      );
      await _paymentMethodsService.setPaymentMethod(card);
      emit(AddCardSuccess());
    } catch (e) {
      emit(AddCardError(e.toString()));
    }
  }

  Future<void> getCards() async {
    emit(PaymentMethodsLoading());

    try {
      final List<AddNewCard> paymentCards = await _paymentMethodsService
          .getPaymentMethods();
      if (paymentCards.isEmpty) {
        emit(PaymentMethodsError('No payment methods found'));
      }
      final tempChosenMethod = paymentCards.firstWhere(
        (element) => element.isSelected,
        orElse: () => paymentCards.first,
      );
      emit(PaymentMethodsSuccess(paymentCards));
      emit(PaymentMethodSelected(tempChosenMethod));
    } catch (e) {
      emit(PaymentMethodsError(e.toString()));
    }
  }

  Future<void> paymentMethodSelected(String id) async {
    selectedId = id;
    final paymentCards = await _paymentMethodsService.getPaymentMethods();
    var tempChosenMethod = paymentCards.firstWhere(
      (element) => element.id == selectedId,
      orElse: () => paymentCards.first,
    );

    emit(PaymentMethodSelected(tempChosenMethod));
  }

  Future<void> confirmPaymentMethod() async {
    final paymentCards = await _paymentMethodsService.getPaymentMethods();
    var chosenMethod = paymentCards.firstWhere(
      (element) => element.id == selectedId,
      orElse: () => paymentCards.first,
    );
    var previousMethod = paymentCards.firstWhere(
      (element) => element.isSelected,
      orElse: () => paymentCards.first,
    );
    previousMethod = previousMethod.copyWith(isSelected: false);
    chosenMethod = chosenMethod.copyWith(isSelected: true);

    await _paymentMethodsService.setPaymentMethod(chosenMethod);
    await _paymentMethodsService.setPaymentMethod(previousMethod);

    emit(ConfirmPaymentSuccess());
  }
}
