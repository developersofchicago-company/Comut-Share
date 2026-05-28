import '../config/constants.dart';

/// Client-side pricing calculator matching the backend formula.
/// Used for instant UI calculations without API calls.
class PricingService {
  /// Calculate rider seat price.
  ///
  /// Formula: (TotalFuelCost + TotalDriverMargin) / (Seats × (1 - PlatformCommission))
  static PricingResult calculate({
    required double distanceKm,
    double petrolRate = Constants.defaultPetrolRate,
    int seats = Constants.defaultSeats,
    double efficiency = Constants.defaultEfficiency,
  }) {
    final totalFuelCost = (distanceKm / efficiency) * petrolRate;
    final driverMargin = Constants.driverMarginPerKm * distanceKm;
    final platformMultiplier = 1 - Constants.platformCommission;
    final riderSeatPrice = (totalFuelCost + driverMargin) / (seats * platformMultiplier);
    final platformFee = (seats * riderSeatPrice) * Constants.platformCommission;
    final driverNetEarnings = (seats * riderSeatPrice * platformMultiplier) - totalFuelCost;

    return PricingResult(
      totalFuelCost: totalFuelCost,
      driverMargin: driverMargin,
      platformFee: platformFee,
      riderSeatPrice: riderSeatPrice,
      driverNetEarnings: driverNetEarnings,
    );
  }

  /// Monthly cost comparison (22 working days, round-trip).
  static MonthlyComparison monthlyComparison({
    required double distanceKm,
    double petrolRate = Constants.defaultPetrolRate,
    int seats = Constants.defaultSeats,
    double efficiency = Constants.defaultEfficiency,
  }) {
    const days = 22;
    final pricing = calculate(
      distanceKm: distanceKm,
      petrolRate: petrolRate,
      seats: seats,
      efficiency: efficiency,
    );

    final monthlyDistance = distanceKm * 2 * days;
    final soloMonthlyCost = (monthlyDistance / efficiency) * petrolRate;
    final rideHailingMonthly = distanceKm * 45 * 2 * days; // ~Rs.45/km for Careem/inDrive
    final riderMonthlyCost = pricing.riderSeatPrice * 2 * days;
    final driverMonthlyEarnings = pricing.driverNetEarnings * 2 * days;
    final co2Saved = monthlyDistance * 0.12 * seats; // kg CO2

    return MonthlyComparison(
      soloDriving: soloMonthlyCost,
      rideHailing: rideHailingMonthly,
      riderCost: riderMonthlyCost,
      driverEarnings: driverMonthlyEarnings,
      co2Saved: co2Saved,
      savingsVsCareem: ((1 - riderMonthlyCost / rideHailingMonthly) * 100),
      savingsVsSolo: ((1 - riderMonthlyCost / soloMonthlyCost) * 100),
    );
  }
}

class PricingResult {
  final double totalFuelCost;
  final double driverMargin;
  final double platformFee;
  final double riderSeatPrice;
  final double driverNetEarnings;

  PricingResult({
    required this.totalFuelCost,
    required this.driverMargin,
    required this.platformFee,
    required this.riderSeatPrice,
    required this.driverNetEarnings,
  });

  int get roundedSeatPrice => riderSeatPrice.round();
  int get roundedDriverEarnings => driverNetEarnings.round();
}

class MonthlyComparison {
  final double soloDriving;
  final double rideHailing;
  final double riderCost;
  final double driverEarnings;
  final double co2Saved;
  final double savingsVsCareem;
  final double savingsVsSolo;

  MonthlyComparison({
    required this.soloDriving,
    required this.rideHailing,
    required this.riderCost,
    required this.driverEarnings,
    required this.co2Saved,
    required this.savingsVsCareem,
    required this.savingsVsSolo,
  });
}
