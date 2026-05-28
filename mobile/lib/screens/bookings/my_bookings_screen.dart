import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../models/booking_model.dart';
import '../../services/ride_service.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  final _rideService = RideService();
  List<BookingModel> _bookings = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final bookings = await _rideService.getMyBookings();
      if (!mounted) return;
      setState(() {
        _bookings = bookings;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Color _statusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.requested: return Colors.orange;
      case BookingStatus.accepted: return AppColors.primary;
      case BookingStatus.started: return Colors.blue;
      case BookingStatus.completed: return Colors.green;
      case BookingStatus.declined:
      case BookingStatus.cancelled: return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Bookings'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _load)],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
              : _bookings.isEmpty
                  ? const Center(
                      child: Text('No bookings yet.\nFind a ride to get started.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textSecondary)),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _bookings.length,
                      itemBuilder: (context, i) {
                        final b = _bookings[i];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            onTap: () {
                              if (b.isActive) {
                                Navigator.pushNamed(context, AppRoutes.activeRide, arguments: b.rideId);
                              } else {
                                Navigator.pushNamed(context, AppRoutes.rideDetail, arguments: b.rideId);
                              }
                            },
                            leading: CircleAvatar(
                              backgroundColor: _statusColor(b.status).withValues(alpha: 0.15),
                              child: Icon(Icons.directions_car, color: _statusColor(b.status)),
                            ),
                            title: Text(
                              'Booking #${b.id.substring(0, 8)}',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Status: ${b.status.name}', style: TextStyle(color: _statusColor(b.status), fontSize: 12)),
                                if (b.isAccepted)
                                  Text('Pickup code: ${b.verificationCode}',
                                      style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
