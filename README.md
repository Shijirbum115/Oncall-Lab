# 🩺 CallCare — Гэрийн эмчилгээ, шинжилгээний платформ

> **The one-line pitch:** «Дусал, тариа, шинжилгээ — гэртээ. Facebook-ээр сувилагч хайх хэрэггүй.»

**CallCare** нь Улаанбаатарын хүмүүст **сувилагч, эмч, лаборантыг гэрт нь, зөв цагт нь**
хүргэдэг платформ. Замын түгжрэл, эмнэлгийн ачаалал, дараалал — эдгээрээс болж хүмүүс
өнөөдөр Facebook групп дээр *«Хан-Уул орчимд дусал залгах сувилагч байна уу?»* гэж
бичиж байна. CallCare яг энэ хэрэгцээг шийднэ: **баталгаажсан мэргэжилтэн, CallCare-ийн
нийлүүлсэн хэрэгслээр (тариур, систем, дусал), тогтсон үнээр** гэрт очно.

📖 **Бизнесийн бүрэн контекст, gap analysis, edge case policy:** [`docs/PRODUCT_VISION.md`](docs/PRODUCT_VISION.md)
— *шинэ feature хийхээсээ өмнө заавал уншина уу (AI assistant-ууд ч мөн адил).*

### Хоёр төрлийн хэрэгцээ, нэг л platform

| | Товлосон шинжилгээ (lab) | Яаралтай гэрийн эмчилгээ (treatment) |
|---|---|---|
| Жишээ | Ээждээ маргааш 9:00-д цусны шинжилгээ | Дусал залгуулах — **одоо, өнөө шөнө** |
| Хэн захиалдаг | Ихэвчлэн гэр бүлийн гишүүн (ахмад, хүүхдийн өмнөөс) | Өвчтөн өөрөө |
| Төлбөр | QPay / шилжүүлэг | **Урьдчилсан төлбөр заавал** |
| Match | Цагийн хуваарь | **Ойр байгаа, чөлөөтэй мэргэжилтэн, минут тутамд чухал** |

Нэг сувилагч хоёуланг нь гүйцэтгэнэ: өдөр нь lab-ын тойрог, орой нь эмчилгээний дуудлага.

### Систем юунаас бүтдэг вэ

- 📱 **Patient апп** (Flutter, `lib/ui/patient`) — үйлчилгээ захиалах, хүсэлтээ хянах
- 👨‍⚕️ **Provider апп** (Flutter, `lib/ui/doctor`) — сувилагч/эмч/лаборант хүсэлт хүлээн авах, статус ахиулах
- 🌐 **Admin web** (`admin-web/`, Next.js + shadcn) — эмч баталгаажуулалт, төлбөр шалгалт, dashboard, intervention
- 🗄 **Backend** — Supabase (PostgreSQL + RLS, Realtime, Edge Functions: QPay, push, AI chat)
- 📦 **Supply chain** *(төлөвлөгдсөн)* — мэргэжилтнүүд хэрэгслээ CallCare-аас авна. Энэ нь чанарын хяналт + platform-аас гадуур ажиллахаас сэргийлэх moat.

> ⚠️ Хуучин `admin_panel_web/` (Flutter web) нь `admin-web/` (Next.js)-ээр солигдсон.

---

## 🧱 Архитектурын товч

### 📱 Mobile (Flutter 3)

- State: `mobx` / `flutter_mobx`, DI: `get_it` (`lib/core/di/service_locator.dart`)
- Models: `freezed` + `json_serializable` (өөрчлөлт бүрийн дараа `build_runner`)
- `lib/core` — constants, Supabase config, services (push, qpay)
- `lib/data` — models, repositories
- `lib/stores` — MobX stores
- `lib/ui/{patient,doctor,shared,payment}` — экранууд

### 🗄 Backend (Supabase)

Дэлгэрэнгүй: `docs/BACKEND_SETUP.md`. Гол хүснэгтүүд:

- `profiles` (role: patient/doctor/admin) + `doctor_profiles` (license, rating, **doctor_type: nurse/general/lab_technician/diagnostic_specialist**)
- `laboratories`, `laboratory_services`, `services`, `service_categories` — үйлчилгээний каталог
- `test_requests` — захиалгын гол хүснэгт (status machine: `pending → accepted → on_the_way → sample_collected → delivered_to_lab → completed`, direct_service-д `sample_collected → completed` шууд)
- `qpay_payments`, `manual_payments` (+ status history) — төлбөр; `payments` хүснэгт устгагдсан (legacy)
- `notifications` (хоёр хэлтэй) + push pipeline (pg_net → edge function → FCM)
- `doctor_reviews`, `posts`, `audit_logs`, `request_status_history`

Security: бүх хүснэгт RLS-тэй, admin эрх `is_admin()` функцээр. Нууц түлхүүрүүд
(`supabase_config.dart`, `.env*`, service role key) **Git-д орохгүй**.

### 🌐 Admin web (`admin-web/`)

Next.js 16 + shadcn (Base UI). Нэвтрэлт: админ утасны дугаар + нууц үг.
Dashboard, Doctors (нэмэх/засах/баталгаажуулах/устгах/нууц үг reset), Requests
(хайлт, >24h aging, cancel), Payments (manual transfer review + proof файл),
Patients (хайлт, disable, нууц үг reset).

```bash
cd admin-web && npm install && npm run dev   # SUPABASE_SECRET_KEY нэмбэл add/delete doctor ажиллана
```

---

## 🛠 Хөгжүүлэлт эхлүүлэх

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Supabase тохиргоо: `lib/core/constants/supabase_config.dart`-ийг локалдаа үүсгэнэ
(`.gitignore`-д орсон):

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'https://<project>.supabase.co';
  static const String supabaseAnonKey = '<anon-key>';
}
```

---

## 📂 Баримтууд

- **`docs/PRODUCT_VISION.md` — бизнесийн тархи. Эхлээд үүнийг унш.**
- `docs/BACKEND_SETUP.md` — Supabase schema, seed
- `docs/QPAY_READY.md` — QPay интеграц
- `docs/NOTIFICATION_SYSTEM_SETUP.md` — push pipeline (FCM secrets шаардлагатай)
- `docs/STORAGE_SETUP_GUIDE.md`, `docs/LOCALIZATION_GUIDE.md`, бусад
- `CLAUDE.md` — AI assistant-д зориулсан заавар

## 🎯 Одоогийн статус ба дараагийн алхам (2026.06)

✅ Lab захиалгын бүрэн урсгал, төлбөр, админ удирдлага ажиллаж байна.
❌ Үүсгэн байгуулагчийн гол хэрэгцээ — **яаралтай гэрийн эмчилгээ** — хараахан үйлчлэхгүй:

1. Эмчилгээний каталог нэмэх («Дусал залгах», тариа, сувилахуйн тусламж)
2. ASAP горим + 10 минутад match болохгүй бол админ руу escalation
3. Дүүргээр matching (одоо хот даяар fan-out хийдэг)
4. Бусдын өмнөөс захиалах (ахмад, хүүхэд — beneficiary)
5. 2 минутын бүртгэл (одоогийн form хэт урт)
6. Supply/kit модуль (admin CMS үе шат)

Дэлгэрэнгүй үндэслэл: `docs/PRODUCT_VISION.md`.

---

**CallCare — «All you have to do is CALL US» 📞**
