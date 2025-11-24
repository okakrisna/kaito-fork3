# Supabase Database Setup Guide

Panduan lengkap untuk setup database Supabase di account baru.

## 📋 Quick Setup (5 Menit)

### Opsi 1: Menggunakan SQL Editor (TERMUDAH)

1. **Buka Supabase Dashboard**
   - Login ke https://supabase.com
   - Buat project baru atau buka project yang ada

2. **Masuk ke SQL Editor**
   - Klik menu "SQL Editor" di sidebar kiri

3. **Copy-Paste SQL Berikut:**

```sql
-- =====================================================
-- Create timeless_content table
-- =====================================================

CREATE TABLE IF NOT EXISTS timeless_content (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Basic Info
  couple_names text DEFAULT '',
  groom_full_name text DEFAULT '',
  bride_full_name text DEFAULT '',
  wedding_title text DEFAULT '',
  wedding_date text DEFAULT '',

  -- Venue Info
  venue_name text DEFAULT '',
  venue_address text DEFAULT '',
  venue_maps text DEFAULT '',

  -- Time Info
  ceremony_time text DEFAULT '',
  reception_time text DEFAULT '',

  -- Images
  background_section_1 text DEFAULT '',
  background_section_2 text DEFAULT '',
  background_section_3 text DEFAULT '',
  hero_background_image text DEFAULT '',
  livestreaming_image text DEFAULT '',
  gallery_images text[] DEFAULT '{}',

  -- Messages
  thank_you_message text DEFAULT '',

  -- Timestamps
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- =====================================================
-- Enable Row Level Security
-- =====================================================

ALTER TABLE timeless_content ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- Create RLS Policies (Public Access)
-- =====================================================

-- Drop existing policies if any
DROP POLICY IF EXISTS "Enable read access for all" ON timeless_content;
DROP POLICY IF EXISTS "Enable insert access for all" ON timeless_content;
DROP POLICY IF EXISTS "Enable update access for all" ON timeless_content;
DROP POLICY IF EXISTS "Enable delete access for all" ON timeless_content;

-- Create new policies
CREATE POLICY "Enable read access for all"
  ON timeless_content
  FOR SELECT
  USING (true);

CREATE POLICY "Enable insert access for all"
  ON timeless_content
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Enable update access for all"
  ON timeless_content
  FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Enable delete access for all"
  ON timeless_content
  FOR DELETE
  USING (true);
```

4. **Klik Run (atau tekan Ctrl/Cmd + Enter)**

5. **✅ Done! Database siap digunakan**

---

## 🔧 Update .env File

Setelah setup database, update file `.env` dengan credentials dari project baru:

```env
VITE_SUPABASE_URL=https://YOUR-PROJECT-REF.supabase.co
VITE_SUPABASE_ANON_KEY=YOUR-ANON-KEY-HERE
```

**Cara dapat credentials:**
1. Buka Supabase Dashboard
2. Klik "Settings" (ikon gear) di sidebar
3. Klik "API"
4. Copy:
   - **Project URL** → `VITE_SUPABASE_URL`
   - **anon/public key** → `VITE_SUPABASE_ANON_KEY`

---

## 📝 Update Code (Admin & Timeless Page)

Setelah dapat credentials baru, update di 2 file:

### 1. Admin Panel (`kaito.com/admin/index.html`)

Cari baris ini (sekitar line 327-329):
```javascript
const SUPABASE_URL = 'https://fnewihswvgtgzzsfaeis.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGc...';
```

Ganti dengan credentials baru:
```javascript
const SUPABASE_URL = 'https://YOUR-PROJECT-REF.supabase.co';
const SUPABASE_ANON_KEY = 'YOUR-NEW-ANON-KEY';
```

### 2. Timeless Page (`kaito.com/timeless/index.html`)

Cari baris ini (sekitar line 8040-8041):
```javascript
const REST_API_URL = 'https://fnewihswvgtgzzsfaeis.supabase.co/rest/v1/timeless_content?limit=1';
const SUPABASE_ANON_KEY = 'eyJhbGc...';
```

Ganti dengan:
```javascript
const REST_API_URL = 'https://YOUR-PROJECT-REF.supabase.co/rest/v1/timeless_content?limit=1';
const SUPABASE_ANON_KEY = 'YOUR-NEW-ANON-KEY';
```

---

## ✅ Test Database

Test apakah database sudah berfungsi:

```bash
# Test dengan curl (ganti dengan credentials baru)
curl -X GET 'https://YOUR-PROJECT-REF.supabase.co/rest/v1/timeless_content?limit=1' \
  -H 'Authorization: Bearer YOUR-ANON-KEY' \
  -H 'apikey: YOUR-ANON-KEY'
```

Jika berhasil, akan muncul response `[]` (array kosong) atau data yang ada.

---

## 📊 Database Schema

**Table:** `timeless_content`

| Column | Type | Default | Description |
|--------|------|---------|-------------|
| `id` | uuid | auto | Primary key |
| `couple_names` | text | '' | Nama pasangan |
| `groom_full_name` | text | '' | Nama lengkap pria |
| `bride_full_name` | text | '' | Nama lengkap wanita |
| `wedding_title` | text | '' | Judul pernikahan |
| `wedding_date` | text | '' | Tanggal pernikahan |
| `venue_name` | text | '' | Nama tempat |
| `venue_address` | text | '' | Alamat lengkap |
| `venue_maps` | text | '' | Link Google Maps |
| `ceremony_time` | text | '' | Waktu akad |
| `reception_time` | text | '' | Waktu resepsi |
| `background_section_1` | text | '' | URL gambar background |
| `background_section_2` | text | '' | URL foto pria |
| `background_section_3` | text | '' | URL foto wanita |
| `hero_background_image` | text | '' | URL gambar hero |
| `livestreaming_image` | text | '' | URL gambar livestream |
| `gallery_images` | text[] | [] | Array URL gambar gallery |
| `thank_you_message` | text | '' | Pesan terima kasih |
| `created_at` | timestamptz | now() | Waktu dibuat |
| `updated_at` | timestamptz | now() | Waktu diupdate |

**Security:** Row Level Security (RLS) enabled dengan public access (anyone can read/write).

---

## 🚀 Tips Pindah Account

**Untuk project production:**
1. Export data dari account lama:
   ```sql
   SELECT * FROM timeless_content;
   ```
   Copy hasilnya.

2. Setup database di account baru (ikuti panduan di atas).

3. Import data:
   ```sql
   INSERT INTO timeless_content (couple_names, wedding_title, ...)
   VALUES ('...', '...', ...);
   ```

**Total waktu:** < 10 menit untuk setup lengkap di account baru!

---

## 🆘 Troubleshooting

### Error: "Could not find column"
- Pastikan sudah run SQL setup di atas
- Cek apakah semua kolom sudah ada di table

### Error: "Internal server error"
- Pastikan RLS policies sudah dibuat
- Cek credentials (URL & anon key) sudah benar

### Error: "Failed to save data"
- Buka browser console (F12) untuk lihat detail error
- Pastikan anon key valid (tidak expired)

---

**Need Help?** Contact support atau cek dokumentasi di `README.md`
