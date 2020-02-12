import '../util/CommonUtil.dart';

class NeedRefreshEvent {
  final String className;
  NeedRefreshEvent(this.className);

  static refreshHandleFunction(name) {
    CommonUtil.eventBus.fire(new NeedRefreshEvent(name));
    return name;
  }
}