"use strict";
// Pricing Calculation Service
Object.defineProperty(exports, "__esModule", { value: true });
exports.PricingService = void 0;
class PricingService {
    // Defaults from .env / specifications
    static DEFAULT_EFFICIENCY = 10.0; // km/L in Karachi traffic
    static DRIVER_MARGIN_PER_KM = 8.0; // Rs. / km
    static PLATFORM_COMMISSION = 0.10; // 10%
    /**
     * Calculates mathematically consistent pricing for carpool rides.
     *
     * Formula:
     * Total Fuel Cost = (Distance / Efficiency) * Petrol Rate
     * Driver Total Margin = Driver Margin per km * Distance
     * Rider Pays Seat Price = (Total Fuel Cost + Driver Total Margin) / (Seats * (1 - Platform Commission))
     * Driver Net Earnings = (Seats * Rider Pays Seat Price * (1 - Platform Commission)) - Total Fuel Cost
     *
     * This ensures the Driver makes exactly their target margin after platform commission is paid.
     */
    static calculatePricing(params) {
        const { distanceKm, petrolRate, seats } = params;
        const efficiency = params.efficiencyKmPerL || this.DEFAULT_EFFICIENCY;
        // Fuel cost calculation
        const totalFuelCost = (distanceKm / efficiency) * petrolRate;
        // Driver margin covering depreciation, tyres, oil wear
        const driverMargin = this.DRIVER_MARGIN_PER_KM * distanceKm;
        // Seat price calculation to cover fuel and margin, and offset platform commission
        const platformMultiplier = 1 - this.PLATFORM_COMMISSION;
        const riderPaysSeatPrice = (totalFuelCost + driverMargin) / (seats * platformMultiplier);
        // Platform service fee taken from the pool
        const platformFee = (seats * riderPaysSeatPrice) * this.PLATFORM_COMMISSION;
        // Driver net earnings: revenue from riders (after commission) minus fuel costs
        const driverNetEarnings = (seats * riderPaysSeatPrice * platformMultiplier) - totalFuelCost;
        return {
            totalFuelCost: parseFloat(totalFuelCost.toFixed(2)),
            driverMargin: parseFloat(driverMargin.toFixed(2)),
            platformFee: parseFloat(platformFee.toFixed(2)),
            riderPaysSeatPrice: parseFloat(riderPaysSeatPrice.toFixed(2)),
            driverNetEarnings: parseFloat(driverNetEarnings.toFixed(2))
        };
    }
}
exports.PricingService = PricingService;
