// JWT verification middleware.
// Verifies the bearer token against Supabase auth, attaches the user to req.
//
// All routes that require authentication should mount this middleware.

import { Request, Response, NextFunction } from 'express';
import { supabaseAdmin } from '../db/supabase.client';

// Augment Express Request with authenticated user info
declare global {
  // eslint-disable-next-line @typescript-eslint/no-namespace
  namespace Express {
    interface Request {
      user?: {
        id: string;
        email?: string;
        phone?: string;
        token: string;
      };
    }
  }
}

export async function requireAuth(req: Request, res: Response, next: NextFunction): Promise<void> {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      res.status(401).json({ error: 'Missing or malformed Authorization header' });
      return;
    }
    const token = authHeader.substring('Bearer '.length).trim();
    if (!token) {
      res.status(401).json({ error: 'Empty bearer token' });
      return;
    }

    // supabase.auth.getUser(token) verifies the JWT signature and expiry
    const { data, error } = await supabaseAdmin.auth.getUser(token);
    if (error || !data.user) {
      res.status(401).json({ error: 'Invalid or expired token' });
      return;
    }

    req.user = {
      id: data.user.id,
      email: data.user.email ?? undefined,
      phone: data.user.phone ?? undefined,
      token,
    };
    next();
  } catch (err: any) {
    res.status(401).json({ error: 'Auth verification failed', detail: err?.message });
  }
}
