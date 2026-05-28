import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../models/ride_model.dart';
import '../../services/ride_service.dart';

class FindRideScreen extends StatefulWidget {
  const FindRideScreen({super.key});

  @override
  State<FindRideScreen> createState() => _FindRideScreenState();
}

class _FindRideScreenState extends State<FindRideScreen> {
  final _fromController = TextEditingController(text: 'Gulshan-e-Iqbal');
  final _toController = TextEditingController(text: 'I.I. Chundrigar Road');
  final _rideService = RideService();

  List<RideModel> _rides = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _search();
  }

  Future<void> _search() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      // INTEGRATION POINT: Google Geocoding would resolve text → lat/lng here.
      // For MVP we send no geo filter — backend returns all upcoming rides.
      final rides = await _rideService.searchRides(
        departureAfter: DateTime.now(),
        minSeats: 1,
      );
      if (!mounted) return;
      setState(() {
        _rides = rides;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Find a Ride'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _search),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _fromController,
              decoration: const InputDecoration(
                labelText: 'Pickup Location',
                prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _toController,
              decoration: const InputDecoration(
                labelText: 'Dropoff Location',
                prefixIcon: Icon(Icons.flag_outlined, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isLoading ? 'Searching...' : '${_rides.length} matching rides',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                if (_isLoading)
                  const SizedBox(
                    width: 16, height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildResults()),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            TextButton(onPressed: _search, child: const Text('Try Again')),
          ],
        ),
      );
    }
    if (_isLoading && _rides.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_rides.isEmpty) {
      return const Center(
        child: Text(
          'No rides match right now. Try widening your time window.',
          style: TextStyle(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      );
    }
    return ListView.builder(
      itemCount: _rides.length,
      itemBuilder: (context, i) => _buildRideCard(_rides[i]),
    );
  }

  Widget _buildRideCard(RideModel ride) {
    final time = '${ride.departureTime.hour.toString().padLeft(2, '0')}:${ride.departureTime.minute.toString().padLeft(2, '0')}';
    final initial = (ride.driverName?.isNotEmpty ?? false) ? ride.driverName![0] : '?';
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.rideDetail, arguments: ride.id),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                        child: Text(initial, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ride.driverName ?? 'Driver', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          Text(ride.driverCompany ?? '—', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${ride.seatsAvailable} seats left',
                      style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('${ride.fromName} ➔ ${ride.toName}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(time, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    ],
                  ),
                  Text(
                    'Rs. ${ride.pricePerSeat.toStringAsFixed(0)}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
