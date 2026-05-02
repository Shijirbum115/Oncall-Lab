# 🧪 CallCare – Гэрийн лабораторийн үйлчилгээний апп

**Callcare** нь Улаанбаатар хотын хэрэглэгчдэд лабораторийн шинжилгээ болон эмчийн гэрийн үзлэгийг **гар утаснаасаа захиалах** боломж олгох Flutter + Supabase дээр суурилсан систем юм.

- 👩‍⚕️ **Patient апп** – хэрэглэгч лаборатори, үйлчилгээ сонгох, цаг захиалах, өөрийн хүсэлтүүдээ хянах
- 👨‍⚕️ **Doctor апп** – эмч/лаборант шинээр ирсэн хүсэлт, өөрийн идэвхтэй болон дууссан захиалгуудыг хянах
- 🗄 **Backend** – Supabase (PostgreSQL, Row Level Security, Realtime)
- 🌐 **Admin panel (web)** – тусдаа `admin_panel_web` фолдерт хөгжүүлж байгаа

---

## 🚀 Тойм

### Гол боломжууд

- 🏥 **Laboratory directory**
  - Бүх бүртгэлтэй лаборатори, хаяг, утас, цагийн хуваарь харах
  - Лаборатори бүрийн санал болгож буй **test services** жагсаалт, үнэ, хугацаа
- 🧪 **Lab test booking (Clinic visit / Home visit)**
  - Patient – шинжилгээний төрөл сонгоод лабораториас **home sample collection** захиалах
  - Цагийн слот, байршлын хаяг, нэмэлт тэмдэглэл оруулах
- 🩺 **Direct services (эмч/сувилагчийн шууд үйлчилгээ)**
  - Эмчийн үйлчилгээний төрөл (ultrasound, ECG, nursing гэх мэт) сонгох
  - “Any available doctor” эсвэл тодорхой эмч сонгох
  - Адресээ хадгалаад дараагийн удаа шууд ашиглах
- 📊 **Requests / Dashboard**
  - Patient – хүсэлтүүдийг **Active / Completed / Cancelled** табуудаар харах
  - Doctor – **Available / My Requests / Completed** табтай Dashboard
  - Хүсэлтийн статусууд: `pending → accepted → on_the_way → sample_collected → delivered_to_lab → completed`
  - Realtime шинэчлэлт (Supabase realtime)

---

## 🧱 Архитектурын товч (High-level)

### 📱 Frontend

- Flutter 3 (Dart)
- State management: `mobx`, `flutter_mobx`
- Dependency injection: `get_it` (`lib/core/di/service_locator.dart` register-лэлтээр store, repository-гаа inject хийдэг)
- Data models: `freezed`, `json_serializable`
- Navigation: энгийн `Navigator` (template-д AutoRoute заавар байгаа ч одоогоор basic navigation)

Фолдер бүтэц (mobile):

- `lib/core` – color, strings, Supabase config, services
- `lib/data` – models (`ProfileModel`, `DoctorProfileModel`, `LaboratoryModel`, `TestRequestModel` …), repositories
- `lib/stores` – MobX stores (`AuthStore`, `HomeStore`, `ServiceStore`, `TestRequestStore`, `DoctorRequestStore`)
- `lib/ui/patient` – patient аппийн бүх экраниуд
- `lib/ui/doctor` – doctor аппийн бүх экраниуд
- `lib/ui/shared` – splash screen, shared widgets

### 🗄 Backend (Supabase)

Дэлгэрэнгүйг: `docs/BACKEND_SETUP.md` файлаас харна уу.

Гол хүснэгтүүд:

- `profiles` – хэрэглэгчийн үндсэн мэдээлэл (patient / doctor / admin)
- `doctor_profiles` – эмчийн мэргэжил, license, туршлага, rating
- `laboratories` – лабораториудын бүртгэл, байршил
- `test_types` – стандарт laboratory test жагсаалт
- `services`, `laboratory_services`, `doctor_services` – үйлчилгээний төрөл, лаборатори / эмчийн санал болгож буй service-үүд
- `test_requests` – бүх захиалгын үндсэн хүснэгт
- `notifications`, `request_status_history`, `audit_logs` – notification, статусын түүх, audit

Security:

- Row Level Security (RLS) бүх хүснэгт дээр идэвхтэй
- Patient зөвхөн өөрийн `test_requests` болон өөрийн profile-г уншиж/засна
- Doctor зөвхөн өөртэй нь холбогдсон patient-үүдийн profile-г харна
- Admin бүрэн хандалттай (RLS functions `is_admin(...)` ашиглана)

Realtime:

- `test_requests` – статус өөрчлөгдөхөд realtime stream
- `notifications` – notification store дээр realtime

---

## 🛠 Хөгжүүлэлтийн орчин тохируулах

Доорх алхмууд Windows-д зориулсан, Mac дээр ч ерөнхийдөө ижил.
Дэлгэрэнгүй: `CONTRIBUTING.md`.

### 1. Шаардлагатай зүйлс

- Flutter SDK (`flutter --version` ажилладаг байх)
- Android Studio (эсвэл Xcode/эмулятор – Mac-д)
- VS Code буюу IDE (IntelliJ / Android Studio ч байж болно)
- Git

### 2. Dependency татах

```bash
flutter pub get
```

