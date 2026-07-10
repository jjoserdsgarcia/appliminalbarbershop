class AppointmentClass {
  final int id;
  final int professionalId;
  final int serviceId;
  final DateTime appointmentDate;
  final int startTimeAppointment;
  final int endTimeAppointment;

  AppointmentClass({
    required this.id,
    required this.professionalId,
    required this.serviceId,
    required this.appointmentDate,
    required this.startTimeAppointment,
    required this.endTimeAppointment,
  });
}
