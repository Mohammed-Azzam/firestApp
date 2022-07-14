part of 'visit_cubit.dart';

abstract class VisitStates {
  const VisitStates();
}

class VisitStateInitial extends VisitStates {}

class VisitStarted extends VisitStates {}

class Visit2FinishedSuccessfully extends VisitStates {
  final Map<String, List<String>> doctorsMap;

  Visit2FinishedSuccessfully({
    required this.doctorsMap,
  });
}
class Visit3FinishedSuccessfully extends VisitStates {
  final String htmlString;

  Visit3FinishedSuccessfully({
    required this.htmlString,
  });
}

class VisitFinishedWithError extends VisitStates {}

class MapReady extends VisitStates {}
