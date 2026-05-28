-- PostgreSQL Database Schema for Corporate Carpool Platform (ComutShare)
-- Designed for Karachi launch with corporate whitelist, safety layers, and wallet escrow

-- Enable UUID extension for secure random IDs
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Corporate Companies Table
CREATE TABLE companies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    domain VARCHAR(100) UNIQUE NOT NULL, -- e.g., 'hbl.com', 'systemsltd.com'
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Users Table (Enhanced)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    phone VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE,
    company_id UUID REFERENCES companies(id) ON DELETE SET NULL,
    full_name VARCHAR(100),
    profile_photo TEXT,
    gender VARCHAR(10) CHECK (gender IN ('male', 'female', 'other')),
    home_area VARCHAR(100),
    office_area VARCHAR(100),
    working_hours VARCHAR(50),
    cnic_front TEXT,
    cnic_back TEXT,
    cnic_verified BOOLEAN DEFAULT FALSE,
    is_driver BOOLEAN DEFAULT FALSE,
    reputation_score NUMERIC(3, 2) DEFAULT 5.00 CHECK (reputation_score BETWEEN 0 AND 5),
    wallet_balance NUMERIC(10, 2) DEFAULT 0.00 CHECK (wallet_balance >= 0.00),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. User Preferences Table
CREATE TABLE user_preferences (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    departure_window VARCHAR(50), -- e.g., '08:15 AM - 08:45 AM'
    smoking_allowed BOOLEAN DEFAULT FALSE,
    music_allowed BOOLEAN DEFAULT TRUE,
    women_only BOOLEAN DEFAULT FALSE,
    emergency_contact_phone VARCHAR(20),
    emergency_contact_name VARCHAR(100),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. Vehicles Table
CREATE TABLE vehicles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    make VARCHAR(50) NOT NULL, -- e.g., 'Toyota'
    model VARCHAR(50) NOT NULL, -- e.g., 'Corolla'
    year INT,
    color VARCHAR(30),
    registration_number VARCHAR(30) UNIQUE NOT NULL,
    license_photo TEXT,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 5. Rides Table
CREATE TABLE rides (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    driver_id UUID REFERENCES users(id) ON DELETE CASCADE,
    vehicle_id UUID REFERENCES vehicles(id) ON DELETE SET NULL,
    from_name TEXT NOT NULL,
    from_lat NUMERIC(9, 6) NOT NULL,
    from_lng NUMERIC(9, 6) NOT NULL,
    to_name TEXT NOT NULL,
    to_lat NUMERIC(9, 6) NOT NULL,
    to_lng NUMERIC(9, 6) NOT NULL,
    departure_time TIMESTAMP WITH TIME ZONE NOT NULL,
    seats_available INT NOT NULL CHECK (seats_available >= 0),
    total_seats INT NOT NULL CHECK (total_seats > 0),
    price_per_seat NUMERIC(8, 2) NOT NULL CHECK (price_per_seat >= 0.00),
    notes TEXT,
    status VARCHAR(20) DEFAULT 'published' CHECK (status IN ('published', 'started', 'completed', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 6. Bookings Table
CREATE TABLE bookings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ride_id UUID REFERENCES rides(id) ON DELETE CASCADE,
    rider_id UUID REFERENCES users(id) ON DELETE CASCADE,
    seats_booked INT DEFAULT 1 CHECK (seats_booked > 0),
    status VARCHAR(20) DEFAULT 'requested' CHECK (status IN ('requested', 'accepted', 'declined', 'started', 'completed', 'cancelled')),
    verification_code VARCHAR(4) NOT NULL, -- 4-digit code to complete ride
    emergency_contact VARCHAR(20),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 7. Transactions Table (Wallet Ledger)
CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    booking_id UUID REFERENCES bookings(id) ON DELETE SET NULL,
    type VARCHAR(20) NOT NULL CHECK (type IN ('deposit', 'withdraw', 'payment_debit', 'payment_credit', 'refund', 'bonus')),
    amount NUMERIC(10, 2) NOT NULL CHECK (amount > 0.00),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 8. Ratings Table
CREATE TABLE ratings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    from_user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    to_user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    ride_id UUID REFERENCES rides(id) ON DELETE SET NULL,
    stars INT NOT NULL CHECK (stars BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 9. OGRA Petrol Rates Table
CREATE TABLE ogra_rates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    rate NUMERIC(6, 2) NOT NULL CHECK (rate > 0.00),
    effective_date DATE UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 10. Chat Messages Table
CREATE TABLE chat_messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ride_id UUID REFERENCES rides(id) ON DELETE CASCADE,
    sender_id UUID REFERENCES users(id) ON DELETE CASCADE,
    text TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 11. Saved Favorite Routes Table
CREATE TABLE saved_routes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    from_name TEXT NOT NULL,
    from_lat NUMERIC(9, 6) NOT NULL,
    from_lng NUMERIC(9, 6) NOT NULL,
    to_name TEXT NOT NULL,
    to_lat NUMERIC(9, 6) NOT NULL,
    to_lng NUMERIC(9, 6) NOT NULL,
    route_label VARCHAR(50) NOT NULL, -- e.g., 'Home', 'Office'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 12. Referrals Table
CREATE TABLE referrals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    referrer_id UUID REFERENCES users(id) ON DELETE CASCADE,
    referred_phone VARCHAR(20) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'verified', 'rewarded')),
    reward_amount NUMERIC(8, 2) DEFAULT 200.00,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 13. Safety Blocklist / Abuse Reports Table
CREATE TABLE reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    reporter_id UUID REFERENCES users(id) ON DELETE CASCADE,
    reported_id UUID REFERENCES users(id) ON DELETE CASCADE,
    ride_id UUID REFERENCES rides(id) ON DELETE SET NULL,
    reason VARCHAR(100) NOT NULL,
    details TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ── INDEXES FOR MAXIMUM QUERY PERFORMANCE ───────────────────
CREATE INDEX idx_users_company ON users(company_id);
CREATE INDEX idx_rides_driver ON rides(driver_id);
CREATE INDEX idx_rides_status ON rides(status);
CREATE INDEX idx_bookings_ride ON bookings(ride_id);
CREATE INDEX idx_bookings_rider ON bookings(rider_id);
CREATE INDEX idx_transactions_user ON transactions(user_id);
CREATE INDEX idx_chat_ride ON chat_messages(ride_id);
CREATE INDEX idx_saved_routes_user ON saved_routes(user_id);
CREATE INDEX idx_referrals_referrer ON referrals(referrer_id);
CREATE INDEX idx_reports_reported ON reports(reported_id);

-- ── SEED INITIAL DEMO DATA (Karachi Whitelist) ───────────────
INSERT INTO companies (name, domain) VALUES 
('Habib Bank Limited', 'hbl.com'),
('Systems Limited', 'systemsltd.com'),
('Developers of Chicago', 'developersofchicago.com'),
('Finastra Pakistan', 'finastra.com')
ON CONFLICT (domain) DO NOTHING;

INSERT INTO ogra_rates (rate, effective_date) VALUES 
(409.78, '2026-05-16')
ON CONFLICT (effective_date) DO NOTHING;
