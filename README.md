# Expense-Manager

**Expense-Manager** is a user-friendly mobile application designed to help individuals efficiently track and manage their expenses. With this app, users can easily log their daily transactions, edit or delete transactions, and check statistics for their total expenses.

## Features

- **Transaction Logging**: Quickly add daily transactions with details such as amount, category, and date.
- **Edit & Delete Transactions**: Modify or remove entries as needed to keep your expense records accurate.
- **Statistics Overview**: View insights into your spending habits and track your total transactions over time.
- **User-Friendly Interface**: Designed with simplicity and usability in mind for all users.

## Technology Stack

- **Flutter**: The primary framework used for building the application, responsible for all logic and user interface components.
- **Dart**: The programming language used to write the app.
- **Shared Preferences**: Used for local data storage, allowing users to save and retrieve their transaction data seamlessly.

## Getting Started

### Prerequisites

Before you begin, ensure you have met the following requirements:

- Flutter SDK installed.
- A Firebase project set up (for authentication and Firestore).
- Xcode (for iOS development) or Android Studio (for Android development).
- Basic knowledge of Dart and Flutter.

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/FelixA8/Expense-Manager.git
   cd Expense-Manager

2. Clone the repository:
   ```bash
   flutter pub get

3. Run the app:
   ```bash
   flutter run

## Project Structure

The project is organized as follows:

```bash
expense_manager/
├── lib/
│   ├── main.dart          # Entry point of the application
│   ├── models/            # Data models for transactions
│   ├── screens/           # UI screens for the application
│   ├── widgetsForScreen/  # Reusable UI components
│   └── file_helper.dart/  # Business logic for storing data internally
├── pubspec.yaml           # Project dependencies and metadata
