import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../models/ride_model.dart';
import '../../services/ride_service.dart';
import '../../widgets/custom_button.dart';

class RideDetailScreen extends StatefulWidget {
  final String rideId;
  const RideDetailScreen({super.key, required this.rideId});

  @override
  State<RideDetailScreen> createState() => _RideDetailScreenState();
}

class _RideDetailScreenState extends State<RideDetailScreen> {
  final _rideService = RideService();
  RideModel? _ride;
  bool _isLoading = true;
  bool _isBooking = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRide();
  }

  Future<void> _loadRide() async {
    try {
      final ride = await _rideService.getRide(widget.rideId);
      if (!mounted) return;
      setState(() {
        _ride = ride;
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

  Future<void> _requestSeat() async {
    setState(() => _isBooking = true);
    try {
      final booking = await _rideService.requestSeat(widget.rideId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Seat requested. Pickup code: ${booking.verificationCode}'),
          backgroundColor: AppColors.primary,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking failed: ${e.toString()}'), backgroundColor: Colors.red.shade700),
      );
    } finally {
      if (mounted) setState(() => _isBooking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Ride Details')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : _error != null
                ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
                : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    final ride = _ride!;
    final initial = (ride.driverName?.isNotEmpty ?? false) ? ride.driverName![0] : '?';
    final time = '${ride.departureTime.hour.toString().padLeft(2, '0')}:${ride.departureTime.minute.toString().padLeft(2, '0')}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                    radius: 28,
                    child: Text(initial, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ride.driverName ?? 'Driver',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(ride.driverCompany ?? '—',
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                      if (ride.driverRating != null)
                        Text('★ ${ride.driverRating!.toStringAsFixed(1)}',
                            style: const TextStyle(fontSize: 12, color: AppColors.primary)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 12),
              _detailRow('Route', '${ride.fromName} ➔ ${ride.toName}'),
              const SizedBox(height: 12),
              _detailRow('Departure', time),
              const SizedBox(height: 12),
              _detailRow('Vehicle', ride.vehicleDisplay),
              const SizedBox(height: 12),
              _detailRow('Seats Available', '${ride.seatsAvailable} of ${ride.totalSeats}'),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Seat Price', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  Text('Rs. ${ride.pricePerSeat.toStringAsFixed(0)}',
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              if (ride.notes != null && ride.notes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDim,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(ride.notes!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ),
              ],
            ],
          ),
        ),
        const Spacer(),
        CustomButton(
          label: ride.hasAvailableSeats ? 'Request Seat' : 'No Seats Available',
          isLoading: _isBooking,
          enabled: ride.hasAvailableSeats,
          onPressed: _requestSeat,
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.chat, arguments: ride.id),
          icon: const Icon(Icons.chat_bubble_outline, color: AppColors.textMuted),
          label: const Text('Message Driver', style: TextStyle(color: AppColors.textMuted)),
        ),
      ],
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        Flexible(
          child: Text(value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        ),
      ],
    );
  }
}
