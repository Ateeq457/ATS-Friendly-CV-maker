import 'package:flutter/material.dart';
import '../../data/models/cv_data_model.dart';
import '../templates/template_config.dart';

class CVRenderer extends StatelessWidget {
  final CVDataModel cvData;
  final TemplateConfig config;

  const CVRenderer({super.key, required this.cvData, required this.config});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 550, // Wider for better readability
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          if (cvData.personalInfo.summary.isNotEmpty) _buildSummary(),
          const SizedBox(height: 20),
          if (cvData.skills.isNotEmpty) _buildSkills(),
          const SizedBox(height: 20),
          if (cvData.experiences.isNotEmpty) _buildExperience(),
          const SizedBox(height: 20),
          if (cvData.projects.isNotEmpty) _buildProjects(),
          const SizedBox(height: 20),
          if (cvData.educations.isNotEmpty) _buildEducation(),
          const SizedBox(height: 20),
          if (cvData.certifications.isNotEmpty) _buildAchievements(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          cvData.personalInfo.fullName.toUpperCase(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          'Flutter Developer | Frontend Engineer',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          '${cvData.personalInfo.phone} | ${cvData.personalInfo.email} | linkedin.com/in/ateeq-ur-rehman-7b866235b',
          style: TextStyle(fontSize: 9, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        const Divider(thickness: 1),
      ],
    );
  }

  Widget _buildSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PROFESSIONAL SUMMARY',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          cvData.personalInfo.summary,
          style: const TextStyle(fontSize: 10, height: 1.4),
        ),
      ],
    );
  }

  Widget _buildSkills() {
    if (cvData.skills.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TECHNICAL SKILLS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: cvData.skills
              .map(
                (skill) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(skill, style: const TextStyle(fontSize: 9)),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  List<Widget> _buildSkillCategory(String category, List<String> skills) {
    return [
      RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 9),
          children: [
            TextSpan(
              text: '$category ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: skills.join(', ')),
          ],
        ),
      ),
    ];
  }

  Widget _buildExperience() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PROFESSIONAL EXPERIENCE',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        ...cvData.experiences.map(
          (exp) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exp.jobTitle,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${exp.companyName} — ${exp.isCurrent ? 'Onsite' : 'Remote'} *${_formatDate(exp.startDate)} -- ${exp.isCurrent ? 'Present' : _formatDate(exp.endDate)}*',
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  exp.description,
                  style: const TextStyle(fontSize: 9, height: 1.4),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProjects() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PROJECTS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        ...cvData.projects.map(
          (project) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.name,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  project.description,
                  style: const TextStyle(fontSize: 9, height: 1.4),
                ),
                if (project.technologies != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Tech: ${project.technologies}',
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEducation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EDUCATION',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        ...cvData.educations.map(
          (edu) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                edu.degree,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                edu.institution,
                style: TextStyle(fontSize: 9, color: Colors.grey[700]),
              ),
              if (edu.grade != null)
                Text(
                  edu.grade!,
                  style: TextStyle(fontSize: 9, color: Colors.grey[600]),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ACHIEVEMENTS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        ...cvData.certifications.map(
          (cert) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 10)),
                Expanded(
                  child: Text(
                    cert.name,
                    style: const TextStyle(fontSize: 9, height: 1.3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return _getMonthName(date.month);
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
