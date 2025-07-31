# 🚀 GitHub PR Viewer (Flutter Assignment)

A Flutter app that displays open pull requests for a public GitHub repository, simulating token-based login and demonstrating clean architecture, pagination, error handling, shimmer loading, and more.

---

## Project Structure

```
github_pr_viewer/
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   └── utils/
│   ├── data/
│   │   ├── models/
│   │   └── services/
│   ├── features/
│   │   ├── auth/
│   │   └── pr/
│   └── main.dart
├── pubspec.yaml
└── README.md
```

---

## 🛠 Setup Instructions

1. **Clone the repo**
   ```bash
   git clone https://github.com/Trexmark32/github-pr-viewer.git
   cd github-pr-viewer
   ```
2. **Install packages**
   ```bash
   flutter pub get
   ```
3. **Create .env file (optional to prevent rate limiting from github) and add**
   - GITHUB_ACCESS_TOKEN=<YOUR_GITHUB_ACCESS_TOKEN>

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 🔐 Token Handling (Simulated Login)
Although GitHub’s public PR API doesn't require authentication, this app simulates a login flow to demonstrate secure token storage:

A dummy login screen accepts any username and stores a fake token (abc123) using shared_preferences.

After login:
- The token is stored persistently
- The PR screen is shown on next app launch if token exists
- The token is retrieved and logged/displayed in the UI
- The PR screen shows cards with following details
    - PR Creator Profile
    - PR Creator Name
    - Created Date
    - Branch Info
    - PR Title
    - Body/Description (if available)

---

## 🚀 Other Features Implemented
- ✅ Pull to refresh
- ✅ Infinite scroll with pagination
- ✅ Retry on error
- ✅ Shimmer loading during initial load (skeletonizer)
- ✅ Responsive layout
- ✅ Dark mode support
- ✅ Modular project structure
- ✅ Error feedback via SnackBar
- ✅ Token handling (simulated)
- ✅ Scroll controller for dynamic loading
- ✅ Token display and logging

---

## 🐞 Known Issues / Limitations
- ❌ No actual GitHub OAuth — token is a dummy (abc123)
- ❌ No persistent logout mechanism yet
- ❌ JWT or token expiry detection not implemented (not needed for fake token)
- ⚠️ Using GitHub API anonymously → rate-limited to 60 req/hr per IP