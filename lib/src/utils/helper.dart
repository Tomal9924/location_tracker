class Helper {
  static String beautifyName(String title, String firstName, String lastName) {
    String fullName = title != null ? title.trim() : "";
    fullName =
        firstName != null ? "${fullName.trim()} ${firstName.trim()}" : fullName;
    fullName =
        lastName != null ? "${fullName.trim()} ${lastName.trim()}" : fullName;
    return fullName.trim();
  }
}
