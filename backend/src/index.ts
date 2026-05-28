import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';

import pricingRoutes from './routes/pricing.routes';
import ridesRoutes from './routes/rides.routes';
import bookingsRoutes from './routes/bookings.routes';
import walletRoutes from './routes/wallet.routes';
import ratingsRoutes from './routes/ratings.routes';
import ograRoutes from './routes/ogra.routes';
import { startOgraCron } from './services/ogra.scraper';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json({ limit: '2mb' }));

// API Routes
app.use('/api/pricing', pricingRoutes);
app.use('/api/rides', ridesRoutes);
app.use('/api/bookings', bookingsRoutes);
app.use('/api/wallet', walletRoutes);
app.use('/api/ratings', ratingsRoutes);
app.use('/api/ogra', ograRoutes);

app.get('/api/health', (_req, res) => {
  res.json({
    status: 'OK',
    service: 'ComutShare API',
    version: '1.0.0',
    timestamp: new Date().toISOString(),
  });
});

// 404 catch-all
app.use((req, res) => {
  res.status(404).json({ error: `Route not found: ${req.method} ${req.path}` });
});

app.listen(PORT, () => {
  console.log(`ComutShare API running on port ${PORT}`);
  // Start the OGRA price-watcher cron
  if (process.env.ENABLE_OGRA_CRON !== 'false') {
    startOgraCron();
  }
});
