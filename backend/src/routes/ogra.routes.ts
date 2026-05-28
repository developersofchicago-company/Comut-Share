// OGRA petrol price endpoint — public read for clients to display "live" rate.

import { Router, Request, Response } from 'express';
import { OgraScraper } from '../services/ogra.scraper';

const router = Router();

// Public: anyone (including unauthenticated landing-page visitors) can read the current rate.
router.get('/current', async (_req: Request, res: Response) => {
  try {
    const rate = await OgraScraper.getCurrentRate();
    res.json({ rate, source: 'OGRA', currency: 'PKR', unit: 'per litre' });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// Manual trigger (admin / dev tool)
router.post('/refresh', async (_req: Request, res: Response) => {
  try {
    const result = await OgraScraper.runOnce();
    res.json(result);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

export default router;
