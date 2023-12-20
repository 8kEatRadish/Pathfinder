abstract class PageStatus {
  final String value;

  PageStatus(this.value);
}

class Normal extends PageStatus {
  Normal(super.value);
}

class Loadings extends PageStatus {
  Loadings(super.value);
}

class Error extends PageStatus {
  Error(super.value);
}
