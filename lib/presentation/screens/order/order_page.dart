import 'package:depi_final_project/presentation/screens/order/order_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubits/order/order_cubit.dart';
import '../../../cubits/order/order_state.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize Cubit
    final orderCubit = OrderCubit();
    orderCubit.fetchOrders();

    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.redAccent, Colors.black54],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
        title: const Text('My Orders',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white, size: 25),
      ),
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (_) => orderCubit,
        child: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            if (state is OrderLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OrderError) {
              return Center(child: Text(state.message));
            } else if (state is OrderLoaded) {
              if (state.orders.isEmpty) {
                return const Center(
                    child: Text('You have no orders',
                        style: TextStyle(fontSize: 16)));
              }
              return ListView.builder(
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return OrderCard(order: order);
                },
              );
            }
            return const SizedBox(); // Default case
          },
        ),
      ),
    );
  }
}
