# FinResp React Native

A modern financial management app built with React Native, featuring expense tracking, budget management, and financial insights.

## Features

- 📊 **Dashboard Overview**: Real-time balance, income, and expense tracking
- 💰 **Transaction Management**: Add, edit, and categorize transactions
- 📈 **Visual Analytics**: Charts and graphs for spending patterns
- 🔐 **Secure Authentication**: Email/password authentication with Supabase
- 📱 **Cross-Platform**: Works on both iOS and Android
- 🎨 **Modern UI**: Beautiful, intuitive interface with animations
- 💾 **Offline Support**: Local data persistence with Redux Persist

## Tech Stack

- **React Native 0.73.2**
- **TypeScript**
- **Redux Toolkit** for state management
- **Supabase** for backend and authentication
- **React Navigation 6** for navigation
- **React Native Paper** for UI components
- **React Native Reanimated** for animations
- **React Native Chart Kit** for data visualization

## Getting Started

### Prerequisites

- Node.js (>= 18)
- React Native CLI
- Android Studio (for Android development)
- Xcode (for iOS development)
- CocoaPods (for iOS dependencies)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd finresp-rn
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **iOS Setup**
   ```bash
   cd ios && pod install && cd ..
   ```

4. **Environment Configuration**
   - Update Supabase credentials in `src/services/supabase.ts`
   - Configure any additional environment variables

### Running the App

**Android:**
```bash
npm run android
```

**iOS:**
```bash
npm run ios
```

**Start Metro Bundler:**
```bash
npm start
```

## Project Structure

```
src/
├── components/          # Reusable UI components
├── navigation/          # Navigation configuration
├── screens/            # Screen components
├── store/              # Redux store and slices
├── services/           # API services and utilities
├── utils/              # Helper functions
├── types/              # TypeScript type definitions
└── theme/              # App theme configuration
```

## Key Components

### Authentication
- Email/password authentication
- Automatic session management
- Secure token storage

### Dashboard
- Real-time balance calculation
- Monthly income/expense summaries
- Recent transaction list
- Expense category breakdown

### Transaction Management
- Add new transactions with categories
- Edit existing transactions
- Delete transactions
- Transaction type selection (Income/Expense)

### Data Visualization
- Pie charts for expense categories
- Balance trend indicators
- Monthly spending summaries

## Building for Production

### Android
```bash
npm run build:android
```

### iOS
```bash
npm run build:ios
```

## App Store Deployment

### Android (Google Play Store)
1. Generate signed APK/AAB
2. Create store listing
3. Upload build and metadata
4. Submit for review

### iOS (App Store)
1. Archive build in Xcode
2. Upload to App Store Connect
3. Create app listing
4. Submit for review

## Performance Optimizations

- **Image Optimization**: Fast Image for efficient image loading
- **List Performance**: Optimized FlatList rendering
- **Memory Management**: Proper cleanup of listeners and timers
- **Bundle Optimization**: Code splitting and lazy loading
- **Animation Performance**: Native driver usage for smooth animations

## Security Features

- Secure authentication with Supabase
- Local data encryption
- API key protection
- Input validation and sanitization

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support and questions, please open an issue in the repository.