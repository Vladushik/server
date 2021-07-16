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
  startHTTPServer();
  print('Завершение main');
}

void startHTTPServer() {
  var student = Student(name: 'Alex', age: 19);

  var encoder = JsonEncoder.withIndent(' ');
  var answer = encoder.convert(student);
  HttpServer.bind(InternetAddress.loopbackIPv4, 8080).then((server) {
    server.listen((HttpRequest request) {
      print(request.uri.path);
      if (request.uri.path.startsWith('/student')) {
        request.response.write(answer);
        request.response.close();
      } else if (request.uri.path.startsWith('/hello')) {
        request.response.write('Добро пожаловать на сервер!');
        request.response.close();
      } else {
        request.response.write('Дратути!');
        request.response.close();
      }
    });
  });
}
