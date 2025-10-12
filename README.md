Flutter Inventory App
A comprehensive and modern inventory management system built with Flutter and Firebase, designed for simplicity and real-time data synchronization.

📋 Table of Contents
About The Project

✨ Key Features

🛠️ Tech Stack

🚀 Getting Started

Prerequisites

Firebase Setup

Installation & Running

🤝 Contributing

Project by

📖 About The Project
This application provides a robust solution for managing inventory, tracking products, and handling user access with a role-based system. It's built to be cross-platform, offering a seamless experience on both Android and iOS devices. The backend is powered by Firebase, ensuring real-time database updates, secure authentication, and scalability.

This project was developed as a collaborative effort to apply modern mobile development techniques with a powerful cloud backend.

✨ Key Features
🔐 Role-Based Authentication: Secure sign-up and login for two user roles: Admin and Staff.

👤 User Management (Admin only): Admins can view all staff users, promote them to admin status, or delete them from the system.

📦 Product CRUD: Full Create, Read, Update, and Delete functionality for managing inventory products.

📈 Transaction History: Keep a log of all inventory transactions.

📊 Dashboard: A central hub to view key metrics and navigate the app's features.

☁️ Real-Time Sync: All data is synchronized in real-time across all devices using Firestore.

🛠️ Tech Stack
This project is built with a modern and scalable tech stack:

Frontend: Flutter

Programming Language: Dart

Backend & Database: Firebase

Authentication: For handling user sign-up and login.

Firestore: As the NoSQL real-time database.

🚀 Getting Started
To get a local copy up and running, follow these simple steps.

Prerequisites
Make sure you have the following installed on your machine:

Flutter SDK (latest stable version)

A code editor like VS Code or Android Studio

An Android Emulator or a physical device

Firebase Setup
This project requires a Firebase backend. You will need to create your own Firebase project to run it.

Create a Firebase Project: Go to the Firebase Console and create a new project.

Enable Authentication: In your new project, go to the Authentication section and enable the Email/Password sign-in method.

Create Firestore Database: Go to the Firestore Database section and create a new database. Start in test mode for easy setup (you can secure it with rules later).

Register Your App:

Add an Android app to your Firebase project. The package name is typically found in android/app/build.gradle (applicationId).

Follow the setup instructions to download the google-services.json file.

Place the downloaded google-services.json file inside the android/app/ directory of your Flutter project.

Installation & Running
Clone the Repository

git clone [https://github.com/Azrof88/flutter-inventory-app.git](https://github.com/Azrof88/flutter-inventory-app.git)

Navigate to Project Directory

cd flutter-inventory-app

Install Dependencies

flutter pub get

Run the App
Make sure an emulator is running or a device is connected, then run:

flutter run

🤝 Contributing
Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are greatly appreciated.

If you have a suggestion that would make this better, please fork the repo and create a pull request.

Fork the Project

Create your Feature Branch (git checkout -b feat/AmazingFeature)

Commit your Changes (git commit -m 'feat: Add some AmazingFeature')

Push to the Branch (git push origin feat/AmazingFeature)

Open a Pull Request

👥 Project by
This project is maintained by:

Azrof88

Mehedi-86

MMI122
