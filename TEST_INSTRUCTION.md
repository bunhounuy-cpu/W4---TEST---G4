# G4 — The Clinic Appointments

## Instructions

**Analyze the starter code first!**

> **IMPORTANT — Before compiling the project**
>
> Run the following command in the terminal:
>
> ```bash
> dart pub get
> ```
>
> To run the tests, open a terminal **inside the `START-CODE` folder** and run:
>
> ```bash
> dart test test/appointment_test.dart
> ```

The code is organized into three layers: **Model, Service, and Test**.

### 1. Model Layer

- **Doctor**: Has an `id` and a `name`.
- **Patient**: Has an `id` and a `name`.
- **Appointment**: Links a `patient` and a `doctor` at a given `hour` (for example `9` means 9:00 – 10:00).

### 2. Service Layer

The `AppointmentService` manages all doctors, patients and appointments and enforces the business rules.

- **`addDoctor`**: Adds a new doctor. Throws an exception if the doctor ID already exists.
- **`addPatient`**: Adds a new patient. Throws an exception if the patient ID already exists.
- **`bookAppointment`**: Books an appointment for a patient with a doctor at a given hour.
  - The clinic is open from 8:00 to 17:00, so the last appointment starts at 16.
  - A doctor cannot have two appointments at the same hour.
  - A patient cannot have two appointments at the same hour.

### 3. Test Layer

The three existing tests check the following scenarios:

1. A normal booking.
2. Booking outside opening hours.
3. Booking a doctor who is already busy at this hour.

---

## New feature: cancelling an appointment

Patients can now **cancel** an appointment.

- A cancelled appointment is **not deleted**: it stays in the list with the status `cancelled`.
- A cancelled appointment **no longer blocks** the doctor or the patient: the slot becomes free again.

---

## Questions

### Q1. Model — 20 points

In the `appointment.dart` file:

- Create an enum `AppointmentStatus` with two values: `booked` and `cancelled`.
- Add a field `status` of type `AppointmentStatus` to the `Appointment` class. A new appointment is always `booked`. (The field must be modifiable.)
- Add a getter `bool get isActive` that returns `true` if the appointment is booked.

### Q2. Service — 40 points

Implement the following changes in the service layer:

- Create a new method:
  ```dart
  void cancelAppointment({required String patientId, required String doctorId, required int hour})
  ```
  - **Precondition:** an **active** appointment must exist for this patient, this doctor and this hour. Otherwise, throw an exception.
  - Change the status of the appointment to `cancelled`.
- Update `bookAppointment` so that **cancelled appointments are ignored** when checking whether the doctor or the patient is busy.

> Tip: look carefully at the private helper methods at the bottom of the service.

### Q3. Tests — 40 points

Write **two tests** to verify the cancellation:

1. **Valid scenario:** Patient P1 books doctor D1 at 9, then cancels. Patient P2 can now book doctor D1 at 9.
2. **Invalid scenario:** An appointment cannot be cancelled twice. Verify that an exception is thrown.

The 3 existing tests must still pass.
