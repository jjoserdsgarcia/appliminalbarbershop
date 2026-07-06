class ScheduleClass {
  final int id;
  final int professionalId;
  final int dayOfWeek;
  final String startTime; 
  final String endTime;
  final int slotDurationMinutes;

  ScheduleClass({
    required this.id,
    required this.professionalId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.slotDurationMinutes,
  });
}