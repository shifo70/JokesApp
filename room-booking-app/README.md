# Room Booking App

تطبيق حجز غرف — Flutter + Node.js/Express + MySQL

---

## هيكل المشروع

```
room-booking-app/
├── database/
│   └── schema.sql          ← شغّله في MySQL Workbench
├── backend/                ← API (Node.js + Express)
└── flutter_app/            ← تطبيق الموبايل (Flutter)
```

---

## 1. إعداد قاعدة البيانات (MySQL Workbench)

### الخطوات:

1. افتح **MySQL Workbench** واتصل بـ MySQL Server المحلي.
2. من القائمة: **File → Open SQL Script**
3. اختر الملف: `database/schema.sql`
4. اضغط **Execute** (⚡) لتشغيل السكربت.

سيتم إنشاء:
- قاعدة بيانات `room_booking_db`
- جداول: `users`, `rooms`, `bookings`
- حساب Admin جاهز + 3 غرف تجريبية

### حساب الأدمن الافتراضي:

| Email | Password |
|-------|----------|
| admin@hotel.com | admin123 |

> إذا لم تُدرج بيانات الأدmin من SQL، شغّل: `npm run seed` من مجلد backend.

---

## 2. تشغيل الـ Backend

```bash
cd backend
cp .env.example .env
```

عدّل ملف `.env` ببيانات MySQL Workbench:

```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=YOUR_MYSQL_PASSWORD
DB_NAME=room_booking_db
```

```bash
npm install
npm start
```

السيرفر يعمل على: `http://localhost:3000`

---

## 3. اختبار API في Postman

### تسجيل عميل جديد
```
POST http://localhost:3000/auth/register
Body (JSON): { "name": "Ali", "email": "ali@test.com", "password": "123456" }
```

### تسجيل الدخول
```
POST http://localhost:3000/auth/login
Body (JSON): { "email": "admin@hotel.com", "password": "admin123" }
```
احفظ الـ `token` من الرد.

### إضافة غرفة (Admin فقط)
```
POST http://localhost:3000/rooms
Headers: Authorization: Bearer YOUR_TOKEN
Body (JSON): { "name": "Room 201", "price": 80, "status": "available" }
```

### عرض الغرف
```
GET http://localhost:3000/rooms
```

### حجز غرفة (Customer فقط)
```
POST http://localhost:3000/bookings
Headers: Authorization: Bearer CUSTOMER_TOKEN
Body (JSON): { "room_id": 1 }
```

> **اختبار مهم:** احجز نفس الغرفة مرتين — المرة الثانية يجب أن ترفض مع رسالة "already occupied".

---

## 4. تشغيل تطبيق Flutter

```bash
cd flutter_app
flutter pub get
flutter run
```

### عنوان الـ API

التطبيق يختار العنوان تلقائياً حسب المنصة:

| البيئة | العنوان |
|--------|---------|
| Flutter Web / Windows / macOS | `http://localhost:3000` |
| Android Emulator | `http://10.0.2.2:3000` |
| iOS Simulator | `http://localhost:3000` |
| جهاز حقيقي | `http://YOUR_PC_IP:3000` (عدّل في `api_service.dart`) |

---

## استكشاف الأخطاء

### "Connection failed. Is the backend running?"

1. **شغّل الـ Backend أولاً** (قبل Flutter):
   ```bash
   cd backend
   npm install
   npm start
   ```
   يجب أن ترى: `Server running on http://localhost:3000`

2. **تأكد من MySQL:**
   - MySQL Server شغّال في Workbench
   - نفّذت `database/schema.sql`
   - ملف `.env` فيه كلمة مرور MySQL الصحيحة

3. **اختبر الـ API في المتصفح:**
   افتح: http://localhost:3000  
   يجب أن ترى: `{"message":"Room Booking API is running."}`

4. **أعد تشغيل Flutter** بعد تشغيل Backend:
   ```bash
   cd flutter_app
   flutter run -d chrome
   ```

---

## 5. API Endpoints

| Method | Endpoint | من يستخدمه | الوظيفة |
|--------|----------|------------|---------|
| POST | /auth/register | الجميع | إنشاء حساب عميل |
| POST | /auth/login | الجميع | تسجيل الدخول + JWT |
| GET | /rooms | الجميع | عرض الغرف |
| POST | /rooms | Admin | إضافة غرفة |
| PUT | /rooms/:id | Admin | تعديل غرفة |
| POST | /bookings | Customer | حجز غرفة |

---

## 6. منطق الحجز (الأهم)

عند حجز غرفة، السيرفر يستخدم **Transaction + SELECT FOR UPDATE**:
1. يقفل صف الغرفة في قاعدة البيانات
2. يتحقق: هل الحالة `available`؟
3. إذا نعم → ينشئ الحجز ويغيّر الحالة إلى `occupied`
4. إذا لا → يرفض مع رسالة خطأ 400

هذا يمنع حجزين متزامنين لنفس الغرفة.

---

## Tech Stack

- **Frontend:** Flutter (Dart)
- **Backend:** Node.js + Express
- **Database:** MySQL (MySQL Workbench)
