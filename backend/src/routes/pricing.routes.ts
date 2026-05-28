import { Router, Request, Response } from 'express';
import { PricingService, PricingRequest } from '../services/pricing.service';

const router = Router();

// POST /api/pricing/calculate
router.post('/calculate', (req: Request, res: Response) => {
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

    const pricingRequest: PricingRequest = {
      distanceKm,
      petrolRate,
      seats,
      efficiencyKmPerL: efficiencyKmPerL ? Number(efficiencyKmPerL) : undefined
    };

    const results = PricingService.calculatePricing(pricingRequest);
    res.json(results);
  } catch (error: any) {
    res.status(500).json({ error: error.message || 'Internal Server Error' });
  }
});

export default router;
