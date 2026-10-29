---
name: miss-noha-content
description: Facts, wording and data-safety rules for the Miss Noha (مس نهى) landing page. Use this before writing or changing ANY text, section, price, schedule, qualification, contact detail or form on the page, and before touching its Supabase table — even for a one-word copy change, a new section, or "make it sound nicer".
---

# Miss Noha — content and data rules

The page sells Science & Biology lessons for a real teacher. Parents decide based on what it says, so every claim has to be something the user actually confirmed. When a fact is missing, ask the user instead of filling the gap — a plausible guess on this page is a false claim about a real person.

## Confirmed facts (the only ones to use)

- **Brand:** Miss Noha / مس نهى · Miss Noha Kataria. Don't write the surname in Arabic script; its spelling isn't confirmed.
- **Role:** مدرسة علوم وأحياء · Science & Biology Teacher. Lessons online and offline.
- **Location:** بورسعيد، مصر. Never publish a home address. The exact offline venue (home visits, centre…) is not confirmed.
- **Grades:** ابتدائي · متوسط · ثانوي (user's wording; keep «متوسط» unless they change it).
- **Curricula:** National عربي · National لغات · International · مناهج دول الخليج.
- **Prices and schedule:** «بالاتفاق مع ولي الأمر». No numbers.
- **WhatsApp:** 01551401807 → `https://wa.me/201551401807?text=…`. Every WhatsApp button pre-fills the parent's message (greeting, then blank lines for الصف / المنهج / المادة / أونلاين ولا أوفلاين). `scripts/check.sh` enforces the link rules (identical links, Arabic/ASCII-only text).
- **Qualifications** (Faculty of Education, Port Said University) — names only, no years and no grades:
  - بكالوريوس العلوم والتربية — شعبة البيولوجي والجيولوجيا (برنامج خاص)
  - دبلومة مهنية في المناهج وطرق تدريس العلوم باللغة الإنجليزية
  - دبلومة خاصة في المناهج وطرق تدريس العلوم باللغة الإنجليزية
  - الماجستير — جاري الدراسة (never present it as completed)

## Not confirmed — leave off the page

Years of experience, school names and dates, specific curriculum brands (Cambridge, American…), student results, IELTS (studying only, no score), trial-session policy, session length. The original brief is `Downloads\miss noha\Miss_Noha_Landing_Page_Brief_for_Claude.docx`; where the user has since corrected it (e.g. the special diploma is in English), the user wins.

## Sections added 2026-10-28

- **Articles for parents** (`#parents`): the two articles were approved by the user on 2026-10-28. They are general study advice in Miss Noha's voice; keep facts about her out of them. New articles need the user's approval before publishing.
- **Reviews** (`#reviews`): show only real reviews whose author ticked consent (`allow_publish`) **and** the user picked; first name only. Until then the «قريباً» card stays. Write no reviews yourself.
- **Video** (`#video`): placeholder «الفيديو قريباً» until the user supplies a video (YouTube link preferred).
- **Why / journey cards and FAQ** come from the original brief ("Why learn with me", teaching approach, FAQ). Keep their claims to what the brief says.

## Wording

- Egyptian Arabic, warm and plain, written to parents. No promises like guaranteed grades or "best teacher".
- The page is RTL. Wrap Latin words that sit inside Arabic text in `<bdi>` so punctuation and «و» don't jump around.
- Use English next to Arabic only for the Science/Biology labels and tool names.
- Keep the form's success text exactly: «وصلتنا رسالتك، هنكلّمك في نفس اليوم.» — show it only after Supabase confirms the insert.

## Supabase (contact and feedback forms)

- Project **miss-noha** on the user's own account, ref `dzixyjhawkncxztvqmxn`. Table `public.messages`: `id`, `name`, `phone`, `message`, `created_at`.
- Table `public.feedback` (reviews form): `id`, `name`, `grade` (nullable), `message`, `allow_publish`, `created_at`; same insert-only setup, anon inserts `name, grade, message, allow_publish`. As of 2026-10-28 the user's SQL for it had not taken effect (API: table not found), so the form shows its error until the table exists. Re-check with a read (`401` = exists, `404 PGRST205` = missing).
- Only the **publishable** key (`sb_publishable_…`) goes in the page. Never put a secret / service_role key in any file, commit or chat.
- RLS stays on with a single INSERT policy for `anon`; anon has column-level INSERT on `name, phone, message` only. Visitors must never read, update or delete rows: give `anon` no SELECT/UPDATE/DELETE.
- **Admin reads (admin.html):** Miss Noha signs in with **Clerk** (publishable key and frontend API in `admin.html`; only she has an account, sign-ups restricted). Supabase accepts the Clerk session token via Third-party Auth (Clerk), and the only SELECT policy on `messages` / `feedback` is `to authenticated using ((select auth.jwt()->>'sub') = '<her Clerk user id>')`. Keep it pinned to her user id rather than "any authenticated user".
- Insert with `Prefer: return=minimal` (there is no SELECT permission, so `return=representation` fails).
- The claude.ai Supabase connector has pointed at a different person's account. Check `list_projects` shows `miss-noha` before running any SQL; if it doesn't, give the user the SQL to run in their dashboard's SQL Editor instead.
- Test rows can't be deleted with the publishable key, and PostgREST here ignores `tx=rollback`. Don't insert test rows unless the user agrees, and tell them how to delete any you create (Table Editor → messages → Delete row).
