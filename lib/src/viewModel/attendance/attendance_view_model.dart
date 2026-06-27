import 'package:flutter/material.dart';
import 'package:uyoung/data/image_data.dart';
import 'package:uyoung/data/model/attendance/attendance_model.dart';
import 'package:uyoung/data/model/attendance/attendance_result_model.dart';
import 'package:uyoung/data/repositories/attendance/attendance_repository.dart';

class AttendanceViewModel extends ChangeNotifier {
  AttendanceViewModel({AttendanceRepository? repository})
    : _repository = repository ?? AttendanceRepository();

  final AttendanceRepository _repository;

  AttendanceResult? _result;
  AttendanceFlowStep _step = AttendanceFlowStep.idle;
  String? _errorMessage;
  int _pearlCount = 0;
  List<AttendanceLogEntry> _logs = const [];
  bool _hasCheckedToday = false;
  DateTime? _boardStartDate;
  Map<int, AttendanceLogEntry> _weeklyLogByDay = const {};

  AttendanceResult? get result => _result;
  AttendanceFlowStep get step => _step;
  bool get isLoading => _step == AttendanceFlowStep.loading;
  String? get errorMessage => _errorMessage;
  int get pearlCount => _pearlCount;
  List<AttendanceLogEntry> get logs => List.unmodifiable(_logs);
  bool get hasCheckedToday => _hasCheckedToday;
  DateTime get boardStartDate => _boardStartDate ?? _todayKst();
  Map<int, AttendanceLogEntry> get weeklyLogByDay =>
      Map.unmodifiable(_weeklyLogByDay);

  bool get hasResult => _result != null;
  bool get isAlreadyChecked => _result?.isAlreadyChecked == true;
  int get streak => _result?.streak ?? checkedDays;
  int get checkedDays => _weeklyLogByDay.length.clamp(0, 7);
  int get currentDay {
    final dayIndex =
        _todayKst().difference(boardStartDate).inDays + 1;
    return dayIndex.clamp(1, 7);
  }
  bool get isRevealStep => _step == AttendanceFlowStep.reveal;

  AttendanceRewardKind get rewardKind {
    if (_result == null) {
      return AttendanceRewardKind.pearl;
    }

    final normalized = rewardLabel;
    if (_result!.isWin || normalized.contains('진주')) {
      return AttendanceRewardKind.pearl;
    }
    return AttendanceRewardKind.trash;
  }

  String get rewardLabel {
    final raw = (_result?.rewardLabel ?? '').replaceAll('등장!', '');
    return raw.replaceAll('등장', '').trim();
  }

  String get resultTitle =>
      rewardKind == AttendanceRewardKind.pearl ? '진주 등장!' : '바다쓰레기 등장!';

  String get resultBody {
    if (rewardKind == AttendanceRewardKind.pearl) {
      return '오늘은 해달이 진주를 들고 왔네요 :)\n내일도 출석체크 때 만나요 !';
    }
    return '오늘은 해달이 바다 쓰레기를 들고 왔네요 :(\n아쉽지만 내일 출석체크 때 만나요 !';
  }

  String get rewardImagePath {
    if (rewardKind == AttendanceRewardKind.pearl) {
      return ImagePath.attendanceItemPearl;
    }
    final normalized = rewardLabel;
    if (normalized.contains('타이어')) {
      return ImagePath.attendanceItemTrashTire;
    }
    return ImagePath.attendanceItemTrashBoot;
  }

  String get boardItemSummary {
    if (isAlreadyChecked) {
      return '오늘도 출석완료!\n아이템 확인해주세요';
    }
    return '오늘도 출석완료!\n아이템 확인해주세요';
  }

  String get boardSubSummary => '연속 출석체크 스타트!';

  String get revealTitleTop => '어! 심해에서';

  String get revealTitleBottom => '해달이 무언갈 주웠나봐요,';

  bool isCheckedOnDay(int day) => _weeklyLogByDay.containsKey(day);

