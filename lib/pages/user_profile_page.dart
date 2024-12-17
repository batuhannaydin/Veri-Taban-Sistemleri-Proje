import 'package:flutter/material.dart';
import 'Projects_model.dart';

class UserProfilePage extends StatelessWidget {
  final User user;

  const UserProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Project> temporaryProjects = [
      Project(
        id: "1",
        name: 'Demo Project 1',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 30)),
        status: ProjectStatus.inProgress,
        workers: ['Alice', 'Bob'],
        delayDuration: Duration(hours: 5),
      ),
      Project(
        id: "2",
        name: 'Demo Project 2',
        startDate: DateTime.now().subtract(Duration(days: 10)),
        endDate: DateTime.now().add(Duration(days: 20)),
        status: ProjectStatus.completed,
        workers: ['Charlie'],
      ),
      Project(
        id: "3",
        name: 'Demo Project 3',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 60)),
        status: ProjectStatus.notStarted,
        workers: ['David', 'Eve'],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Kullanıcı Profili'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: EdgeInsets.all(16),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: user.profileImageUrl.isNotEmpty
                        ? NetworkImage(user.profileImageUrl)
                        : null,
                    child: user.profileImageUrl.isEmpty
                        ? Icon(
                        Icons.person,
                        size: 50,
                    )
                        : null,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.username,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user.email,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Current Projects Section
            _buildSectionTitle(context, 'Devam Eden Projeler'),
            _buildProjectList(context, user.currentProjects, 'Devam Eden'),

            // Completed Projects Section
            _buildSectionTitle(context, 'Tamamlanan Projeler'),
            _buildProjectList(context, user.completedProjects, 'Tamamlanan'),

            // Project Performance
            _buildSectionTitle(context, 'Proje Karnesi'),
            Card(
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildPerformanceItem(
                      'Tamamlanan Görevler',
                      (user.currentProjects.length + user.completedProjects.length).toString(),
                    ),
                    _buildPerformanceItem(
                      'Geciken Görevler',
                      user.totalDelayedProjects.toString(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProjectList(BuildContext context, List<Project> projects, String type) {
    if (projects.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          '$type proje bulunmamaktadır',
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProjectDetailsPage(project: project),
                  ),
                );
              },
              child: Text(project.name),
            ),
            subtitle: Text(
              'Başlangıç: ${project.startDate.day}.${project.startDate.month}.${project.startDate.year}',
            ),
            trailing: project.status == ProjectStatus.delayed
                ? Text(
              'Gecikme',
              style: TextStyle(color: Colors.red),
            )
                : null,
          ),
        );
      },
    );
  }

  Widget _buildPerformanceItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}

class ProjectDetailsPage extends StatelessWidget {
  final Project project;

  const ProjectDetailsPage({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Başlangıç Tarihi: ${project.startDate.day}.${project.startDate.month}.${project.startDate.year}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Bitiş Tarihi: ${project.endDate.day}.${project.endDate.month}.${project.endDate.year}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            project.delayDuration != null
                ? Text(
              'Gecikme Süresi: ${project.delayDuration!.inHours} saat',
              style: TextStyle(fontSize: 16),
            )
                : Container(),
            SizedBox(height: 16),
            Text(
              'Çalışanlar:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8,
              children: project.workers.map((worker) => Chip(label: Text(worker))).toList(),
            ),
          ],
        ),
      ),
    );
  }
}