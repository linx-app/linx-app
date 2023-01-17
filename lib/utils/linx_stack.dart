class LinxStack<T> {
  final _stack = <T>[];

  void push(T value) => _stack.add(value);

  T pop() => _stack.removeLast();

  T get peek => _stack.last;

  bool get isEmpty => _stack.isEmpty;

  bool get isNotEmpty => _stack.isNotEmpty;

  int get length => _stack.length;

  @override
  String toString() => _stack.toString();
}