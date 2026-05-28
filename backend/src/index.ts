import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import pricingRoutes from './routes/pricing.routes';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

// API Routes
app.use('/api/pricing', pricingRoutes);

app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', message: 'Corporate Carpool Platform API is running' });
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
