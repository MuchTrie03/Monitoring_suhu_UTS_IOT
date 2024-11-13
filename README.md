# Dashboard Monitoring Suhu

A Flutter project to monitor temperature data and display it on an interactive dashboard.

---

## Getting Started

This project is a starting point for a **Flutter application** that allows real-time monitoring of temperature data. Follow the steps below to set up and run the project locally.

---

### Requirements

Before running the app, ensure that you have the following installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (latest stable version)
- A suitable IDE like [Visual Studio Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)
- [Android Emulator](https://developer.android.com/studio/run/emulator) or a connected physical device (Android/iOS)
- [Xcode](https://developer.apple.com/xcode/) (for iOS development, required on macOS)
- **Python** (for running the server)

---

### Running the Application

Follow these steps to run the Flutter application and its backend server locally.

#### 1. **Clone the Repository**

Start by cloning the project repository to your local machine using Git:

```bash
git clone https://github.com/username/dashboard_monitoring_suhu.git

Replace username with your GitHub username or the repository owner.

2. Install Flutter Dependencies
Navigate to the project directory and install the required Flutter dependencies:

```bash

cd dashboard_monitoring_suhu
flutter pub get
This will download and install all necessary dependencies listed in the pubspec.yaml file.

3. Start the Backend Server
This project relies on a backend server to supply temperature data. You need to run the server locally first.

To do so, ensure you have Python installed on your system. Then, navigate to the folder containing the server script (server.py) and run:

bash
Copy code
python server.py
This command will start the server, which will provide the necessary data to the Flutter app.

4. Run the Flutter App
Now that the server is running, you can launch the Flutter app.

If you're using an Android emulator, make sure it is running.
Alternatively, connect a physical device via USB.
Run the Flutter application with the following command:

bash
Copy code
flutter run
This command will build and launch the app on your connected device or emulator.


