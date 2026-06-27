enum AttendanceFlowStep {
  idle,
  loading,
  reveal,
  result,
  board,
}

enum AttendanceRewardKind {
  pearl,
  trash,
}

class AttendanceLogEntry {
  const AttendanceLogEntry({
    required this.checkInDate,
    required this.rewardItem,
  });

  final DateTime checkInDate;
  final String rewardItem;

  factory AttendanceLogEntry.fromMap(Map<String, dynamic> map) {
    return AttendanceLogEntry(
      checkInDate: DateTime.tryParse(
            (map['check_in_date'] ?? '').toString(),
          ) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      rewardItem: (map['reward_item'] ?? '').toString(),
    );
  }
}
