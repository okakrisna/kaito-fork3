/*
  # Add Price Field to Timeless Content

  1. Changes
    - Add `price` column to `timeless_content` table for tracking template pricing
    - Default value: 0 (untuk backward compatibility)
  
  2. Purpose
    - Enable automatic sales tracking from completed orders
    - Store agreed price for each wedding template
*/

-- Add price column if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'timeless_content' AND column_name = 'price'
  ) THEN
    ALTER TABLE timeless_content 
    ADD COLUMN price numeric(10, 2) DEFAULT 0;
  END IF;
END $$;
