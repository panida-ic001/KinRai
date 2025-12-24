import 'package:background_fetch/background_fetch.dart';
import 'health_service.dart';
import '../db/database_helper.dart';

class BackgroundService {
  static Future<void> init() async {
    BackgroundFetch.registerHeadlessTask(_headlessTask);

    await BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        enableHeadless: true,
        startOnBoot: true,
        requiredNetworkType: NetworkType.ANY,
      ),
      _onFetch,
      _onTimeout,
    );
  }

  static Future<void> _runIf7() async {
    final now = DateTime.now();

    // ยอมคลาด 10 นาที
    final isTarget = now.hour == 10 && now.minute < 10;

    if (!isTarget) return;

    //await DatabaseHelper.instance.init();
    await DatabaseHelper.instance.insertBgLog(
      message: 'Background fetch triggered',
      runType: 'background',
    );

    await DatabaseHelper.instance.insertBgLog(
      message: 'Health fetch started',
      runType: 'background',
    );

    final service = HealthService();
    await service.fetchAndSaveHealthData();

    await DatabaseHelper.instance.insertBgLog(
      message: 'Health fetch finished',
      runType: 'background',
    );
  }

  static void _onFetch(String taskId) async {
    await DatabaseHelper.instance.insertBgLog(
      message: 'Background fetch triggered',
      runType: 'background',
    );
    final service = HealthService();
    await service.fetchAndSaveHealthData();

    await DatabaseHelper.instance.insertBgLog(
      message: 'Background fetch finished',
      runType: 'background',
    );

    BackgroundFetch.finish(taskId);
  }

  static void _onTimeout(String taskId) async {
    print('[BG] Timeout');
    BackgroundFetch.finish(taskId);
  }

  static void _headlessTask(HeadlessTask task) async {
    if (task.timeout) {
      BackgroundFetch.finish(task.taskId);
      return;
    }

    await _runIf7();
    BackgroundFetch.finish(task.taskId);
  }

  static int _millisecondsUntil7AM() {
    final now = DateTime.now();
    final today7AM = DateTime(now.year, now.month, now.day, 7);

    if (now.isBefore(today7AM)) {
      return today7AM.difference(now).inMilliseconds;
    } else {
      final tomorrow7AM = DateTime(now.year, now.month, now.day + 1, 7);
      return tomorrow7AM.difference(now).inMilliseconds;
    }
  }
}
