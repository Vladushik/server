import 'dart:convert';
import 'dart:io';

class Student {
  final String name;
  late int age;

  Student({required this.name, required this.age});
  Student.fromJson(Map<String, dynamic> json) : name = json['name'] {
    age = json['age'];
  }

  @override
  String toString() {
    var student = 'Студент {имя: $name, возраст: $age, ';
    return student;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'age': age,
    };
  }
}

void main() {
  print('Запуск main');
  ServerSocket.bind('127.0.0.1', 8084).then((serverSocket) {
    serverSocket.listen((socket) {
      // обрабатываем соединение очередного клиента
      // с сервером
      socket.cast<List<int>>().transform(utf8.decoder).listen((event) {
        // обрабатываем данные, которые поступают
        // от клиента
        print(event);
        var student = Student.fromJson(jsonDecode(event));
        print(student);
        // отправка сообщения клиенту
        socket.write('Hello, Client');
        exit(0); // завершение работы приложения
      });
    });
  });

  print('Завершение main');
}
