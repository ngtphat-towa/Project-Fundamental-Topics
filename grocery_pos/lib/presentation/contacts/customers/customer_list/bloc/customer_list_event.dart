part of 'customer_list_bloc.dart';

abstract class CustomerListEvent extends Equatable {
  const CustomerListEvent();

  @override
  List<Object?> get props => [];
}

class LoadCustomerListEvent extends CustomerListEvent {
  final String? searchValue;
  const LoadCustomerListEvent({this.searchValue});
  @override
  List<Object?> get props => [searchValue];
}

class DeleteCustomerListEvent extends CustomerListEvent {
  final CustomerModel customer;
  const DeleteCustomerListEvent({required this.customer});
  @override
  List<Object?> get props => [customer];
}
