class Appointment {
  final Doctor doctor;
  final String appointmentTime;

  Appointment(this.doctor, this.appointmentTime);
}

class Doctor {
  final String drName;
  final String spec;

  Doctor(this.drName, this.spec);
}
