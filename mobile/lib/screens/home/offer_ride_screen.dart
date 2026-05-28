import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../services/ride_service.dart';
import '../../widgets/custom_button.dart';

class OfferRideScreen extends StatefulWidget {
  const OfferRideScreen({super.key});

  @override
  State<OfferRideScreen> createState() => _OfferRideScreenState();
}

class _OfferRideScreenState extends State<OfferRideScreen> {
  final _fromController = TextEditingController(text: 'DHA Phase 6');
  final _toController = TextEditingController(text: 'Shahrah-e-Faisal');
  final _distanceController = TextEditingController(text: '20');
  final _notesController = TextEditingController();
  final _rideService = RideService();

  int _seats = 3;
  DateTime _departureTime = DateTime.now().add(const Duration(hours: 1));
  bool _isLoading = false;

  /// Compute suggested price via the proposal formula.
  double get _suggestedPrice {
    final distance = double.tryParse(_distanceController.text) ?? 20;
    final totalFuel = (distance / Constants.defaultEfficiency) * Constants.defaultPetrolRate;
    final margin = Constants.driverMarginPerKm * distance;
    final platformMultiplier = 1 - Constants.platformCommission;
    return (totalFuel + margin) / (_seats * platformMultiplier);
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade700, behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _pickDepartureTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _departureTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (pickedDate == null || !mounted) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_departureTime),
    );
    if (pickedTime == null) return;
    setState(() {
      _departureTime = DateTime(
        pickedDate.year, pickedDate.month, pickedDate.day,
        pickedTime.hour, pickedTime.minute,
      );
    });
  }

  Future<void> _publish() async {
    final distance = double.tryParse(_distanceController.text);
    if (distance == null || distance <= 0) {
      _showError('Enter a valid distance');
      return;
    }
    setState(() => _isLoading = true);
    try {
      // TODO geo-lookup: convert from/to text → lat/lng via Google Maps Geocoding.
      // For MVP we send placeholder lat/lng — backend stores text as truth.
      await _rideService.createRide({
        'from_name': _fromController.text.trim(),
        'from_lat': 24.8607, // INTEGRATION POINT: Google Geocoding API
        'from_lng': 67.0011,
        'to_name': _toController.text.trim(),
        'to_lat': 24.8607,
        'to_lng': 67.0011,
        'departure_time': _departureTime.toIso8601String(),
        'total_seats': _seats,
        'price_per_seat': _suggestedPrice.roundToDouble(),
        'notes': _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ride published successfully!'), backgroundColor: AppColors.primary),
      );
      Navigator.pop(context);
    } catch (e) {
      _showError('Failed to publish: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _distanceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Offer a Ride')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _fromController,
              decoration: const InputDecoration(
                labelText: 'Departure Location',
                prefixIcon: Icon(Icons.my_location, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _toController,
              decoration: const InputDecoration(
                labelText: 'Destination Location',
                prefixIcon: Icon(Icons.location_on, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _distanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Distance (km, one-way)',
                prefixIcon: Icon(Icons.straighten, color: AppColors.textMuted),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),

            // Departure time picker
            const Text('Departure Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDepartureTime,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                  color: AppColors.surfaceDim,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: AppColors.textMuted),
                    const SizedBox(width: 12),
                    Text(
                      '${_departureTime.day}/${_departureTime.month} at ${_departureTime.hour.toString().padLeft(2, '0')}:${_departureTime.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text('Available Seats', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Row(
              children: List.generate(4, (index) {
                final seatNum = index + 1;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ChoiceChip(
                    label: Text('$seatNum'),
                    selected: _seats == seatNum,
                    onSelected: (selected) {
                      if (selected) setState(() => _seats = seatNum);
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                hintText: 'AC car, no smoking, female passengers welcome',
              ),
            ),
            const SizedBox(height: 32),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Suggested Seat Price', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                      Text('Rs. ${_suggestedPrice.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Live OGRA fuel rate (Rs. ${Constants.defaultPetrolRate.toStringAsFixed(2)}/L) × ${Constants.defaultEfficiency} km/L efficiency + Rs. ${Constants.driverMarginPerKm}/km driver margin.',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              label: 'Publish Ride Offer',
              isLoading: _isLoading,
              onPressed: _publish,
            ),
          ],
        ),
      ),
    );
  }
}
