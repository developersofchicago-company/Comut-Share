"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const pricing_service_1 = require("../services/pricing.service");
const router = (0, express_1.Router)();
// POST /api/pricing/calculate
router.post('/calculate', (req, res) => {
    try {
        const { distanceKm, petrolRate, seats, efficiencyKmPerL } = req.body;
        // Validation
        if (!distanceKm || typeof distanceKm !== 'number' || distanceKm <= 0) {
            res.status(400).json({ error: 'Valid distanceKm (number > 0) is required' });
            return;
        }
        if (!petrolRate || typeof petrolRate !== 'number' || petrolRate <= 0) {
            res.status(400).json({ error: 'Valid petrolRate (number > 0) is required' });
            return;
        }
        if (!seats || typeof seats !== 'number' || seats <= 0) {
            res.status(400).json({ error: 'Valid seats count (number > 0) is required' });
            return;
        }
        const pricingRequest = {
            distanceKm,
            petrolRate,
            seats,
            efficiencyKmPerL: efficiencyKmPerL ? Number(efficiencyKmPerL) : undefined
        };
        const results = pricing_service_1.PricingService.calculatePricing(pricingRequest);
        res.json(results);
    }
    catch (error) {
        res.status(500).json({ error: error.message || 'Internal Server Error' });
    }
});
exports.default = router;
