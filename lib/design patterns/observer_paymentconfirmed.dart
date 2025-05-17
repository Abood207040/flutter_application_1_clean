// observer_pattern.dart

/// Observer interface
abstract class Observer {
  void update(String message);
}

/// Subject class (Observable)
class Subject {
  final List<Observer> _observers = [];

  void addObserver(Observer observer) {
    _observers.add(observer);
  }

  void removeObserver(Observer observer) {
    _observers.remove(observer);
  }

  void notifyObservers(String message) {
    for (var observer in _observers) {
      observer.update(message);
    }
  }
}

/// Concrete implementation of an observer
class StatusObserver implements Observer {
  final String name;

  StatusObserver(this.name);

  @override
  void update(String message) {
    print('[$name] received: $message');
  }
}
