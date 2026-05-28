// Ratings — both rider and driver rate each other after a completed ride.
// Updates the rated user's average reputation_score.

import { Router, Request, Response } from 'express';
import { requireAuth } from '../middleware/auth.middleware';
import { supabaseAdmin } from '../db/supabase.client';

const router = Router();

router.post('/', requireAuth, async (req: Request, res: Response) => {
  try {
    const { ride_id, to_user_id, stars, comment } = req.body;
    if (!ride_id || !to_user_id || !stars) {
      res.status(400).json({ error: 'ride_id, to_user_id, stars are required' });
      return;
    }
    if (stars < 1 || stars > 5) {
      res.status(400).json({ error: 'stars must be 1-5' });
      return;
    }

    // Insert rating
    const { error: insErr } = await supabaseAdmin.from('ratings').insert({
      ride_id,
      from_user_id: req.user!.id,
      to_user_id,
      stars,
      comment: comment ?? null,
    });
    if (insErr) throw new Error(insErr.message);

    // Recompute average reputation for rated user
    const { data: ratings, error: aggErr } = await supabaseAdmin
      .from('ratings')
      .select('stars')
      .eq('to_user_id', to_user_id);
    if (aggErr) throw new Error(aggErr.message);

    const list = ratings ?? [];
    const avg = list.length
      ? list.reduce((sum, r: any) => sum + r.stars, 0) / list.length
      : 5.0;

    await supabaseAdmin
      .from('users')
      .update({ reputation_score: Number(avg.toFixed(2)) })
      .eq('id', to_user_id);

    res.status(201).json({ ok: true, average: Number(avg.toFixed(2)) });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

export default router;
