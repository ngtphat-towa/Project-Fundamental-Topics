part of 'customer_list_bloc.dart';

abstract class CustomerListState extends Equatable {
  final List<CustomerModel?>? customers;

  const CustomerListState({this.customers});

  @override
  List<Object?> get props => [];
}

class CustomerListInitial extends CustomerListState {}

class CustomerListLoadingState extends CustomerListState {}

class CustomerListLoadedState extends CustomerListState {
  const CustomerListLoadedState({required List<CustomerModel?> customers})
      : super(customers: customers);
  @override
  List<Object?> get props => [customers];
}

class CustomerListErrorState extends CustomerListState {
  final String? errorMessage;

  const CustomerListErrorState({
    required this.errorMessage,
  });
  @override
  List<Object?> get props => [errorMessage];
}
