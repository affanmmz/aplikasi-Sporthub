import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef StringList = List<String>;
typedef DataMap = Map<String, dynamic>;
typedef DataMapList = List<DataMap>;

class UserProfileState {
  final String name;
  final StringList favoriteSports;
  final String level;

  UserProfileState({
    required this.name,
    required this.favoriteSports,
    required this.level,
  });

  UserProfileState copyWith({
    String? name,
    StringList? favoriteSports,
    String? level,
  }) {
    return UserProfileState(
      name: name ?? this.name,
      favoriteSports: favoriteSports ?? this.favoriteSports,
      level: level ?? this.level,
    );
  }
}

class UserProfileNotifier extends StateNotifier<UserProfileState> {
  UserProfileNotifier()
      : super(UserProfileState(
          name: 'Raka Pratama',
          favoriteSports: ['Futsal', 'Badminton'],
          level: 'Menengah',
        ));

  void updatePreferences(StringList sports, String level) {
    state = state.copyWith(favoriteSports: sports, level: level);
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfileState>((ref) {
  return UserProfileNotifier();
});

class BookingNotifier extends StateNotifier<DataMapList> {
  BookingNotifier()
      : super([
          {
            'bookingCode': 'SH-20261120-8842',
            'venueName': 'ARENA SPORT CENTER',
            'courtName': 'Lapangan A · Vinyl Standar FIFA',
            'dateText': 'Jumat, 20 Nov 2026',
            'timeSlot': '20:00 WIB (1 Jam)',
            'rentedEquipments': ['1x Bola Futsal Match'],
            'totalPaid': 145000,
          },
        ]);

  void addBooking(DataMap newBooking) {
    state = [newBooking, ...state];
  }
}

final bookingListProvider =
    StateNotifierProvider<BookingNotifier, DataMapList>((ref) {
  return BookingNotifier();
});

class ChallengeNotifier extends StateNotifier<DataMapList> {
  ChallengeNotifier()
      : super([
          {
            'isOpponent': true,
            'schedule': 'KAMIS, 20 NOV · 20:00 WIB',
            'title': 'Garuda Futsal FC',
            'sport': 'Futsal',
            'venue': 'Arena Sport Center (1.5 km)',
            'level': 'Menengah',
            'note': 'Main santai tapi serius, patungan lapangan di lokasi',
          },
          {
            'isOpponent': false,
            'schedule': 'JUMAT, 21 NOV · 19:00 WIB',
            'title': 'Butuh 2 Pemain Badminton Ganda',
            'sport': 'Badminton',
            'venue': 'GOR Bintang Timur (2.0 km)',
            'level': 'Pemula',
            'note': 'Shuttlecock patungan, yang penting keringetan bareng',
          },
        ]);

  void addChallenge(DataMap item) {
    state = [item, ...state];
  }
}

final challengeListProvider =
    StateNotifierProvider<ChallengeNotifier, DataMapList>((ref) {
  return ChallengeNotifier();
});