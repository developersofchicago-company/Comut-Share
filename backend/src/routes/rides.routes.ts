// Ride REST endpoints.
// All routes require authentication via requireAuth middleware.

import { Router, Request, Response } from 'express';
import { requireAuth } from '../middleware/auth.middleware';
import { RidesService, CreateRideInput, SearchRidesParams } from '../services/rides.service';

const router = Router();

// ── POST /api/rides — driver posts a new ride ────────
router.post('/', requireAuth, async (req: Request, res: Response) => {
  try {
    const body = req.body as CreateRideInput;

    // Validation
    const required = ['from_name', 'from_lat', 'from_lng', 'to_name', 'to_lat', 'to_lng', 'departure_time', 'total_seats', 'price_per_seat'];
    for (const f of required) {
      if (body[f as keyof CreateRideInput] === undefined || body[f as keyof CreateRideInput] === null) {
        res.status(400).json({ error: `Missing required field: ${f}` });
        return;
      }
    }
    if (body.total_seats < 1 || body.total_seats > 4) {
      res.status(400).json({ error: 'total_seats must be between 1 and 4' });
      return;
    }
    if (body.price_per_seat < 0) {
      res.status(400).json({ error: 'price_per_seat must be non-negative' });
      return;
    }
    if (new Date(body.departure_time).getTime() < Date.now() - 60_000) {
      res.status(400).json({ error: 'departure_time must be in the future' });
      return;
    }

    const ride = await RidesService.create(req.user!.id, body);
    res.status(201).json({ ride });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// ── GET /api/rides — search rides ────────────────────
router.get('/', requireAuth, async (req: Request, res: Response) => {
  try {
    const params: SearchRidesParams = {
      from_lat: req.query.from_lat ? Number(req.query.from_lat) : undefined,
      from_lng: req.query.from_lng ? Number(req.query.from_lng) : undefined,
      to_lat: req.query.to_lat ? Number(req.query.to_lat) : undefined,
      to_lng: req.query.to_lng ? Number(req.query.to_lng) : undefined,
      departure_after: req.query.departure_after as string | undefined,
      departure_before: req.query.departure_before as string | undefined,
      min_seats: req.query.min_seats ? Number(req.query.min_seats) : undefined,
    };
    const rides = await RidesService.search(params);
    res.json({ rides });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// ── GET /api/rides/mine — driver's own rides ─────────
router.get('/mine', requireAuth, async (req: Request, res: Response) => {
  try {
    const rides = await RidesService.getByDriver(req.user!.id);
    res.json({ rides });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// ── GET /api/rides/:id — ride detail ─────────────────
router.get('/:id', requireAuth, async (req: Request, res: Response) => {
  try {
    const ride = await RidesService.getById(req.params.id);
    res.json({ ride });
  } catch (e: any) {
    res.status(404).json({ error: e.message });
  }
});

// ── PUT /api/rides/:id/start ─────────────────────────
router.put('/:id/start', requireAuth, async (req: Request, res: Response) => {
  try {
    const ride = await RidesService.start(req.params.id, req.user!.id);
    res.json({ ride });
  } catch (e: any) {
    res.status(403).json({ error: e.message });
  }
});

// ── PUT /api/rides/:id/complete ──────────────────────
router.put('/:id/complete', requireAuth, async (req: Request, res: Response) => {
  try {
    const ride = await RidesService.complete(req.params.id, req.user!.id);
    res.json({ ride });
  } catch (e: any) {
    res.status(403).json({ error: e.message });
  }
});

// ── PUT /api/rides/:id/cancel ────────────────────────
router.put('/:id/cancel', requireAuth, async (req: Request, res: Response) => {
  try {
    const ride = await RidesService.cancel(req.params.id, req.user!.id);
    res.json({ ride });
  } catch (e: any) {
    res.status(403).json({ error: e.message });
  }
});

export default router;
