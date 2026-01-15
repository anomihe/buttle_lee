# Butler Lee - Your AI-Powered Personal Assistant

A full-stack Flutter and Serverpod application featuring email authentication, AI-powered reminders, and a universal automation engine.

## Features

- ✅ **Email/Password Authentication** with profile image uploads
- ✅ **Universal Reminder Engine** with recurring logic (daily/weekly/annual/once)
- ✅ **AI-Powered Omni-Bar** using Gemini API for natural language commands
- ✅ **Persona Engine** with Student/Worker/Personal modes
- ✅ **Real-time Multi-Device Synchronization**
- ✅ **Responsive UI** (Mobile/Tablet/Desktop)

## Project Structure

```
my_butler/
├── my_butler_server/      # Serverpod backend
├── my_butler_client/      # Generated client code
└── my_butler_flutter/     # Flutter frontend
```

## Setup Instructions

### Prerequisites

- Flutter SDK (>= 3.24.0)
- Dart SDK (>= 3.5.0)
- Docker (for running Serverpod locally)
- Gemini API Key (for AI features)

### 1. Server Setup

```bash
cd my_butler_server

# Install dependencies
dart pub get

# Start Docker containers (PostgreSQL, Redis)
docker-compose up -d

# Create database tables
dart bin/main.dart --create-migration
dart bin/main.dart --apply-migrations

# Start the server
dart bin/main.dart
```

### 2. Configure Gemini API Key

Create or edit `my_butler_server/config/passwords.yaml`:

```yaml
production:
  geminiApiKey: 'YOUR_GEMINI_API_KEY_HERE'
development:
  geminiApiKey: 'YOUR_GEMINI_API_KEY_HERE'
```

Get your Gemini API key from: https://makersuite.google.com/app/apikey

### 3. Flutter Client Setup

```bash
cd my_butler_flutter

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## Usage

### Authentication

1. **Register**: Create an account with your full name, email, password, and profile image
2. **Login**: Sign in with your credentials

### Creating Reminders

#### Using Natural Language (Omni-Bar)

Simply type commands like:
- "Remind me to eat every day at 1 PM"
- "Remind me to call mom weekly on Sunday at 10 AM"
- "Remind me about the meeting tomorrow at 3 PM"

#### Querying Reminders

- "When is my next meeting?"
- "What reminders do I have today?"
- "Show me all my reminders"

### Persona Modes

Switch between three persona modes to customize your experience:

- **Student Mode**: Vibrant, energetic theme
- **Worker Mode**: Professional, focused theme
- **Personal Mode**: Warm, comfortable theme

Tap the settings icon in the app bar to switch modes.

## Architecture

### Backend (Serverpod)

- **Protocol Models**: `ButlerReminder`, `UserProfile`, `ReminderType`
- **Endpoints**:
  - `AuthEndpoint`: User registration and profile management
  - `ReminderEndpoint`: CRUD operations for reminders
  - `AiEndpoint`: Natural language command processing
- **Services**:
  - `GeminiService`: Integrates with Google Gemini API
- **Future Calls**:
  - `ReminderExecutionCall`: Handles reminder notifications and recurring logic

### Frontend (Flutter)

- **Providers**:
  - `AuthProvider`: Authentication state management
  - `PersonaProvider`: Theme and persona mode management
  - `ReminderProvider`: Reminder CRUD and real-time updates
- **Screens**:
  - `LoginScreen`: Email/password authentication
  - `RegistrationScreen`: User registration with image upload
  - `DashboardScreen`: Main interface with reminders and Omni-Bar
- **Widgets**:
  - `OmniBar`: AI-powered command input
  - `ReminderCard`: Individual reminder display

## Real-Time Synchronization

The app uses Serverpod's streaming capabilities to ensure all devices receive reminder notifications in real-time. When a reminder is triggered:

1. The server's `ReminderExecutionCall` sends a message to all connected devices
2. The Flutter app receives the notification via the streaming connection
3. The UI updates automatically to reflect the new state

## Recurring Reminders

The system automatically reschedules recurring reminders:

- **Daily**: Repeats every 24 hours
- **Weekly**: Repeats every 7 days
- **Annual**: Repeats every year on the same date
- **Once**: Executes once and becomes inactive

## Development

### Generate Protocol Code

After modifying `.spy.yaml` files:

```bash
cd my_butler_server
serverpod generate
```

### Database Migrations

```bash
cd my_butler_server
dart bin/main.dart --create-migration
dart bin/main.dart --apply-migrations
```

## Troubleshooting

### Server won't start
- Ensure Docker containers are running: `docker-compose ps`
- Check database connection in `config/config.yaml`

### Gemini API errors
- Verify your API key in `config/passwords.yaml`
- Check your API quota at https://makersuite.google.com

### Real-time notifications not working
- Ensure the server is running
- Check that the Flutter app has an active connection
- Verify firewall settings allow WebSocket connections

## License

MIT License - feel free to use this project as a template for your own applications!

## Credits

Built with:
- [Flutter](https://flutter.dev)
- [Serverpod](https://serverpod.dev)
- [Google Gemini](https://ai.google.dev)
