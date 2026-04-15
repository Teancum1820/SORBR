-- Sorbr Cloud Library — Supabase Setup
-- Run this in your Supabase SQL Editor (https://supabase.com/dashboard/project/hjjmnhgqvekuddwzmppq/sql/new)

-- ── 1. Books metadata table ──────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.library_books (
  id            TEXT        PRIMARY KEY,
  user_id       UUID        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title         TEXT        NOT NULL DEFAULT '',
  type          TEXT        NOT NULL DEFAULT 'text',
  total_words   INTEGER     DEFAULT 0,
  position      INTEGER     DEFAULT 0,
  progress      INTEGER     DEFAULT 0,
  notes         JSONB       DEFAULT '[]',
  wpm           INTEGER     DEFAULT 300,
  date_added    BIGINT      NOT NULL DEFAULT 0,
  last_read     BIGINT,
  read_chapters JSONB       DEFAULT '[]',
  book_settings JSONB       DEFAULT '{}'::jsonb,
  has_cover     BOOLEAN     DEFAULT FALSE,
  has_chapters  BOOLEAN     DEFAULT FALSE
);

-- If your table already exists from an older Sorbr release:
ALTER TABLE public.library_books
  ADD COLUMN IF NOT EXISTS book_settings JSONB DEFAULT '{}'::jsonb;

-- ── 2. Row-Level Security ────────────────────────────────────────────────────

ALTER TABLE public.library_books ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage their own books"
  ON public.library_books
  FOR ALL
  USING  (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ── 3. Storage bucket ────────────────────────────────────────────────────────
-- Create a bucket called "sorbr-library" in your Supabase Storage dashboard
-- (Storage → New bucket → name: sorbr-library, Public: OFF)
-- Then add these policies:

-- Insert (authenticated users can upload to their own folder)
-- Policy name: "Authenticated users can upload"
-- Allowed operation: INSERT
-- Policy definition: (auth.uid()::text = (storage.foldername(name))[1])

-- Select (users can download their own files)
-- Policy name: "Users can read their own files"
-- Allowed operation: SELECT
-- Policy definition: (auth.uid()::text = (storage.foldername(name))[1])

-- Update (users can update their own files)
-- Policy name: "Users can update their own files"
-- Allowed operation: UPDATE
-- Policy definition: (auth.uid()::text = (storage.foldername(name))[1])

-- Delete (users can delete their own files)
-- Policy name: "Users can delete their own files"
-- Allowed operation: DELETE
-- Policy definition: (auth.uid()::text = (storage.foldername(name))[1])

-- ── 4. Quick one-liner for storage policies (run separately in SQL editor) ──

INSERT INTO storage.buckets (id, name, public) VALUES ('sorbr-library', 'sorbr-library', false)
  ON CONFLICT (id) DO NOTHING;

CREATE POLICY "sorbr_user_insert" ON storage.objects FOR INSERT TO authenticated
  WITH CHECK (bucket_id = 'sorbr-library' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "sorbr_user_select" ON storage.objects FOR SELECT TO authenticated
  USING (bucket_id = 'sorbr-library' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "sorbr_user_update" ON storage.objects FOR UPDATE TO authenticated
  USING (bucket_id = 'sorbr-library' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "sorbr_user_delete" ON storage.objects FOR DELETE TO authenticated
  USING (bucket_id = 'sorbr-library' AND auth.uid()::text = (storage.foldername(name))[1]);
