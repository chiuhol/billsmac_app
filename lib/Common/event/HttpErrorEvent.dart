import '../util/CommonUtil.dart';

class HttpErrorEvent {
  final String message;
  HttpErrorEvent(this.message);

  static errorHandleFunction(message, noTip) {
    if(noTip) {
      return message;
    }

    CommonUtil.eventBus.fire(new HttpErrorEvent(message));
    return message;
  }
}