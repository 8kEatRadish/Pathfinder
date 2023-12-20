import 'package:event_bus/event_bus.dart';
import 'package:pathfinder/core/utils/logger_utils.dart';

/// 消息总线管理类
class EventBusManager {
  final EventBus _eventBus = EventBus();

  static final _eventBusManager = EventBusManager._();

  EventBusManager._();

  factory EventBusManager() => _eventBusManager;

  void post(dynamic event) {
    logger.d("EventBusManager post $event");
    _eventBus.fire(event);
  }

  void on<T>(void Function(T event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    _eventBus.on<T>().listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  void onDestroy() {
    _eventBus.destroy();
  }
}
