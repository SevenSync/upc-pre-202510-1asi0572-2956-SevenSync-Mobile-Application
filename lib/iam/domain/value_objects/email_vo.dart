class Email {
  final String value;

  Email(this.value) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value)) {
      throw FormatException('Correo inválido');
    }
  }
}
