# Mini Contact Book App

Flutter + Node.js/Express + MySQL — وفق مواصفات Practical Task

> **مهم:** استبدل `YOUR_REGISTRATION_NUMBER` برقم قيدك في ملفين:
> 1. `flutter_app/lib/config.dart`
> 2. `backend/src/server.js` (السطر الأول كتعليق)

---

## هيكل المشروع

```
contact-book-app/
├── database/schema.sql     ← شغّله في MySQL Workbench
├── backend/                ← API
└── flutter_app/            ← تطبيق Flutter
```

---

## 1. MySQL Workbench

1. افتح **MySQL Workbench**
2. **File → Open SQL Script** → `database/schema.sql`
3. اضغط **Execute (⚡)**

ينشئ قاعدة `contact_book_db` وجدول `contacts`.

> **ملاحظة:** لا يوجد عمود `display_tag` في قاعدة البيانات — يُحسب في الـ API عند كل طلب قائمة.

---

## 2. Backend

```bash
cd backend
cp .env.example .env
```

عدّل كلمة مرور MySQL في `.env`:

```env
DB_PASSWORD=YOUR_MYSQL_PASSWORD
```

```bash
npm install
npm start
```

السيرفر: http://localhost:3000

---

## 3. Flutter

```bash
cd flutter_app
flutter pub get
flutter run
```

---

## API Endpoints

| Method | Endpoint | الوظيفة |
|--------|----------|---------|
| GET | `/contacts` | قائمة كل جهات الاتصال + `display_tag` محسوب |
| GET | `/contacts/search?category=Family` | فلترة حسب الفئة |
| POST | `/contacts` | إضافة جهة اتصال |
| PUT | `/contacts/:id` | تعديل |
| DELETE | `/contacts/:id` | حذف |

### قاعدة `display_tag` (لا تُخزَّن في DB)

- مفضلة (`is_favorite = true`): `* Family`
- غير مفضلة: `Work`

### التحقق من رقم الهاتف

- بالضبط 10 أرقام
- يبدأ بـ `07` (مثال صحيح: `0788123456`)
- فريد بعد إزالة المسافات

---

## شاشات Flutter

1. **قائمة جهات الاتصال** — عنوان: `My Contacts — [رقم القيد]` + فلاتر All/Family/Friend/Work + زر +
2. **إضافة / تعديل** — الاسم، الهاتف، الفئة، مفضلة، زر SAVE CONTACT
3. **تأكيد الحذف** — "Delete contact? This cannot be undone."

---

## استكشاف الأخطاء

### لا يُنشأ Contact / Save لا يعمل

1. تأكد أنك تشغّل **Contact Book backend** (وليس Room Booking):
   ```bash
   cd contact-book-app/backend
   cp .env.example .env
   # ضع كلمة مرور MySQL الصحيحة
   npm install
   npm start
   ```
   يجب أن ترى: `MySQL connected` و `Server running on http://localhost:3000`

2. افتح http://localhost:3000 في المتصفح — يجب أن ترى رسالة API.

3. رقم الهاتف **يجب** أن يكون مثل `0712345678` (10 أرقام تبدأ بـ 07). أي رقم مكرر يُرفض.

4. إذا كان عندك بيانات قديمة بالرقم التجريبي `0788123456`، احذف الصف من Workbench أو استخدم رقمًا مختلفًا.

5. أعد تشغيل Flutter بعد تشغيل Backend.

---