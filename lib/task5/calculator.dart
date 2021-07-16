import 'dart:convert';
import 'dart:io';

class Calculator {
  late int num1;
  late int num2;
  late String action;

  Calculator({required this.num1, required this.num2, required this.action});

  Calculator.fromJson(Map<String, dynamic> json) : num1 = json['num1'] {
    num2 = json['num2'];
    action = json['action'];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'num1': num1, 'num2': num2, 'action': action};
  }
}

int calculate(int num1, int num2, String action) {
  switch (action) {
    case '*':
      return num1 * num2;
    case '/':
      return num1 ~/ num2;
    case '+':
      return num1 + num2;
    case '-':
      return num1 - num2;
    default:
      return 0;
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
        var value = Calculator.fromJson(jsonDecode(event));
        print(value);
        // отправка сообщения клиенту
        int result = calculate(value.num1, value.num2, value.action);
        socket.write(result);
        //exit(0);
      });
    });
  });
  print('Завершение main');
}
