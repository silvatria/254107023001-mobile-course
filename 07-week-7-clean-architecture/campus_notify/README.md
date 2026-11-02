# Campus Notify

The app uses a small Clean Architecture structure:

```text
lib/
├── data/
│   ├── datasources/
│   ├── models/
│   ├── repositories/
│   └── services/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── pages/
│   └── providers/
└── main.dart
```

`domain` contains the app entities, repository contracts, and use cases.
`data` implements those contracts and handles storage and platform services.
`presentation` contains the screens and Riverpod state. Dependencies flow
toward `domain`; `main.dart` wires the app and notification lifecycle.

The demo login credentials are `chen@polinema.ac.id` / `password123`.
