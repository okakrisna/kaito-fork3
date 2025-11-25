/*
  # Add Password Protection and Analytics Features

  1. New Fields
    - `password_protected` (boolean) - Enable/disable password protection
    - `invitation_password` (text) - Password for protected invitations
    - `views_count` (integer) - Track page views
    - `rsvp_count` (integer) - Track RSVP submissions
    - `last_viewed_at` (timestamptz) - Last view timestamp
    - `custom_domain` (text) - For custom domain support
    - `is_published` (boolean) - Publish/unpublish status

  2. Changes
    - Add default values for analytics fields
    - Add index on slug for faster lookups
    - Add index on status for filtering

  3. Security
    - Password field is encrypted at application level
    - RLS policies remain unchanged
*/

-- Add new fields to timeless_content table
DO $$
BEGIN
  -- Password Protection
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'timeless_content' AND column_name = 'password_protected'
  ) THEN
    ALTER TABLE timeless_content ADD COLUMN password_protected boolean DEFAULT false;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'timeless_content' AND column_name = 'invitation_password'
  ) THEN
    ALTER TABLE timeless_content ADD COLUMN invitation_password text;
  END IF;

  -- Analytics
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'timeless_content' AND column_name = 'views_count'
  ) THEN
    ALTER TABLE timeless_content ADD COLUMN views_count integer DEFAULT 0;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'timeless_content' AND column_name = 'rsvp_count'
  ) THEN
    ALTER TABLE timeless_content ADD COLUMN rsvp_count integer DEFAULT 0;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'timeless_content' AND column_name = 'last_viewed_at'
  ) THEN
    ALTER TABLE timeless_content ADD COLUMN last_viewed_at timestamptz;
  END IF;

  -- Custom Domain
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'timeless_content' AND column_name = 'custom_domain'
  ) THEN
    ALTER TABLE timeless_content ADD COLUMN custom_domain text;
  END IF;

  -- Publish Status
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'timeless_content' AND column_name = 'is_published'
  ) THEN
    ALTER TABLE timeless_content ADD COLUMN is_published boolean DEFAULT true;
  END IF;
END $$;

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_timeless_content_slug ON timeless_content(slug);
CREATE INDEX IF NOT EXISTS idx_timeless_content_status ON timeless_content(status);
CREATE INDEX IF NOT EXISTS idx_timeless_content_template ON timeless_content(template_name);
CREATE INDEX IF NOT EXISTS idx_timeless_content_published ON timeless_content(is_published);

-- Add comment for documentation
COMMENT ON COLUMN timeless_content.password_protected IS 'Enable password protection for invitation';
COMMENT ON COLUMN timeless_content.invitation_password IS 'Password required to view invitation (store hashed)';
COMMENT ON COLUMN timeless_content.views_count IS 'Total number of page views';
COMMENT ON COLUMN timeless_content.rsvp_count IS 'Total number of RSVP submissions';
COMMENT ON COLUMN timeless_content.last_viewed_at IS 'Timestamp of last page view';
COMMENT ON COLUMN timeless_content.custom_domain IS 'Custom domain for invitation (optional)';
COMMENT ON COLUMN timeless_content.is_published IS 'Whether invitation is published and accessible';
