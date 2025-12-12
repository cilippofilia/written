# written

> ⚠️ **Work in Progress** - This project is currently under active development. Features may be incomplete or subject to change.

A privacy-focused journaling app for iOS that uses Apple Intelligence to provide thoughtful, personalized responses to your journal entries.

## Overview

**written** is a minimalist journaling application that combines the power of on-device AI with a beautiful, distraction-free writing experience. Unlike traditional journaling apps that send your thoughts to external servers, written uses Apple Intelligence to process your entries entirely on your device, ensuring complete privacy.

## Planned Features

### ✍️ Distraction-Free Writing
- Clean, minimal text editor with dynamic placeholder text
- Focus mode that fades distractions when you're writing
- Beautiful glass-effect UI elements

### ⏱️ Writing Timer
- Set writing sessions from 5 seconds to 30 minutes
- Pause and resume functionality
- Visual timer display
- Alerts when time is up

### 🤖 AI-Powered Responses
Choose from five different response styles tailored to your needs:

- **Reflective**: A friend-like conversation that helps you process your thoughts
- **Insightful**: Deep analysis with metaphors and powerful imagery
- **Actionable**: Concrete next steps and roadmaps to move from thinking to doing
- **Validating**: Warm support and reassurance when you need it
- **Challenging**: Honest feedback that calls out patterns and contradictions

### 🔒 Privacy-First
- All processing happens on-device using Apple Intelligence
- No data sent to external servers
- Private Cloud Compute for advanced features (when needed)
- Your thoughts stay yours

## Requirements

- iOS 18.0 or later
- Device with Apple Intelligence support
- Apple Intelligence enabled in device settings

## Architecture

The app follows a clean SwiftUI architecture:

```
written/
├── Views/
│   ├── Main/
│   │   └── HomeView.swift          # Main writing interface
│   ├── Settings/
│   │   ├── SettingsView.swift      # Settings screen
│   │   └── WhyAIView.swift         # Privacy explanation
│   └── AvailabilityView.swift      # Apple Intelligence availability check
├── Models/
│   └── HomeViewModel.swift          # Business logic and state management
├── Helpers/
│   ├── Constants.swift              # App constants
│   ├── Prompts.swift                # AI prompt templates
│   └── ModelPlayground.swift        # Development utilities
└── writtenApp.swift                 # App entry point
```

## Key Technologies

- **SwiftUI**: Modern declarative UI framework
- **FoundationModels**: Apple's framework for on-device AI processing
- **Observable**: Swift's observation framework for reactive state management

## Getting Started

1. Open `written.xcodeproj` in Xcode
2. Ensure your development device supports Apple Intelligence
3. Build and run the project

## Project Status

This project is currently a **work in progress**. Here's what's implemented and what's coming:

### ✅ Implemented
- Writing interface with text editor
- Timer functionality (start, pause, stop)
- Apple Intelligence availability checking
- Multiple AI prompt templates defined
- Privacy-focused architecture foundation
- Glass-effect UI components

### 🚧 In Progress / Planned
- Settings view (currently placeholder)
- AI response processing and display
- Sending journal entries to AI
- Response style selection UI
- Additional UI polish and refinements

## License

Copyright © 2025 Filippo Cilia. All rights reserved.

## Author

Created by Filippo Cilia

---

*"Begin writing... Pick a thought and go... Just start..."*

