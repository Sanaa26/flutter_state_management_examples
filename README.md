# flutter_state_management_examples

A new Flutter project.

# 📱 Flutter Quotes App — Cubit

A Flutter Quotes application demonstrating **state management using Cubit**.

Cubit is part of the `flutter_bloc` package and provides a simpler approach compared with traditional BLoC.

## 🎯 Objective

This project demonstrates:

- Cubit
- States
- `emit()`
- `BlocBuilder`
- `BlocListener`
- API integration
- Loading state
- Success state
- Error state

## 🧠 What is Cubit?

Cubit is a simplified state-management solution from the BLoC ecosystem.

Unlike BLoC, Cubit does not require Events.

You directly call a method on the Cubit and use `emit()` to update the state.

## 🔄 Cubit Flow

```text
User Action
     ↓
Cubit Method
     ↓
Business Logic
     ↓
emit(State)
     ↓
UI Rebuild
```

## 🆚 BLoC vs Cubit

### BLoC

```text
UI
 ↓
Event
 ↓
BLoC
 ↓
State
 ↓
UI
```

### Cubit

```text
UI
 ↓
Cubit Method
 ↓
State
 ↓
UI
```

## 📌 Example

```dart
class QuoteCubit extends Cubit<QuoteState> {

  QuoteCubit() : super(QuoteInitial());

  void fetchQuote() async {

    emit(QuoteLoading());

    try {
      final quote = await getQuote();

      emit(QuoteSuccess(quote));
    } catch (e) {
      emit(QuoteError(e.toString()));
    }
  }
}
```

Call the Cubit:

```dart
context.read<QuoteCubit>().fetchQuote();
```

## 📌 BlocBuilder

```dart
BlocBuilder<QuoteCubit, QuoteState>(
  builder: (context, state) {

    if (state is QuoteLoading) {
      return const CircularProgressIndicator();
    }

    if (state is QuoteSuccess) {
      return Text(state.quote);
    }

    return const SizedBox();
  },
);
```

## 🏗️ Architecture

```text
UI
 ↓
Cubit
 ↓
Repository
 ↓
API
 ↓
State
 ↓
UI
```

## 🛠️ Technologies

- Flutter
- Dart
- flutter_bloc
- Cubit
- REST API
- JSON

## ▶️ Run

```bash
flutter pub get
flutter run
```

## 🎯 Best suited for

- Medium to large applications
- Simple BLoC architecture
- Applications without complex event requirements
- Predictable state management

## 📚 Learning Outcome

This project helps understand Cubit's simpler approach to state management and the difference between Cubit and BLoC.

> This project is created for learning and Flutter interview preparation.

