import 'dart:convert';
import 'dart:io';

class Converter {
  late String number;
  late String currentState;
  late int nextState;

  Converter(
      {required this.number,
      required this.currentState,
      required this.nextState});

  Converter.fromJson(Map<String, dynamic> json) : number = json['number'] {
    currentState = json['currentState'];
    nextState = json['nextState'];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'number': number,
      'currentState': currentState,
      'nextState': nextState
    };
  }
}

int toDecimal(String number, String currentState, int nextState) {
  var result = int.parse(number, radix: nextState);
  return result;
}

int toBinary(String number, String currentState, int nextState) {
  var myInt = int.parse(number);
  assert(myInt is int);
  var result = myInt.toRadixString(2);
  var res = int.parse(result);
  assert(res is int);
  return res;
}

int calculate(String number, String currentState, int nextState) {
  switch (nextState) {
    case 2:
      return toBinary(number, currentState, nextState);
    case 10:
      return toDecimal(number, currentState, nextState);
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
        var value = Converter.fromJson(jsonDecode(event));
        print(value);
        // отправка сообщения клиенту
        int result =
            calculate(value.number, value.currentState, value.nextState);
        socket.write(result);
        //exit(0);
      });
    });
  });
  print('Завершение main');
}
