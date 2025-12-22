-- Create payments table for QPAY integration
CREATE TABLE IF NOT EXISTS payments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  test_request_id UUID REFERENCES test_requests(id) ON DELETE SET NULL,
  amount_mnt INTEGER NOT NULL CHECK (amount_mnt > 0),
  payment_method TEXT NOT NULL CHECK (payment_method IN ('qpay', 'cash', 'card')),
  status TEXT NOT NULL CHECK (status IN ('pending', 'paid', 'failed', 'cancelled', 'refunded')),
  qpay_invoice_id TEXT UNIQUE,
  qpay_payment_id TEXT,
  qpay_qr_text TEXT,
  qpay_qr_image TEXT,
  qpay_urls TEXT[],
  description TEXT,
  paid_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_payments_user_id ON payments(user_id);
CREATE INDEX IF NOT EXISTS idx_payments_test_request_id ON payments(test_request_id);
CREATE INDEX IF NOT EXISTS idx_payments_status ON payments(status);
CREATE INDEX IF NOT EXISTS idx_payments_qpay_invoice_id ON payments(qpay_invoice_id);
CREATE INDEX IF NOT EXISTS idx_payments_created_at ON payments(created_at DESC);

-- Create updated_at trigger
CREATE OR REPLACE FUNCTION update_payments_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_payments_updated_at_trigger
  BEFORE UPDATE ON payments
  FOR EACH ROW
  EXECUTE FUNCTION update_payments_updated_at();

-- Row Level Security (RLS) Policies
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;

-- Users can view their own payments
CREATE POLICY "Users can view their own payments"
  ON payments FOR SELECT
  USING (auth.uid() = user_id);

-- Users can create their own payments
CREATE POLICY "Users can create their own payments"
  ON payments FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can update their own pending payments
CREATE POLICY "Users can update their own pending payments"
  ON payments FOR UPDATE
  USING (auth.uid() = user_id AND status = 'pending');

-- Admins can view all payments
CREATE POLICY "Admins can view all payments"
  ON payments FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- Admins can update all payments
CREATE POLICY "Admins can update all payments"
  ON payments FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- Create function to check payment completion
CREATE OR REPLACE FUNCTION check_payment_for_test_request(request_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM payments
    WHERE test_request_id = request_id
    AND status = 'paid'
  );
END;
$$ LANGUAGE plpgsql;

-- Add payment_required and payment_status columns to test_requests (optional)
ALTER TABLE test_requests
ADD COLUMN IF NOT EXISTS payment_required BOOLEAN DEFAULT true,
ADD COLUMN IF NOT EXISTS payment_status TEXT DEFAULT 'unpaid' CHECK (payment_status IN ('unpaid', 'paid', 'refunded'));

-- Create index on payment_status
CREATE INDEX IF NOT EXISTS idx_test_requests_payment_status ON test_requests(payment_status);

COMMENT ON TABLE payments IS 'Stores payment transactions for test requests';
COMMENT ON COLUMN payments.amount_mnt IS 'Payment amount in Mongolian Tugrik';
COMMENT ON COLUMN payments.payment_method IS 'Payment method: qpay, cash, or card';
COMMENT ON COLUMN payments.status IS 'Payment status: pending, paid, failed, cancelled, or refunded';
COMMENT ON COLUMN payments.qpay_invoice_id IS 'QPAY invoice ID from QPAY API';
COMMENT ON COLUMN payments.qpay_payment_id IS 'QPAY payment ID after successful payment';
COMMENT ON COLUMN payments.qpay_qr_text IS 'QR code text for QPAY payment';
COMMENT ON COLUMN payments.qpay_qr_image IS 'Base64 encoded QR code image';
COMMENT ON COLUMN payments.qpay_urls IS 'Array of payment URLs for different banks/apps';
