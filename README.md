# 🃏 Flip-Card Game (Flutter + BLoC)

A minimalist **memory match game** built with **Flutter** and **BLoC**.  
Players flip cards to find pairs, track their **time** and **moves**, and try to clear the board as fast as possible.  
This project demonstrates clean architecture, state management, and smooth UI animations — perfect for a portfolio.

---

## 🎮 Features
- Difficulty levels: **2×2, 3×4, 4×4, 5×6**  
- Animated card flips (front/back)  
- HUD with **Timer** and **Moves** counter  
- Reset button to start a fresh game  
- Light & Dark themes  
- Responsive design (works on phones & tablets)  

---

## 🛠️ Tech Stack
- **Flutter** (UI + animations)  
- **BLoC** (state management)  
- **Repository pattern** (deck generation & logic)  
- **Custom Theme** (colors, text styles, card styles)  

---

## 📂 Project Structure
lib/
├─ core/
│ ├─ models/ # CardItem, Difficulty
│ ├─ theme/ # app_colors.dart, app_text_styles.dart, app_theme.dart
│ └─ utils/ # shuffle, timer helpers
│
├─ data/
│ └─ repositories/ # game_repository.dart
│
├─ features/
│ ├─ menu/ # home_page.dart
│ └─ game/
│   ├─ bloc/ # game_bloc.dart, game_event.dart, game_state.dart
│   ├─ widgets/ # card_tile.dart
│   └─ pages/ # game_page.dart
│
├─ app.dart # MaterialApp, routes, theme
└─ main.dart # entry point
---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.19+)  
- Dart 3+  

### Installation
```bash
# Clone the repo
git clone https://github.com/your-username/flip-card-game.git
cd flip-card-game

# Install dependencies
flutter pub get

# Run the app
flutter run
