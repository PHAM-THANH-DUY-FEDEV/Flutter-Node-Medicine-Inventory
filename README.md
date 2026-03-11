# Medicine Inventory Flutter App

This project is a Flutter-based medicine inventory management system with Node.js backend and MongoDB database

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Node.js](https://nodejs.org/)
- [MongoDB](https://www.mongodb.com/)

## requirement

- Flutter version: 3.29.3
- Dart SDK version: 3.7.2
- Node.js version: 22.15.0

### Backend Setup

1. Navigate to the backend folder (NodeBackend):
   ```bash
   cd NodeBackend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Start the server:
   ```bash
   node index.js
   ```
   The backend will run on `http://localhost:3000`.

### Frontend Setup

1. Navigate to the Flutter project folder (FlutterApp):
   ```bash
   cd FlutterApp
   ```
2. Get Flutter packages:

   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## If you want to run on a mobile device using android studio

To run on a mobile device using Android Studio:

1. Open the `FlutterApp` folder in Android Studio.

2. Get Flutter packages:

   ```bash
   flutter pub get
   ```

3. Connect your Android device via USB or start an emulator.

4. Open the file `FlutterApp/lib/main.dart` (install the Dart plugin and Dart SDK if
   they are not already installed).

5. enable Dart Support

6. Click the **Run** button or use `Shift + F10` to launch the app on your device.

## Features

- Manage medicines: add, update, and delete entries
- View billing lists
- Integrate seamlessly with a Node.js backend API
- Automatically update inventory status statistics

## Configuration

- Update API endpoints in Flutter code if backend runs on a different host/port.

## License

This project is licensed under the MIT License.

## Image Credits

- [Pharmacy](https://www.pharmacity.vn/)
- [Thế giới di động](https://cdn.thegioididong.com/Products/Images/10037/157547/canesten-cream-2.jpg)
- [Trung tâm thuốc](https://trungtamthuoc.com/images/products/kremil-gel-5-p6287.jpg)
