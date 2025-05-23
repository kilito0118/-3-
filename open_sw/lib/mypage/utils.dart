enum Gender {
  male, female, others;

  String get label {
    switch (this) {
      case Gender.male:
        return '남';
      case Gender.female:
        return '여';
      case Gender.others:
        return '기타';
    }
  }
}
