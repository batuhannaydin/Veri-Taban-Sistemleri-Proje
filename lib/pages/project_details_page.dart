import 'package:flutter/material.dart';
import 'Projects_model.dart'; // Assuming you have the models defined here
import 'user_profile_page.dart';

class ProjectDetailsPage extends StatefulWidget {
  final List<Project> projects;
  final User currentUser;
  final String? initialLanguage;
  final ThemeMode? initialThemeMode;

  const ProjectDetailsPage({
    Key? key,
    required this.projects,
    required this.currentUser,
    this.initialLanguage,
    this.initialThemeMode,
  }) : super(key: key);

  @override
  _ProjectDetailsPageState createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  int _selectedIndex = 0;
  bool _isSidebarOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          if (_isSidebarOpen)
            NavigationSidebar(
              selectedIndex: _selectedIndex,
              onItemSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                  _isSidebarOpen = false;
                });
              },
            ),
          Expanded(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      setState(() {
                        _isSidebarOpen = !_isSidebarOpen;
                      });
                    },
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.person),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfilePage(user: widget.currentUser),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Center(
                    child: Text(
                      _getPageTitle(),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: _buildContent(_selectedIndex),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPageTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Projeler';
      case 1:
        return 'Takvim';
      case 2:
        return 'Ayarlar';
      case 3:
        return 'Çalışanlar';  // Çalışanlar sekmesi
      default:
        return 'Projeler';
    }
  }

  Widget _buildContent(int index) {
    switch (index) {
      case 0:
        return _buildProjectList();
      case 1:
        return Center(child: Text('Takvim'));
      case 2:
        return Center(child: Text('Ayarlar'));
      case 3:
        return _buildEmployeeList();  // Çalışanlar içeriği
      default:
        return _buildProjectList();
    }
  }

  Widget _buildProjectList() {
    return ListView.builder(
      itemCount: widget.projects.length,
      itemBuilder: (context, index) {
        final project = widget.projects[index];
        return Card(
          margin: EdgeInsets.all(8),
          child: ExpansionTile(
            title: Text(
              project.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Durum: ${_getProjectStatusText(project.status)}',
              style: TextStyle(
                color: _getStatusColor(project.status),
              ),
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProjectDetailRow('Başlangıç Tarihi', _formatDate(project.startDate)),
                    _buildProjectDetailRow('Bitiş Tarihi', _formatDate(project.endDate)),
                    if (project.delayDuration != null)
                      _buildProjectDetailRow('Gecikme Süresi', '${project.delayDuration!.inHours} saat'),
                    SizedBox(height: 10),
                    Text(
                      'Çalışanlar: ',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Wrap(
                      spacing: 8,
                      children: project.workers.map((worker) =>
                          ActionChip(
                            label: Text(worker),
                            onPressed: () => _showWorkerProfile(worker),
                          )
                      ).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProjectDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  String _getProjectStatusText(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.notStarted:
        return 'Başlamadı';
      case ProjectStatus.inProgress:
        return 'Devam Ediyor';
      case ProjectStatus.completed:
        return 'Tamamlandı';
      case ProjectStatus.delayed:
        return 'Gecikmiş';
    }
  }

  Color _getStatusColor(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.notStarted:
        return Colors.grey;
      case ProjectStatus.inProgress:
        return Colors.blue;
      case ProjectStatus.completed:
        return Colors.green;
      case ProjectStatus.delayed:
        return Colors.red;
    }
  }

  void _showWorkerProfile(String workerName) {
    final mockUser = User(
      id: '1',
      username: workerName,
      email: '$workerName@example.com',
      currentProjects: widget.projects.where((p) => p.workers.contains(workerName)).toList(),
      completedProjects: [],
      totalDelayedProjects: widget.projects.where((p) =>
      p.workers.contains(workerName) && p.status == ProjectStatus.delayed
      ).length,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfilePage(user: mockUser),
      ),
    );
  }

  Widget _buildEmployeeList() {
    final allWorkers = widget.projects
        .expand((project) => project.workers)
        .toSet()
        .toList();

    return ListView.builder(
      itemCount: allWorkers.length,
      itemBuilder: (context, index) {
        final worker = allWorkers[index];
        return ListTile(
          title: Text(worker),
          onTap: () => _showWorkerProfile(worker),
        );
      },
    );
  }
}

class NavigationSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const NavigationSidebar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          ListTile(
            selected: selectedIndex == 0,
            leading: Icon(Icons.work, color: Colors.white),
            title: Text('Projeler', style: TextStyle(color: Colors.white)),
            onTap: () => onItemSelected(0),
          ),
          ListTile(
            selected: selectedIndex == 3,
            leading: Icon(Icons.people, color: Colors.white),
            title: Text('Çalışanlar', style: TextStyle(color: Colors.white)),
            onTap: () => onItemSelected(3),
          ),
          ListTile(
            selected: selectedIndex == 1,
            leading: Icon(Icons.calendar_today, color: Colors.white),
            title: Text('Takvim', style: TextStyle(color: Colors.white)),
            onTap: () => onItemSelected(1),
          ),
          ListTile(
            selected: selectedIndex == 2,
            leading: Icon(Icons.settings, color: Colors.white),
            title: Text('Ayarlar', style: TextStyle(color: Colors.white)),
            onTap: () => onItemSelected(2),
          ),
        ],
      ),
    );
  }
}
