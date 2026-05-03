import 'package:bugamed/ui/patient/models/schedule_ui.dart';

final sampleSchedules = <ScheduleUI>[
  ScheduleUI(
    doctorName: 'Dr. Chris Frazier',
    specialization: 'Pediatrician',
    status: 'Confirmed',
    dateTime: DateTime.now().add(const Duration(hours: 3)),
    avatarUrl:
        'https://cdn3d.iconscout.com/3d/premium/thumb/doctor-3d-illustration-download-in-png-blend-fbx-gltf-file-formats--avatar-pack-profession-icons-4329264.png',
    badgeColor: 0xFFffcdcf,
  ),
  ScheduleUI(
    doctorName: 'Dr. Viola Dunn',
    specialization: 'Therapist',
    status: 'Pending',
    dateTime: DateTime.now().add(const Duration(days: 1, hours: 2)),
    avatarUrl:
        'https://static.vecteezy.com/system/resources/previews/028/029/048/non_2x/female-doctor-3d-profession-avatars-illustrations-free-png.png',
    badgeColor: 0xFFf9d8b9,
  ),
  ScheduleUI(
    doctorName: 'Dr. Liuka Leehane',
    specialization: 'Orthopedics',
    status: 'Confirmed',
    dateTime: DateTime.now().add(const Duration(days: 2, hours: -4)),
    avatarUrl:
        'https://cdni.iconscout.com/illustration/premium/thumb/female-doctor-illustration-download-in-svg-png-gif-file-formats--woman-lady-people-avatar-pack-illustrations-4926803.png',
    badgeColor: 0xFFccd1fa,
  ),
];
