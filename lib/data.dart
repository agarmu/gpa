enum ClassType {
  OnLevel,
  Advanced,
  DualCredit,
  AdvancedPlacement,
  InternationalBaccalaureate,
}

extension GPA on ClassType {
  double get gpa {
    switch (this) {
      case ClassType.OnLevel:
        return 4.0;
      case ClassType.Advanced:
      case ClassType.DualCredit:
        return 4.5;
      case ClassType.AdvancedPlacement:
      case ClassType.InternationalBaccalaureate:
        return 5.0;
      default:
        throw Exception("Invalid class type $this");
    }
  }

  String get short {
    switch (this) {
      case ClassType.OnLevel:
        return "OL";
      case ClassType.Advanced:
        return "AD";
      case ClassType.DualCredit:
        return "DC";
      case ClassType.AdvancedPlacement:
        return "AP";
      case ClassType.InternationalBaccalaureate:
        return "IB";
      default:
        throw Exception("Invalid class type $this");
    }
  }

  ClassType get next {
    switch (this) {
      case ClassType.OnLevel:
        return ClassType.Advanced;
      case ClassType.Advanced:
        return ClassType.DualCredit;
      case ClassType.DualCredit:
        return ClassType.AdvancedPlacement;
      case ClassType.AdvancedPlacement:
        return ClassType.InternationalBaccalaureate;
      case ClassType.InternationalBaccalaureate:
        return ClassType.OnLevel;
      default:
        throw Exception("Invalid clas type $this");
    }
  }
}

class ClassInfo {
  ClassInfo({this.name = ""});
  String name;
  ClassType type = ClassType.OnLevel;
  double? _firstQuarter;
  double? get firstQuarter {
    return _firstQuarter;
  }

  set firstQuarter(double? v) {
    double? value = v;
    if (value == null) {
      _firstQuarter = null;
    } else if (value <= 100 && value >= 0) {
      _firstQuarter = value;
    } else {
      _firstQuarter = null;
    }
  }

  double? _secondQuarter;
  double? get secondQuarter {
    return _secondQuarter;
  }

  set secondQuarter(double? value) {
    if (value == null) {
      _secondQuarter = null;
    } else if (value <= 100 && value >= 0) {
      _secondQuarter = value;
    } else {
      _secondQuarter = null;
    }
  }

  double? _finalExam;
  double? get finalExam {
    return _finalExam;
  }

  set finalExam(double? value) {
    if (value == null) {
      _finalExam = null;
    } else if (value <= 100 && value >= 0) {
      _finalExam = value;
    } else {
      _finalExam = null;
    }
  }

  double? get grade {
    if (firstQuarter == null) {
      return null;
    } else if (secondQuarter == null) {
      return firstQuarter;
    } else if (finalExam == null) {
      return (firstQuarter! + secondQuarter!) / 2;
    } else {
      return (firstQuarter! * .4) + (secondQuarter! * .4) + (finalExam! * .2);
    }
  }

  double? get gpa {
    var grade = this.grade;
    if (grade == null) {
      return null;
    } else if (grade >= 70) {
      return type.gpa - ((100 - grade) * .05);
    }
    return null;
  }
}

extension CollectionGpa<T extends List<ClassInfo>> on T {
  double? get gpa {
    var length = 0.0;
    var sum = 0.0;
    this.forEach((element) {
      var gpa = element.gpa;
      if (gpa == null) {
        return null;
      } else {
        length += 1;
        sum += gpa;
      }
    });
    if (length == 0) {
      return null;
    } else {
      return sum / length;
    }
  }
}
