class AppointmentClass {
  final int id;
  final int professionalId;
  final int serviceId;
  final DateTime appointmentDate;
  final String startTime;
  final String endTime;

  AppointmentClass({
    required this.id,
    required this.professionalId,
    required this.serviceId,
    required this.appointmentDate,
    required this.startTime,
    required this.endTime,
  });
}