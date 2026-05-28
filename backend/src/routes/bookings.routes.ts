// Booking REST endpoints.

import { Router, Request, Response } from 'express';
import { requireAuth } from '../middleware/auth.middleware';
import { BookingsService } from '../services/bookings.service';

const router = Router();

// ── POST /api/bookings — request a seat ──────────────
router.post('/', requireAuth, async (req: Request, res: Response) => {
  try {
    const { ride_id, seats_booked, emergency_contact, message } = req.body;
    if (!ride_id) {
      res.status(400).json({ error: 'ride_id is required' });
      return;
    }
    const booking = await BookingsService.create(req.user!.id, {
      ride_id,
      seats_booked,
      emergency_contact,
      message,
    });
    res.status(201).json({ booking });
  } catch (e: any) {
    res.status(400).json({ error: e.message });
  }
});

// ── PUT /api/bookings/:id — driver accept/decline; rider cancel ──
router.put('/:id', requireAuth, async (req: Request, res: Response) => {
  try {
    const { status } = req.body;
    if (!status) {
      res.status(400).json({ error: 'status is required' });
      return;
    }
    const booking = await BookingsService.updateStatus(req.params.id, req.user!.id, status);
    res.json({ booking });
  } catch (e: any) {
    res.status(403).json({ error: e.message });
  }
});

// ── POST /api/bookings/:id/verify — driver verifies pickup code ──
router.post('/:id/verify', requireAuth, async (req: Request, res: Response) => {
  try {
    const { code } = req.body;
    if (!code) {
      res.status(400).json({ error: 'code is required' });
      return;
    }
    const booking = await BookingsService.verifyPickup(req.params.id, req.user!.id, code);
    res.json({ booking });
  } catch (e: any) {
    res.status(403).json({ error: e.message });
  }
});

// ── GET /api/bookings/mine — rider's bookings ────────
router.get('/mine', requireAuth, async (req: Request, res: Response) => {
  try {
    const bookings = await BookingsService.getByRider(req.user!.id);
    res.json({ bookings });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

// ── GET /api/bookings/incoming — driver's incoming requests ──
router.get('/incoming', requireAuth, async (req: Request, res: Response) => {
  try {
    const bookings = await BookingsService.getByDriver(req.user!.id);
    res.json({ bookings });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

export default router;
