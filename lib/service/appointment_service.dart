import '../model/appointment.dart';
import '../model/person.dart';

class AppointmentService {
  static const int openingHour = 8;
  static const int closingHour = 17;

  final List<Doctor> doctors = [];
  final List<Patient> patients = [];
  final List<Appointment> appointments = [];

  void addDoctor({required String doctorId, required String doctorName}) {
    // ! Doctor shall not exist already
    if (_findDoctorOrNull(doctorId) != null) {
      throw Exception('Doctor $doctorId already exists');
    }
    doctors.add(Doctor(id: doctorId, name: doctorName));
  }

  void addPatient({required String patientId, required String patientName}) {
    // ! Patient shall not exist already
    if (_findPatientOrNull(patientId) != null) {
      throw Exception('Patient $patientId already exists');
    }
    patients.add(Patient(id: patientId, name: patientName));
  }

  void bookAppointment({
    required String patientId,
    required String doctorId,
    required int hour,
  }) {
    // ! Patient shall exist
    Patient? patient = _findPatientOrNull(patientId);
    if (patient == null) {
      throw Exception('Patient $patientId not found');
    }

    // ! Doctor shall exist
    Doctor? doctor = _findDoctorOrNull(doctorId);
    if (doctor == null) {
      throw Exception('Doctor $doctorId not found');
    }

    // ! Hour shall be within opening hours (last appointment starts at 16)
    if (hour < openingHour || hour >= closingHour) {
      throw Exception('Hour $hour is outside opening hours');
    }

    // ! Doctor shall be free at this hour
    if (_isDoctorBusy(doctorId, hour)) {
      throw Exception('Doctor $doctorId is not free at $hour');
    }

    // ! Patient shall be free at this hour
    if (_isPatientBusy(patientId, hour)) {
      throw Exception('Patient $patientId already has an appointment at $hour');
    }

    appointments.add(Appointment(patient: patient, doctor: doctor, hour: hour));
  }

  void cancelAppointment(
      {required String patientId,
      required String doctorId,
      required int hour}) {
    // ! Patient shall exist
    Patient? patient = _findPatientOrNull(patientId);
    if (patient == null) {
      throw Exception('Patient $patientId not found');
    }

    // ! Doctor shall exist
    Doctor? doctor = _findDoctorOrNull(doctorId);
    if (doctor == null) {
      throw Exception('Doctor $doctorId not found');
    }

    for (Appointment a in appointments) {
      if (a.doctor.id == doctorId &&
          a.patient.id == patientId &&
          a.hour == hour) {
        if (a.isActive == false)
          throw Exception('An appointment cannot be cancelled twice.');
        a.status = AppointmentStatus.cancelled;
        return;
      }
    }

    throw Exception(
        '$doctorId and $patientId do not have appointment together at $hour');
  }

  Doctor? _findDoctorOrNull(String doctorId) {
    for (Doctor d in doctors) {
      if (d.id == doctorId) return d;
    }
    return null;
  }

  Patient? _findPatientOrNull(String patientId) {
    for (Patient p in patients) {
      if (p.id == patientId) return p;
    }
    return null;
  }

  bool _isDoctorBusy(String doctorId, int hour) {
    for (Appointment a in appointments) {
      if (a.doctor.id == doctorId && a.hour == hour && a.isActive == true)
        return true;
    }
    return false;
  }

  bool _isPatientBusy(String patientId, int hour) {
    for (Appointment a in appointments) {
      if (a.patient.id == patientId && a.hour == hour && a.isActive == true)
        return true;
    }
    return false;
  }
}
