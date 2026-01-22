# 🛒 Flutter E-Commerce App

A comprehensive, modern e-commerce mobile application built with Flutter and Firebase, featuring a complete shopping experience from browsing to checkout.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?style=flat&logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-orange?style=flat&logo=firebase)](https://firebase.google.com)
[![Dart](https://img.shields.io/badge/Dart-3.x-blue?style=flat&logo=dart)](https://dart.dev)

## ✨ Features

### 🔐 Authentication & User Management
- Email/Password authentication
- Google Sign-In integration
- Facebook authentication support
- Secure user session management
- Automatic user profile creation
- Persistent login state

### 🛍️ Shopping Experience
- **Product Browsing**
  - Grid view product display
  - Category-based navigation
  - Product search functionality
  - Product details with images
  - Size selection (S, M, L, XL)
  - Quantity selection
  - Product ratings display

- **Favorites System**
  - Add/remove products from favorites
  - Real-time favorite status updates
  - Dedicated favorites page
  - Visual favorite indicators

- **Shopping Cart**
  - Add products to cart with selected size
  - Quantity increment/decrement
  - Real-time price calculations
  - Subtotal and total calculations
  - Cart persistence across sessions
  - Swipe to refresh

### 💳 Checkout & Payment
- **Payment Methods**
  - Multiple payment cards support
  - Add new payment cards
  - Select preferred payment method
  - MasterCard integration UI
  - Secure card information storage

- **Shipping & Location**
  - Multiple shipping addresses
  - Add new locations
  - Location selection with images
  - City and country information
  - Default location setting

- **Order Summary**
  - Complete order review
  - Itemized product list
  - Shipping costs calculation
  - Total amount display
  - Order confirmation

### 🎨 User Interface
- **Modern Design**
  - Material Design 3
  - Custom color schemes
  - Smooth animations and transitions
  - Responsive layouts
  - Custom navigation bar
  - Beautiful product cards

- **Home Page**
  - Auto-playing carousel banners
  - Featured products
  - Category showcase
  - New arrivals section
  - Cached network images

- **Navigation**
  - Persistent bottom navigation bar
  - 4 main tabs: Home, Cart, Favorites, Profile
  - Smooth page transitions
  - Context-aware app bar

### 📱 Additional Features
- Device preview support (development)
- Pull-to-refresh functionality
- Loading states and indicators
- Error handling and user feedback
- Firebase Cloud Messaging ready
- Offline data caching
- Image caching with CachedNetworkImage

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── constants/
│   └── assets.dart              # Asset paths
├── models/                      # Data models
│   ├── add_location_model.dart
│   ├── add_new_card.dart
│   ├── add_to_cart_model.dart
│   ├── category_model.dart
│   ├── home_carosel_item_model.dart
│   ├── product_item_model.dart
│   └── users_data_model.dart
├── services/                    # Business logic services
│   ├── auth_service.dart
│   ├── cart_service.dart
│   ├── favorite_service.dart
│   ├── firestore_services.dart
│   ├── home_service.dart
│   ├── location_service.dart
│   ├── payment_methods_service.dart
│   └── product_details_service.dart
├── utils/                       # Utilities and helpers
│   ├── api_path.dart
│   ├── app_colors.dart
│   ├── app_router.dart
│   └── app_routes.dart
├── view_models/                 # State management (Cubits)
│   ├── add_card_cubit/
│   ├── auth_cubit/
│   ├── cart_cubit/
│   ├── category_cubit/
│   ├── checkout_cubit/
│   ├── choose_location_cubit/
│   ├── favorite_cubit/
│   ├── home_cubit/
│   └── product_cubit/
├── views/                       # UI Layer
│   ├── pages/                   # Screen pages
│   │   ├── add_new_card_page.dart
│   │   ├── cart_page.dart
│   │   ├── category_tab_view.dart
│   │   ├── checkout_page.dart
│   │   ├── choose_your_location_page.dart
│   │   ├── custom_navbar.dart
│   │   ├── favorites_page.dart
│   │   ├── home_page.dart
│   │   ├── login_page.dart
│   │   ├── product_details_page.dart
│   │   ├── profile_page.dart
│   │   └── register_page.dart
│   └── widgets/                 # Reusable widgets
│       ├── checkout_headline_items.dart
│       ├── custom_app_bar.dart
│       ├── custom_button.dart
│       ├── custom_carousel_options.dart
│       ├── custom_counter.dart
│       ├── custom_counter_cart_page.dart
│       ├── custom_new_arrivals_grid_view_builder.dart
│       ├── custom_payment_card.dart
│       ├── custom_payment_methods_modal_sheet.dart
│       ├── custom_text_field.dart
│       ├── home_tab_view.dart
│       ├── new_arrivals_row.dart
│       └── product_details_body.dart
├── firebase_options.dart        # Firebase configuration
└── main.dart                    # App entry point
```

### State Management
- **BLoC Pattern** using `flutter_bloc` and `Cubit`
- Separate cubits for each feature domain
- Clear state definitions with type safety
- Reactive UI updates based on state changes
- Business logic separation from UI

## 🛠️ Tech Stack

### Frontend
- **Flutter 3.x** - Cross-platform UI framework
- **Dart 3.x** - Programming language
- **Material Design 3** - Design system

### Backend & Services
- **Firebase Authentication** - User authentication
- **Cloud Firestore** - NoSQL database
- **Firebase Cloud Messaging** - Push notifications (configured)

### State Management & Architecture
- **flutter_bloc** - State management
- **Cubit** - Simplified BLoC implementation

### UI & UX Packages
- **cached_network_image** - Image caching
- **flutter_carousel_widget** - Carousel slider
- **persistent_bottom_nav_bar_v2** - Bottom navigation
- **flutter_dash** - Dashed lines
- **device_preview** - Multi-device testing

### Additional Packages
- **google_sign_in** - Google OAuth
- **flutter_facebook_auth** - Facebook authentication

## 📋 Prerequisites

Before you begin, ensure you have:
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / Xcode for emulators
- Firebase project with:
  - Authentication enabled (Email/Password, Google, Facebook)
  - Cloud Firestore database
  - Cloud Messaging configured

## 🚀 Getting Started

### 1. Clone the Repository
```bash
git clone <repository-url>
cd flutter-ecommerce-app
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Firebase Setup

#### a. Create a Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project
3. Enable Authentication providers:
   - Email/Password
   - Google
   - Facebook (optional)
4. Create a Firestore Database

#### b. Configure Firebase for Flutter
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure
```

#### c. Update Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;

      match /cart/{cartId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }

      match /favorites/{favoriteId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }

      match /paymentMethods/{methodId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }

      match /locations/{locationId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }

    match /products/{productId} {
      allow read: if request.auth != null;
    }

    match /categories/{categoryId} {
      allow read: if request.auth != null;
    }

    match /annoucments/{annoucmentId} {
      allow read: if request.auth != null;
    }
  }
}
```

### 4. Run the App
```bash
# For development with device preview
flutter run

# For production (release mode)
flutter run --release

# For specific platform
flutter run -d android
flutter run -d ios
flutter run -d chrome
```

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🎯 Key Features Explained

### Shopping Cart System
- Real-time cart updates with Firestore
- Quantity management with increment/decrement
- Size selection for each product
- Automatic price calculations
- Persistent cart across sessions
- Loading states for each cart operation

### Favorites Management
- Toggle favorite status with heart icon
- Real-time synchronization
- Separate favorites page
- Remove from favorites functionality
- Visual feedback for favorite status

### Checkout Process
1. **Cart Review**: View all cart items with quantities
2. **Shipping Address**: Select or add new location
3. **Payment Method**: Choose or add payment card
4. **Order Summary**: Review total and proceed
5. **Confirmation**: Complete the purchase

### State Management Flow
```dart
// Example: Cart Cubit Flow
CartCubit
  ├── fetchCartItems() → CartSuccess
  ├── increment() → QuantityCounterLoaded → SubTotalUpdated
  ├── decrement() → QuantityCounterLoaded → SubTotalUpdated
  └── Error handling → CartFailure
```

### Data Models
- **ProductItemModel**: Product information with variants
- **AddToCartModel**: Cart items with selected options
- **CategoryModel**: Product categories with styling
- **LocationItemModel**: Shipping addresses
- **AddNewCard**: Payment methods
- **UsersDataModel**: User profile data

## 🔒 Security Best Practices

- ✅ Firestore security rules implemented
- ✅ User authentication required for all operations
- ✅ Data scoped to authenticated user
- ✅ Secure authentication flows
- ✅ Input validation on forms

### Production Security Checklist
- [ ] Enable App Check for Firebase
- [ ] Implement rate limiting
- [ ] Add comprehensive input validation
- [ ] Enable reCAPTCHA for authentication
- [ ] Set up Cloud Functions for sensitive operations
- [ ] Implement proper error logging
- [ ] Add data encryption for sensitive information

## 🐛 Known Issues

- Device preview enabled in development (should be disabled in production)
- Facebook authentication requires additional platform-specific setup
- Image caching might need clearing on first run
- Some hardcoded dummy data in models for testing

## 🛣️ Roadmap

### Phase 1 (Current)
- [x] User authentication
- [x] Product browsing
- [x] Shopping cart
- [x] Favorites system
- [x] Checkout flow

### Phase 2 (Upcoming)
- [ ] Order history
- [ ] Order tracking
- [ ] Push notifications for orders
- [ ] Product reviews and ratings
- [ ] Search and filters
- [ ] Wishlist sharing

### Phase 3 (Future)
- [ ] Multiple payment gateways
- [ ] Coupon and discount codes
- [ ] Product recommendations
- [ ] Admin dashboard
- [ ] Analytics integration
- [ ] Multi-language support
- [ ] Dark mode
- [ ] Offline mode improvements

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 Code Style

This project follows the [Effective Dart](https://dart.dev/guides/language/effective-dart) style guide.

Run the following before committing:
```bash
# Format code
dart format .

# Analyze code
flutter analyze

# Run tests (when available)
flutter test
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Yusuf Mohamed**
- GitHub: [@yusuf-4444](https://github.com/yusuf-4444)
- LinkedIn: [Yusuf Mohamed](https://www.linkedin.com/in/yusuf-mohamed-8a2798306/)

## 🙏 Acknowledgments

- [Flutter Team](https://flutter.dev) for the amazing framework
- [Firebase](https://firebase.google.com) for backend services
- [BLoC Library](https://bloclibrary.dev) for state management
- [CachedNetworkImage](https://pub.dev/packages/cached_network_image) for image optimization
- [Persistent Bottom Nav Bar](https://pub.dev/packages/persistent_bottom_nav_bar_v2) for navigation

## 📞 Support

If you have any questions or need help:
- Open an issue on GitHub
- Reach out via LinkedIn
- Star this repository if you find it helpful!

---

⭐ If you found this project helpful, please give it a star!

**Made with ❤️ and Flutter**
