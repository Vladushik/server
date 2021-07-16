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
  startUDPServer();
  print('Завершение main');
}

// util.UDP
void startUDPServer() async {
  var rawDgramSocket =
      await RawDatagramSocket.bind(InternetAddress.loopbackIPv4, 8083);

  await for (RawSocketEvent event in rawDgramSocket) {
    if (event == RawSocketEvent.read) {
      var datagram = rawDgramSocket.receive();
      var json = utf8.decode(datagram!.data);
      print(json);
      var student = Student.fromJson(jsonDecode(json));
      print(student);
      rawDgramSocket.send(
          utf8.encode('Hello, Client'), InternetAddress.loopbackIPv4, 8084);
      rawDgramSocket.close();
      exit(0);
    }
  }
}
