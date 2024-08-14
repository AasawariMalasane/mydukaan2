import 'package:flutter/foundation.dart';
import '../models/generateorder_model.dart';
import '../models/order.dart';
import '../repositories/order_repository.dart';

class OrderProvider with ChangeNotifier {
  final OrderRepository _orderRepository;

  List<OrderModel> _orders = [];
  GenerateOrderModel? _currentOrder;
  bool _isLoading = false;
  String? _error;

  OrderProvider(this._orderRepository);

  List<OrderModel> get orders => _orders;
  GenerateOrderModel? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchOrders(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final inProgressOrders = await _orderRepository.getOrdersInProgress(userId);
      final completedOrders = await _orderRepository.getCompletedOrders(userId);
      _orders = [...inProgressOrders, ...completedOrders];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> generateOrder(String userId, String addressId, String deliveryDate, String orderNote) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentOrder = await _orderRepository.generateOrder(userId, addressId, deliveryDate, orderNote);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cancelOrder(String orderId, String userId) async {
    try {
      await _orderRepository.cancelOrder(orderId, userId);
      await fetchOrders(userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updatePaymentStatus(String orderId, String razorpayId, String userId) async {
    try {
      await _orderRepository.updatePaymentStatus(orderId, razorpayId);
      await fetchOrders(userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}