class BookingClass {
  final int id;
  final int professionalId;
  final int serviceId;
  final DateTime dateTime;
  final String clientName;
  final String professionalName;
  final String serviceName;
  final int? clientId;

  BookingClass({required this.id, required this.professionalId, required this.serviceId, required this.dateTime, required this.clientName, required this.professionalName, required this.serviceName, this.clientId});

}