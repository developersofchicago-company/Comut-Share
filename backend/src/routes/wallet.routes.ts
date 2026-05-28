// Wallet REST endpoints.

import { Router, Request, Response } from 'express';
import { requireAuth } from '../middleware/auth.middleware';
import { WalletService } from '../services/wallet.service';

const router = Router();

router.get('/balance', requireAuth, async (req: Request, res: Response) => {
  try {
    const balance = await WalletService.getBalance(req.user!.id);
    res.json({ balance });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

router.get('/transactions', requireAuth, async (req: Request, res: Response) => {
  try {
    const limit = req.query.limit ? Number(req.query.limit) : 50;
    const transactions = await WalletService.getTransactions(req.user!.id, limit);
    res.json({ transactions });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

router.post('/topup', requireAuth, async (req: Request, res: Response) => {
  try {
    const { amount, payment_method, payment_reference } = req.body;
    if (!amount || amount <= 0) {
      res.status(400).json({ error: 'amount must be positive' });
      return;
    }
    // INTEGRATION POINT: validate payment_reference against JazzCash/EasyPaisa
    // before crediting. For now, we trust the client (DEV ONLY).
    console.log(`[wallet] topup pending integration: ${payment_method} ref=${payment_reference}`);
    const balance = await WalletService.topup(req.user!.id, Number(amount));
    res.json({ balance });
  } catch (e: any) {
    res.status(400).json({ error: e.message });
  }
});

router.post('/withdraw', requireAuth, async (req: Request, res: Response) => {
  try {
    const { amount, bank_account, bank_name } = req.body;
    if (!amount || amount <= 0) {
      res.status(400).json({ error: 'amount must be positive' });
      return;
    }
    // INTEGRATION POINT: enqueue 1LINK transfer to bank_account/bank_name
    console.log(`[wallet] withdraw pending integration: ${bank_name} acct=${bank_account}`);
    const balance = await WalletService.withdraw(req.user!.id, Number(amount));
    res.json({ balance });
  } catch (e: any) {
    res.status(400).json({ error: e.message });
  }
});

export default router;