  Future<AttendanceFlowStep> checkIn() async {
    if (isLoading) {
      return _step;
    }

    _step = AttendanceFlowStep.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.checkInAndDraw();
      _result = result;

      if (result.isSuccess || result.isAlreadyChecked) {
        _pearlCount = await _repository.fetchPearlCount();
        _logs = await _repository.fetchAttendanceLogs();
        _syncWeeklyBoardState();
      }

      if (result.isSuccess) {
        _step = AttendanceFlowStep.reveal;
      } else if (result.isAlreadyChecked) {
        _step = AttendanceFlowStep.board;
      } else {
        _step = AttendanceFlowStep.idle;
      }
    } catch (error) {
      _errorMessage = error.toString().replaceFirst('StateError: ', '');
      _step = AttendanceFlowStep.idle;
    } finally {
      notifyListeners();
    }

    return _step;
  }

  Future<void> loadBoardData() async {
    try {
      _logs = await _repository.fetchAttendanceLogs();
      _pearlCount = await _repository.fetchPearlCount();
      _syncWeeklyBoardState();
      notifyListeners();
    } catch (_) {
      // Entry/board UI should stay usable even if board history fails to load.
    }
  }

  void showResult() {
    _step = AttendanceFlowStep.result;
    notifyListeners();
  }

  void showBoard() {
    _step = AttendanceFlowStep.board;
    notifyListeners();
  }

  String? entryBoardItemPath(int day) {
    return boardItemPathForDay(day);
  }

  String? boardItemPathForDay(int day) {
    final log = _weeklyLogByDay[day];
    if (log == null) {
      return null;
    }

    return _mapRewardItemToPath(rewardItem: log.rewardItem, day: day);
  }

  String _mapRewardItemToPath({
    required String rewardItem,
    required int day,
  }) {
    if (day == 7) {
      return ImagePath.attendanceItemPearlBundle;
    }

    final normalized = rewardItem.trim();
    if (normalized.contains('진주')) {
      return ImagePath.attendanceItemPearl;
    }
    if (normalized.contains('타이어')) {
      return ImagePath.attendanceItemTrashTire;
    }
    if (normalized.contains('바다쓰레기') ||
        normalized.contains('부츠') ||
        normalized.contains('장화')) {
      return ImagePath.attendanceItemTrashBoot;
    }
    return ImagePath.attendanceItemQuestion;
  }

  void _syncWeeklyBoardState() {
    final today = _todayKst();
    final sortedLogs = [..._logs]
      ..sort((a, b) => a.checkInDate.compareTo(b.checkInDate));

    final cycles = <_AttendanceWeekCycle>[];

    for (final log in sortedLogs) {
      final logDate = _toKstDate(log.checkInDate);

      if (cycles.isEmpty ||
          !logDate.isBefore(cycles.last.startDate.add(const Duration(days: 7)))) {
        cycles.add(_AttendanceWeekCycle(startDate: logDate, logs: [log]));
        continue;
      }

      cycles.last.logs.add(log);
    }

    _AttendanceWeekCycle? activeCycle;
    for (final cycle in cycles.reversed) {
      final cycleEnd = cycle.startDate.add(const Duration(days: 7));
      if (!today.isBefore(cycle.startDate) && today.isBefore(cycleEnd)) {
        activeCycle = cycle;
        break;
      }
    }

    _boardStartDate = activeCycle?.startDate ?? today;
    _weeklyLogByDay = {
      for (final log in activeCycle?.logs ?? const <AttendanceLogEntry>[])
        (_toKstDate(log.checkInDate).difference(_boardStartDate!).inDays + 1): log,
    };
    _hasCheckedToday = _weeklyLogByDay.containsKey(currentDay);
  }

  DateTime _todayKst() => _toKstDate(DateTime.now().toUtc().add(const Duration(hours: 9)));

  DateTime _toKstDate(DateTime dateTime) {
    final kst = dateTime.isUtc
        ? dateTime.add(const Duration(hours: 9))
        : dateTime.toUtc().add(const Duration(hours: 9));
    return DateTime(kst.year, kst.month, kst.day);
  }
}

class _AttendanceWeekCycle {
  _AttendanceWeekCycle({
    required this.startDate,
    required this.logs,
  });

  final DateTime startDate;
  final List<AttendanceLogEntry> logs;
}
