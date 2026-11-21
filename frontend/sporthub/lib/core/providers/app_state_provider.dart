import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/location_service.dart';

typedef StringList = List<String>;
typedef DataMap = Map<String, dynamic>;
typedef DataMapList = List<DataMap>;

// ---------------------------------------------------------------------------
// 1. State Lokasi GPS Pengguna
// ---------------------------------------------------------------------------
class LocationNotifier extends StateNotifier<UserLocationData> {
  LocationNotifier()
      : super(UserLocationData(
          latitude: -7.2891,
          longitude: 112.7344,
          cityName: 'Mendeteksi lokasi...',
          isGpsActive: false,
        )) {
    refreshLocation();
  }

  Future<void> refreshLocation() async {
    final loc = await LocationService.getCurrentLocation();
    state = loc;
  }
}

final locationProvider =
    StateNotifierProvider<LocationNotifier, UserLocationData>((ref) {
  return LocationNotifier();
});

// ---------------------------------------------------------------------------
// 2. State Profil & Preferensi Pengguna
// ---------------------------------------------------------------------------
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

// ---------------------------------------------------------------------------
// 3. State Daftar Venue (Otomatis Terurut dari Jarak Terdekat GPS)
// ---------------------------------------------------------------------------
final rawVenuesProvider = Provider<DataMapList>((ref) {
  return [
    {
      'id': 'ven-1',
      'name': 'Arena Sport Center',
      'sport': 'Futsal',
      'city': 'Surabaya',
      'address': 'Jl. Raya Darmo No. 12, Surabaya',
      'hours': '07:00 - 23:00 WIB',
      'price': 120000,
      'rating': '4.8',
      'lat': -7.2891,
      'lng': 112.7344,
      'courtName': 'Lapangan A · Vinyl Standar FIFA',
      'bookedSlots': ['19:00'],
      'equipments': [
        {'id': 'eq-1', 'name': 'Bola Futsal Match', 'price': 25000, 'stock': 4, 'qty': 0},
        {'id': 'eq-2', 'name': 'Rompi Tim (1 Set)', 'price': 20000, 'stock': 3, 'qty': 0},
      ],
    },
    {
      'id': 'ven-2',
      'name': 'GOR Bintang Timur',
      'sport': 'Badminton',
      'city': 'Surabaya',
      'address': 'Jl. Gubeng Kertajaya No. 45, Surabaya',
      'hours': '08:00 - 22:00 WIB',
      'price': 65000,
      'rating': '4.7',
      'lat': -7.2756,
      'lng': 112.7568,
      'courtName': 'Court 1 · Karpet Yonex BWF',
      'bookedSlots': ['18:00', '20:00'],
      'equipments': [
        {'id': 'eq-3', 'name': 'Raket Carbon Pro', 'price': 30000, 'stock': 5, 'qty': 0},
        {'id': 'eq-4', 'name': 'Shuttlecock (1 Tabung)', 'price': 85000, 'stock': 6, 'qty': 0},
      ],
    },
    {
      'id': 'ven-3',
      'name': 'Darmo Mini Soccer Park',
      'sport': 'Mini Soccer',
      'city': 'Surabaya',
      'address': 'Jl. Mayjen Sungkono No. 88, Surabaya',
      'hours': '06:00 - 24:00 WIB',
      'price': 450000,
      'rating': '4.9',
      'lat': -7.2912,
      'lng': 112.7125,
      'courtName': 'Field 1 · Rumput Sintetis FIFA',
      'bookedSlots': ['21:00'],
      'equipments': [
        {'id': 'eq-5', 'name': 'Bola Size 5 Pro', 'price': 35000, 'stock': 3, 'qty': 0},
        {'id': 'eq-6', 'name': 'Rompi Tim (2 Set)', 'price': 35000, 'stock': 4, 'qty': 0},
      ],
    },
    {
      'id': 'ven-4',
      'name': 'Delta Futsal Sidoarjo',
      'sport': 'Futsal',
      'city': 'Sidoarjo',
      'address': 'Jl. Pahlawan No. 10, Sidoarjo',
      'hours': '08:00 - 23:00 WIB',
      'price': 100000,
      'rating': '4.6',
      'lat': -7.4465,
      'lng': 112.7178,
      'courtName': 'Lapangan Interlock 1',
      'bookedSlots': [],
      'equipments': [
        {'id': 'eq-7', 'name': 'Bola Futsal', 'price': 20000, 'stock': 5, 'qty': 0},
      ],
    },
  ];
});

final nearbyVenuesProvider = Provider<DataMapList>((ref) {
  final userLoc = ref.watch(locationProvider);
  final venues = ref.watch(rawVenuesProvider);

  final withDistance = venues.map((v) {
    final dist = LocationService.calculateDistanceKm(
      userLoc.latitude,
      userLoc.longitude,
      v['lat'] as double,
      v['lng'] as double,
    );
    return {
      ...v,
      'distanceKm': dist,
    };
  }).toList();

  withDistance.sort(
    (a, b) => (a['distanceKm'] as double).compareTo(b['distanceKm'] as double),
  );
  return withDistance;
});

// ---------------------------------------------------------------------------
// 4. State Komunitas Radar (Otomatis Filter Radius 3 KM dari GPS Pengguna)
// ---------------------------------------------------------------------------
class CommunityNotifier extends StateNotifier<DataMapList> {
  CommunityNotifier()
      : super([
          {
            'name': 'Futsal Malam SBY',
            'sport': 'Futsal',
            'schedule': 'Tiap Selasa & Jumat, 20:00 WIB',
            'members': 28,
            'lat': -7.2850,
            'lng': 112.7380,
          },
          {
            'name': 'Tepok Bulu Gubeng',
            'sport': 'Badminton',
            'schedule': 'Tiap Rabu, 19:00 WIB',
            'members': 19,
            'lat': -7.2780,
            'lng': 112.7480,
          },
        ]);

  void addCommunity(DataMap newCommunity) {
    state = [newCommunity, ...state];
  }
}

final communityListProvider =
    StateNotifierProvider<CommunityNotifier, DataMapList>((ref) {
  return CommunityNotifier();
});

final nearbyCommunitiesProvider = Provider<DataMapList>((ref) {
  final userLoc = ref.watch(locationProvider);
  final all = ref.watch(communityListProvider);

  return all
      .map((c) {
        final dist = LocationService.calculateDistanceKm(
          userLoc.latitude,
          userLoc.longitude,
          c['lat'] as double,
          c['lng'] as double,
        );
        return {...c, 'distanceKm': dist};
      })
      .where((c) => (c['distanceKm'] as double) <= 3.0)
      .toList();
});

// ---------------------------------------------------------------------------
// 5. State Daftar Booking / E-Tiket
// ---------------------------------------------------------------------------
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

// ---------------------------------------------------------------------------
// 6. State Papan Tantangan
// ---------------------------------------------------------------------------
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