import { Client } from 'pg';
import dotenv from 'dotenv';
import path from 'path';

dotenv.config({ path: path.resolve(__dirname, '../../.env') });

const client = new Client({
  connectionString: process.env.DATABASE_URL,
  ssl: {
    rejectUnauthorized: false
  }
});

async function main() {
  await client.connect();
  console.log('Connected to Supabase PostgreSQL, running waitlist table query...');
  await client.query(`
    CREATE TABLE IF NOT EXISTS waitlist_leads (
      id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
      email VARCHAR(255) UNIQUE NOT NULL,
      role VARCHAR(50) DEFAULT 'rider',
      created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
    );
  `);
  console.log('waitlist_leads table created successfully in Supabase!');
  await client.end();
}

main().catch(console.error);