### 3. Code generation (models, MobX, json)

```bash
dart run build_runner build --delete-conflicting-outputs
```

Хөгжүүлж байх үед:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

### 4. Supabase тохиргоо хийх

1. Supabase project үүсгэж (эсвэл README_BACKEND_SETUP дээр өгсөн project ашиглаж)
2. `lib/core/constants/supabase_config.dart` файлыг **локал** дээрээ үүсгэнэ (Git-т үл орох ёстой, `.gitignore`-д орсон):

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'https://<project>.supabase.co';
  static const String supabaseAnonKey = '<anon-key>';
}
```

3. Supabase SQL редактор дээр `supabase/migrations/*.sql` файлуудыг ажиллуулж schema-г тохируулна (ялангуяа `fix_profiles_rls` migration).

Backend-ийн бүрэн тайлбар: `docs/BACKEND_SETUP.md`.

---

## ▶️ Апп ажилуулах

```bash
# Эмулятор эсвэл төхөөрөмж шалгах
flutter devices

# Android эсвэл iOS дээр ажиллуулах
flutter run
```

Хөгжүүлэлт дээр:

- `r` – hot reload
- `R` – hot restart

---

## 📱 Patient апп – гол экраниуд

- 🏠 **Home screen**
  - “Clinic visit” / “Home visit” сонголтуудтай modern hero хэсэг
  - “Available tests” – Supabase-аас ирж буй test services carousel
  - “Available doctors” – докторуудын grid
- 🧪 **Laboratories**
  - Лабораториудын жагсаалт + search
  - Лаборатори detail – үйлчилгээ, үнэ, хаяг, утас
  - Лаб service booking – цаг, хаяг, notes
- 🧍‍♀️ **Direct services**
  - Үйлчилгээний төрлөөр grouped list
  - “Any available doctor” эсвэл тодорхой эмч сонгох
  - Direct service booking – цаг, хаяг, notes
- 📆 **My Requests**
  - Tab-ууд: **Active / Completed / Cancelled**
  - Статусын өнгө, үнэ, товч мэдээлэл
- 👤 **Profile**
  - Нэр, утас, role (Patient)
  - Saved address – байршлаа хадгалах, өөрчлөх
  - Sign out

---

## 👨‍⚕️ Doctor апп – гол экраниуд

- 📊 **My Dashboard**
  - Tab-ууд: **Available / My Requests / Completed**
  - Available – шинэ захиалгууд, “Accept” хийж идэвхтэй болгох
  - My Requests – явж байгаа хүсэлтүүд
  - Completed – дууссан хүсэлтүүд
- 📄 **Request detail**
  - Patient-ийн хаяг, цаг, үйлчилгээний төрөл, үнэ
  - Статусын action-ууд: “On the way”, “Sample collected”, “Delivered to lab”, “Completed”, “Cancel”
  - Cancellation reason авах диалог
- 👤 **Doctor profile**
  - Нэр, мэргэжил, rating, completed тоо
  - Contact info, license, туршлага

---

## 📂 Гол файлууд / баримтууд

- `CONTRIBUTING.md` – хөгжүүлэлтийн орчин тохируулах, branch workflow, commit стандарт
- `CLAUDE.md` – Claude Code (AI assistant) ашиглах заавар
- `docs/BACKEND_SETUP.md` – Supabase backend-ийг анхнаасаа хэрхэн босгосон, project URL, seed data
- `docs/ADMIN_PANEL_SETUP.md` – web admin panel-ийн тайлбар
- `docs/FILE_STRUCTURE_GUIDE.md` – файлын бүтэц, директор зохион байгуулалт
- `docs/LOCALIZATION_GUIDE.md` – mn/en хэлний орчуулга
- `docs/REALTIME_IMPLEMENTATION_GUIDE.md`, `docs/MOBILE_APP_REALTIME.md` – Supabase realtime
- `docs/QPAY_READY.md` – QPay payment integration
- `docs/STORAGE_SETUP_GUIDE.md` – Supabase Storage (bucket-ууд, RLS)

---

## 🔐 Нууц мэдээлэл, Git

Git дээр commit хийхдээ дараах файлууд **огт орох ёсгүй**:

- `lib/core/constants/supabase_config.dart` – Supabase URL, anon key
- `.env` – env variables
- Supabase service role key, JWT secret зэрэг бүх нууц

Эдгээрийг `.gitignore` дээр аль хэдийн нэмсэн байгаа. Хэрвээ шинэ нууц файл нэмбэл заавал `.gitignore`-т нэмээрэй.

---

## 🤝 Contribution

Хэрвээ чи энэ project дээр үргэлжлүүлж хөгжүүлэх бол:

1. Repo-г clone хийнэ (эсвэл өөр машин дээрээ pull хийнэ)
2. `flutter pub get` + `build_runner` ажиллуулна
3. Шинэ feature / bugfix-ээ `feature/...` branch дээр хийж, commit/push хийнэ

Issue, idea байвал README доторх бүтэцтэй тааруулж файлуудыг update хийхэд л хангалттай.

---

**OnCall Lab – “All you have to do is CALL US” 📞**  
Гэрээсээ холгүйгээр, апп-аасаа лабораторийн шинжилгээ захиалж, эмчийн үзлэгийг дэргэдээ дуудъя. 🚑
