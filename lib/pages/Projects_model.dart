class Project {
  final String id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final Duration? delayDuration;
  final List<String> workers;
  final ProjectStatus status;

  Project({
    required this.id,
    required this.name,
    this.description = '',
    required this.startDate,
    required this.endDate,
    this.delayDuration,
    this.workers = const [],
    this.status = ProjectStatus.inProgress,
  });
}

class User {
  final String id;
  final String username;
  final String email;
  final String profileImageUrl;
  final List<Project> currentProjects;
  final List<Project> completedProjects;
  final int totalDelayedProjects;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.profileImageUrl = '',
    this.currentProjects = const [],
    this.completedProjects = const [],
    this.totalDelayedProjects = 0,
  });
}

enum ProjectStatus {
  notStarted,
  inProgress,
  completed,
  delayed
}