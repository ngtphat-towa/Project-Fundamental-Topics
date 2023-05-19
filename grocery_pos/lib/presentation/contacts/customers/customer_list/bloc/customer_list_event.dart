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
  final CustomerModel model;
  const DeleteCustomerListEvent({required this.model});
  @override
  List<Object?> get props => [model];
}
