# 📦 Database Migration Guide

## 🎯 Cara Pindah Database ke Account Supabase Baru

### **Option 1: Manual Export/Import (Paling Mudah)**

#### **Step 1: Export Data dari Database Lama**

1. Buka Supabase Dashboard: https://supabase.com/dashboard
2. Login ke project lama (`fnewihswvgtgzzsfaeis`)
3. Klik **"Table Editor"** → Pilih table **"timeless_content"**
4. Klik **"..."** (More Options) → **"Export to CSV"**
5. Save file: `timeless_content_backup.csv`

#### **Step 2: Setup Database Baru**

1. Buat project Supabase baru di https://supabase.com
2. Copy **Project URL** dan **anon key** yang baru
3. Update file `.env`:
   ```env
   VITE_SUPABASE_URL=https://your-new-project.supabase.co
   VITE_SUPABASE_ANON_KEY=your-new-anon-key
   ```

#### **Step 3: Run Migrations**

Jalankan semua migration files yang ada di folder `/supabase/migrations/`:

**Via Supabase Dashboard:**
1. Buka project baru → **"SQL Editor"**
2. Copy isi dari setiap file migration (mulai dari yang paling lama)
3. Paste & Run satu per satu:
   ```
   20251123115425_create_timeless_content_table.sql
   20251123121214_add_missing_content_fields.sql
   20251123125657_add_hero_background_image_field.sql
   20251123234344_add_livestreaming_image_field.sql
   20251124084314_create_timeless_content_table.sql
   20251124092942_fix_timeless_rls_policies.sql
   20251125013235_add_multi_template_support.sql
   20251125015742_add_password_protection_and_analytics.sql
   20251125023054_add_template_sales_tracking.sql
   20251125032254_add_orders_management_table.sql
   20251125065733_add_status_and_workflow_fields.sql
   ```

#### **Step 4: Import Data**

1. Kembali ke **"Table Editor"** → table **"timeless_content"**
2. Klik **"Insert"** → **"Import from CSV"**
3. Upload file `timeless_content_backup.csv`
4. Match columns dengan benar
5. Click **"Import"**

#### **Step 5: Update Admin Pages**

Update hardcoded URL di semua admin pages:

**Files yang perlu diupdate:**
- `/kaito.com/admin/dashboard.html`
- `/kaito.com/admin/orders.html`
- `/kaito.com/admin/create.html`
- `/kaito.com/admin/edit.html`
- `/kaito.com/admin/analytics.html`

**Ganti:**
```javascript
// OLD
const SUPABASE_URL = 'https://fnewihswvgtgzzsfaeis.supabase.co';
const SUPABASE_ANON_KEY = 'old-key...';

// NEW
const SUPABASE_URL = 'https://your-new-project.supabase.co';
const SUPABASE_ANON_KEY = 'your-new-anon-key';
```

**ATAU lebih baik, read dari .env:**
```javascript
const SUPABASE_URL = import.meta.env.VITE_SUPABASE_URL;
const SUPABASE_ANON_KEY = import.meta.env.VITE_SUPABASE_ANON_KEY;
```

---

### **Option 2: Automated Migration (Advanced)**

#### **Using Supabase CLI**

1. **Install Supabase CLI:**
   ```bash
   npm install -g supabase
   ```

2. **Login:**
   ```bash
   supabase login
   ```

3. **Link to OLD project:**
   ```bash
   supabase link --project-ref fnewihswvgtgzzsfaeis
   ```

4. **Pull schema dari OLD database:**
   ```bash
   supabase db pull
   ```

5. **Link to NEW project:**
   ```bash
   supabase link --project-ref your-new-project-ref
   ```

6. **Push schema ke NEW database:**
   ```bash
   supabase db push
   ```

7. **Export data dari OLD:**
   ```bash
   supabase db dump -f backup.sql
   ```

8. **Import data ke NEW:**
   ```bash
   psql "postgresql://postgres:[password]@[new-project].supabase.co:5432/postgres" < backup.sql
   ```

---

### **Option 3: Using Database Backup Feature**

**Supabase Pro Plan Only** (Paid feature)

1. Go to OLD project → **"Database"** → **"Backups"**
2. Click **"Create Backup"**
3. Download backup file
4. Go to NEW project → **"Database"** → **"Backups"**
5. Click **"Restore from Backup"**
6. Upload backup file

---

## 📁 **Files Yang Perlu Di-Update Saat Migrasi**

### **1. Environment Variables**
```
/.env
```

### **2. Admin Pages (Hardcoded Credentials)**
```
/kaito.com/admin/dashboard.html
/kaito.com/admin/orders.html
/kaito.com/admin/create.html
/kaito.com/admin/edit.html
/kaito.com/admin/analytics.html
```

### **3. Migration Files (NO NEED to change)**
```
/supabase/migrations/*.sql
```

---

## ✅ **Checklist Setelah Migrasi**

- [ ] Database baru sudah ada table `timeless_content`
- [ ] RLS policies sudah aktif
- [ ] Data lama sudah ter-import
- [ ] `.env` sudah update dengan credentials baru
- [ ] Admin pages sudah connect ke database baru
- [ ] Test create new template → berhasil
- [ ] Test edit template → berhasil
- [ ] Test mark complete → berhasil
- [ ] Test analytics → data muncul

---

## 🚨 **Important Notes**

1. **Migration files = Portable** ✅
   - Bisa dijalankan di database manapun
   - Version control friendly
   - Bisa di-share antar team

2. **Data = Perlu Export/Import** ⚠️
   - Tidak otomatis pindah
   - Harus manual export/import
   - Atau pakai Supabase CLI

3. **Storage (Images) = Perlu Download/Upload** 📸
   - Images di Supabase Storage tidak ikut migration
   - Perlu manual download dari old project
   - Upload ke new project storage

4. **API Keys = Berbeda per Project** 🔑
   - Setiap project punya URL & Keys berbeda
   - HARUS update di semua files

---

## 💡 **Recommendation**

**Untuk production:**
1. ✅ Gunakan environment variables (`.env`)
2. ✅ JANGAN hardcode credentials di code
3. ✅ Backup data secara berkala
4. ✅ Test di local dulu sebelum deploy
5. ✅ Simpan migration files di Git

**Untuk development:**
1. Gunakan Supabase local development
2. Test migrations sebelum apply ke production
3. Maintain migration history yang clean

---

Need help dengan migration? Let me know! 🚀
