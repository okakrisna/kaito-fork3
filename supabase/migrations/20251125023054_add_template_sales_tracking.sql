-- Add Template Sales Tracking
-- 
-- 1. New Tables
--    - template_sales: tracking penjualan untuk setiap template
-- 
-- 2. Security
--    - Enable RLS
--    - Policies for authenticated users

CREATE TABLE IF NOT EXISTS template_sales (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  template_name text NOT NULL CHECK (template_name IN ('timeless', 'elegant')),
  sale_date date NOT NULL DEFAULT CURRENT_DATE,
  couple_names text NOT NULL,
  price numeric(10, 2) NOT NULL DEFAULT 0,
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE template_sales ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view sales data"
  ON template_sales
  FOR SELECT
  USING (true);

CREATE POLICY "Authenticated users can insert sales"
  ON template_sales
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update sales"
  ON template_sales
  FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Authenticated users can delete sales"
  ON template_sales
  FOR DELETE
  TO authenticated
  USING (true);

CREATE INDEX IF NOT EXISTS idx_template_sales_date ON template_sales(sale_date DESC);
CREATE INDEX IF NOT EXISTS idx_template_sales_template ON template_sales(template_name);