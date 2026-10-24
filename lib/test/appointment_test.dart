import 'package:test/test.dart';

import '../service/appointment_service.dart';

void main() {
  test('books an appointment', () {
    final appointmentService = AppointmentService();
    appointmentService.addPatient(patientId: 'P1', patientName: 'Dara');
    appointmentService.addDoctor(doctorId: 'D1', doctorName: 'Dr. Sok');

    appointmentService.bookAppointment(
        patientId: 'P1', doctorId: 'D1', hour: 9);

    expect(appointmentService.appointments.length, 1);
    expect(appointmentService.appointments.first.patient.name, 'Dara');
  });

  test('cannot book an appointment outside opening hours', () {
    final appointmentService = AppointmentService();
    appointmentService.addPatient(patientId: 'P1', patientName: 'Dara');
    appointmentService.addDoctor(doctorId: 'D1', doctorName: 'Dr. Sok');

    expect(
      () => appointmentService.bookAppointment(
          patientId: 'P1', doctorId: 'D1', hour: 17),
      throwsException,
    );
  });

  test('cannot book a doctor who is already busy at this hour', () {
    final appointmentService = AppointmentService();
    appointmentService.addPatient(patientId: 'P1', patientName: 'Dara');
    appointmentService.addPatient(patientId: 'P2', patientName: 'Sokha');
    appointmentService.addDoctor(doctorId: 'D1', doctorName: 'Dr. Sok');

    appointmentService.bookAppointment(
        patientId: 'P1', doctorId: 'D1', hour: 9);

    expect(
      () => appointmentService.bookAppointment(
          patientId: 'P2', doctorId: 'D1', hour: 9),
      throwsException,
    );
  });

  // TODO Q3: add your 2 tests here
  test('cancelled appointment and rebook with another patient', () {
    final appointmentService = AppointmentService();
    appointmentService.addPatient(patientId: 'P1', patientName: 'Dara');
    appointmentService.addPatient(patientId: 'P2', patientName: 'Sokha');
    appointmentService.addDoctor(doctorId: 'D1', doctorName: 'Dr. Sok');

    appointmentService.bookAppointment(
        patientId: 'P1', doctorId: 'D1', hour: 9);
    appointmentService.cancelAppointment(
        patientId: 'P1', doctorId: 'D1', hour: 9);

    appointmentService.bookAppointment(
        patientId: 'P2', doctorId: 'D1', hour: 9);

    expect(appointmentService.appointments.length, 2);
    expect(appointmentService.appointments.last.patient.name, 'Sokha');
  });

  test('can not cancelled appointment twice', () {
    final appointmentService = AppointmentService();
    appointmentService.addPatient(patientId: 'P1', patientName: 'Dara');
    appointmentService.addDoctor(doctorId: 'D1', doctorName: 'Dr. Sok');

    appointmentService.bookAppointment(
        patientId: 'P1', doctorId: 'D1', hour: 9);

    appointmentService.cancelAppointment(
        patientId: 'P1', doctorId: 'D1', hour: 9);

    expect(
      () => appointmentService.cancelAppointment(
          patientId: 'P1', doctorId: 'D1', hour: 9),
      throwsException,
    );
  });
}
