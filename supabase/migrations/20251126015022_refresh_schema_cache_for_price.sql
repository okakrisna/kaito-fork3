/*
  # Refresh Schema Cache for Price Column

  1. Purpose
    - Force Supabase to refresh its schema cache
    - Ensure 'price' column is recognized in timeless_content table
  
  2. Changes
    - Add a comment to the price column to trigger cache refresh
    - This is a safe operation that doesn't affect data

  3. Notes
    - The price column already exists but isn't in the schema cache
    - This migration forces PostgREST to reload the schema
*/

-- Add comment to price column to trigger schema cache refresh
COMMENT ON COLUMN timeless_content.price IS 'Price of the wedding template package (in IDR)';

-- Notify PostgREST to reload schema (this happens automatically after migration)
NOTIFY pgrst, 'reload schema';