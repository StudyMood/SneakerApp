# 👟 Sneakr — Premium Sneaker E-Commerce Mobile App

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase" />
  <img src="https://img.shields.io/badge/Provider-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Provider" />
  <img src="https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge" alt="License" />
</div>

<br/>

> **Sneakr** is a modern, high-performance Flutter mobile application designed for sneaker enthusiasts and shoppers. It features fluid micro-animations, comprehensive state management, Firebase backend integration, and a dedicated admin management dashboard.

---

## 🌟 Key Features

### 🛍️ User Experience & Storefront
- **Interactive Home & Featured Carousel**: Dynamic hero banners, category chips, and a top-trending item slider.
- **3D Interactive Card Flip**: Smooth 3D perspective flip effect allowing users to view sneaker details and specs on the flip side.
- **Product Exploration**: Filtering by category, brand, and search keywords with instant result updates.
- **Product Details Screen**: High-res imagery, interactive size/color picker, stock status, and add-to-cart animations.
- **Wishlist & Cart**: Full reactive state management with live price calculations, item counts, and discount support.
- **Checkout & Order Tracking**: Seamless multi-step checkout with live order timeline status tracking.

### 🛡️ Admin Dashboard
- **Analytics & Metrics**: Real-time sales overview, total revenue, inventory stats, and recent order feeds.
- **Product Management**: Ability to add, edit, or archive sneaker listings with images and pricing.
- **Order Management**: Update live order statuses (Processing, Shipped, Delivered) reflecting directly in user order tracking.

### 🎨 Architecture & Design
- **Clean Architecture Pattern**: Separation of Models, Providers (State Management), Services, and UI Screens/Widgets.
- **Theming**: Dark & Light mode support adhering to Material 3 design standards.
- **Offline & Mock Data Fallbacks**: Integrated mock database ready for offline demonstration and testing.

---

## 🏗️ Architecture & Project Structure

```text
lib/
├── constants/          # App colors, themes, typography tokens
│   ├── colors.dart
│   └── theme.dart
├── data/               # Mock dataset and initial catalog
│   └── mock_data.dart
├── models/             # Data models
│   ├── cart_item.dart
│   ├── notification_item.dart
│   ├── order.dart
│   └── sneaker.dart
├── providers/          # Reactive State Management (Provider)
│   ├── cart_provider.dart
│   ├── notification_provider.dart
│   ├── order_provider.dart
│   ├── sneaker_provider.dart
│   ├── theme_provider.dart
│   └── wishlist_provider.dart
├── screens/            # Application screens
│   ├── admin/          # Admin Dashboard & order fulfillment
│   ├── cart_screen.dart
│   ├── checkout_screen.dart
│   ├── home_screen.dart
│   ├── order_tracking_screen.dart
│   ├── product_details_screen.dart
│   └── ...
├── services/           # Firebase & local notifications
│   ├── firebase_service.dart
│   └── notification_service.dart
└── widgets/            # Reusable UI components
    ├── custom_button.dart
    ├── main_navigation_shell.dart
    ├── sneaker_flip_card.dart
    ├── top_items_slider.dart
    └── ...
```

---

## 🛠️ Tech Stack & Dependencies

| Layer | Technologies |
| :--- | :--- |
| **Framework** | [Flutter 3.x](https://flutter.dev) (iOS, Android, Web, Desktop) |
| **Language** | [Dart](https://dart.dev) (Null Safety enabled) |
| **State Management** | [`provider`](https://pub.dev/packages/provider) |
| **Backend & Cloud** | [Firebase Core](https://firebase.google.com), [Cloud Firestore](https://firebase.google.com/docs/firestore), [Firebase Auth](https://firebase.google.com/docs/auth) |
| **Typography & UI** | [`google_fonts`](https://pub.dev/packages/google_fonts), Cupertino Icons |
| **Utilities** | [`intl`](https://pub.dev/packages/intl), [`image_picker`](https://pub.dev/packages/image_picker) |

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.12.0` or higher)
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/)
- A physical device or Android/iOS Emulator

### Installation & Run

1. **Clone the repository:**
   ```bash
   git clone https://github.com/StudyMood/SneakerApp.git
   cd SneakerApp
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   ```bash
   flutter run
   ```

---

## 👨‍💻 Author

**Abhishek Kumar**
- GitHub: [@StudyMood](https://github.com/StudyMood)
- LinkedIn: [Abhishek Kumar](https://linkedin.com/in/Soft-Abhi-Developer)
- Email: [studymood9988@gmail.com](mailto:studymood9988@gmail.com)
