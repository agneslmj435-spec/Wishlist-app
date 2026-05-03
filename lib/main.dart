import 'package:flutter/material.dart';

void main() {
  runApp(const TabunganApp());
}

class TabunganApp extends StatelessWidget {
  const TabunganApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wishlist Tabungan',
      theme: ThemeData(
        primaryColor: const Color(0xFF5C59D4),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5C59D4)),
        scaffoldBackgroundColor: const Color(0xFFFBFBFD),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background Biru yang sedikit lebih gelap dari biru soft
      backgroundColor: const Color(0xFF4A90E2),
      body: Stack(
        children: [
          // Opsional: Dekorasi tambahan untuk background agar tidak flat
          Positioned(
            top: -50,
            right: -50,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.white.withOpacity(0.1),
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                // Lebar maksimal agar tidak terlalu memenuhi layar lebar
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  // Biru Soft sesuai permintaanmu
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // LOGO (Menggunakan aset atau ikon)
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        // Ganti Icon dengan Image.asset('assets/logo.png') jika sudah ada
                        child: const Icon(
                          Icons.rocket_launch_rounded,
                          size: 60,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Judul
                      const Text(
                        "Wujudkan Impianmu\nLebih Dekat!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E),
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Deskripsi
                      const Text(
                        "Kelola tabunganmu dengan mudah, dan raih Wishlist yang kamu impikan.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 35),

                      // Tombol Utama (Gradasi)
                      GestureDetector(
                        onTap: () {
                          // Navigasi ke halaman Home
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const MainNavigation(), // Ganti HomeScreen dengan nama class halaman home kamu
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: const LinearGradient(
                              colors: [Color(0xff6da1cb), Color(0xFF1A237E)],
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "Mulai Menabung",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Badge Keamanan
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.shield_rounded,
                              size: 16, color: Colors.blueGrey),
                          SizedBox(width: 8),
                          Text(
                            "Aman & Terpercaya",
                            style:
                                TextStyle(color: Colors.blueGrey, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- NAVIGASI UTAMA ---
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  List<Map<String, dynamic>> userWishlists = [];
  List<Map<String, dynamic>> categories = [
    {"icon": Icons.grid_view_rounded, "label": "Semua", "isSelected": true},
  ];

  @override
  Widget build(BuildContext context) {
    final completedWishlists = userWishlists.where((item) {
      int target = int.tryParse(item['target'].toString()) ?? 0;
      int current = item['currentAmount'] ?? 0;
      return current >= target && target > 0;
    }).toList();

    final ongoingWishlists = userWishlists.where((item) {
      int target = int.tryParse(item['target'].toString()) ?? 0;
      int current = item['currentAmount'] ?? 0;
      return current < target;
    }).toList();

    final List<Widget> _screens = [
      HomeScreen(
        userWishlists: ongoingWishlists,
        categories: categories,
        onUpdate: (updatedOngoingList) {
          setState(() {
            userWishlists = [...updatedOngoingList, ...completedWishlists];
          });
        },
        onCategoryUpdate: (newCats) => setState(() => categories = newCats),
        onProfileClick: () => setState(() => _currentIndex = 2),
      ),
      CompletedScreen(
        completedList: completedWishlists,
        onDeleteCompleted: (itemToDelete) {
          setState(() {
            userWishlists.removeWhere((item) => item == itemToDelete);
          });
        },
        onBack: () => setState(() => _currentIndex = 0),
      ),
      ProfileScreen(userWishlists: userWishlists),
    ];
    return Scaffold(
      // Background utama Biru Soft agar konsisten
      backgroundColor: const Color(0xFFE3F2FD),
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(0.05), // Shadow halus warna hitam transparan
              blurRadius: 15,
              offset: const Offset(0, -2), // Shadow mengarah ke atas
            )
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          elevation:
              0, // Matikan elevation asli karena sudah diganti BoxShadow di Container
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF4A90E2), // Biru Langit aktif
          unselectedItemColor:
              const Color(0xFFA5C9ED), // Biru Soft pudar non-aktif
          selectedFontSize: 12,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          onTap: (index) => setState(() => _currentIndex = index),
          // HAPUS 'const' di sini agar ikon dinamis bisa jalan
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_filled),
              label: "Beranda",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.star_outline_rounded), // Perbaikan nama ikon
              activeIcon: Icon(Icons.stars_rounded),
              label: "Selesai",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: "Profil",
            ),
          ],
        ),
      ),
    );
  }
}

// --- HALAMAN SELESAI ---
class CompletedScreen extends StatelessWidget {
  final List<Map<String, dynamic>> completedList;
  final Function(Map<String, dynamic>) onDeleteCompleted;
  final VoidCallback onBack;

  const CompletedScreen({
    super.key,
    required this.completedList,
    required this.onDeleteCompleted,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan warna Biru Soft sebagai latar belakang
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text(
          "Pencapaian",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A237E), // Biru Gelap
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1A237E)),
          onPressed: onBack,
        ),
      ),
      body: completedList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon Trophy dengan warna biru muda
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.emoji_events_rounded,
                      size: 100,
                      color: Colors.blue.shade200,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Belum ada tabungan selesai",
                    style: TextStyle(
                      color: Colors.blueGrey.shade400,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: completedList.length,
              itemBuilder: (context, index) {
                final item = completedList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Ikon Badge Biru Langit
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1F5FE), // Light Sky Blue
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.stars_rounded,
                          color: Color(0xFF0288D1), // Sky Blue Darker
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Color(0xFF263238),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.verified_rounded,
                                    size: 14, color: Colors.green),
                                const SizedBox(width: 4),
                                Text(
                                  "Lunas: Rp ${item['target']}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Tombol Hapus yang lebih halus
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded,
                            color: Colors.redAccent),
                        onPressed: () => onDeleteCompleted(item),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

// --- HOME SCREEN ---
class HomeScreen extends StatefulWidget {
  final List<Map<String, dynamic>> userWishlists;
  final List<Map<String, dynamic>> categories;
  final Function(List<Map<String, dynamic>>) onUpdate;
  final Function(List<Map<String, dynamic>>) onCategoryUpdate;
  final VoidCallback onProfileClick;

  const HomeScreen({
    super.key,
    required this.userWishlists,
    required this.categories,
    required this.onUpdate,
    required this.onCategoryUpdate,
    required this.onProfileClick,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = "Semua";

  // Fungsi 1: Menghapus data dari list
  void _hapusWishlist(Map<String, dynamic> itemDihapus) {
    setState(() {
      // Menghapus item dari daftar utama
      widget.userWishlists.removeWhere((item) => item == itemDihapus);

      // Melaporkan perubahan data ke main agar tersimpan
      widget.onUpdate(List.from(widget.userWishlists));
    });

    // Menampilkan pesan konfirmasi di bawah layar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${itemDihapus['name']} berhasil dihapus"),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Fungsi 2: Menampilkan jendela konfirmasi (Dialog)
  void _tampilkanDialogHapus(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Hapus Wishlist"),
        content: Text("Yakin ingin menghapus '${item['name']}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              _hapusWishlist(item);
              Navigator.pop(context);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // --- Hapus Kategori ---
  void _hapusKategori(Map<String, dynamic> kategori) {
    if (kategori['name'] == "Semua")
      return; // Keamanan agar "Semua" tidak hilang

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Hapus Kategori"),
        content: Text("Hapus kategori '${kategori['name']}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                widget.categories.removeWhere((item) => item == kategori);
                widget.onCategoryUpdate(List.from(widget.categories));
                if (selectedCategory == kategori['name']) {
                  selectedCategory = "Semua";
                }
              });
              Navigator.pop(context);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredWishlists = selectedCategory == "Semua"
        ? widget.userWishlists
        : widget.userWishlists
            .where((item) => item['category'] == selectedCategory)
            .toList();
    int totalSemuaTabungan = widget.userWishlists
        .fold(0, (sum, item) => sum + (item['currentAmount'] as int));

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          // --- KOTAK PUTIH UNTUK HEADER (WISHLIST & PROFIL) ---
          Container(
            padding: const EdgeInsets.all(15), // Jarak dalam kotak
            decoration: BoxDecoration(
              color: Colors.white, // Warna kotak putih
              borderRadius: BorderRadius.circular(20), // Sudut melengkung
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Wishlist",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5)),
                    Text("Wujudkan mimpimu, Agnes!",
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
                GestureDetector(
                  onTap: () => widget.onProfileClick(),
                  child: const CircleAvatar(
                    radius: 22,
                    backgroundColor: Color(0xFF5C59D4),
                    child: Text(
                      "AA",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          _buildBalanceCard(totalSemuaTabungan),
          const SizedBox(height: 30),
          // Bagian "Lihat Semua" dihapus dengan parameter showAction: false
          _sectionHeader("Kategori", () {}, showAction: false),
          _buildCategoryRow(),
          const SizedBox(height: 30),
          _sectionHeader("Daftar Impian", () => _keHalamanTambahWishlist(),
              actionLabel: "+ Tambah"),
          filteredWishlists.isEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(40),
                  child: Center(
                    child: Text(
                      selectedCategory == "Semua"
                          ? "Mulai menabung sekarang!"
                          : "Belum ada wishlist di kategori $selectedCategory",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredWishlists.length,
                  itemBuilder: (context, index) =>
                      _buildWishlistItem(index, filteredWishlists[index]),
                ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _keHalamanTambahWishlist() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddWishlistScreen(
                availableCategories: widget.categories
                    .map((c) => c['label'].toString())
                    .toList())));
    if (result != null) {
      List<Map<String, dynamic>> newList = List.from(widget.userWishlists);
      newList.add(result);
      widget.onUpdate(newList);
      if (result['isNew'] == true) {
        List<Map<String, dynamic>> newCats = List.from(widget.categories);
        newCats.add({
          "icon": Icons.label_important_outline_rounded,
          "label": result['category'],
          "isSelected": false
        });
        widget.onCategoryUpdate(newCats);
      }
    }
  }

  // Fungsi pembantu untuk header bagian
  Widget _sectionHeader(String title, VoidCallback onTap,
      {String actionLabel = "Lihat Semua", bool showAction = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        if (showAction)
          TextButton(
              onPressed: onTap,
              child: Text(actionLabel,
                  style: const TextStyle(
                      color: Color(0xFF5C59D4), fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget _buildBalanceCard(int total) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        // MENGGUNAKAN GRADASI BIRU LANGIT
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A90E2), // Biru Langit (Sky Blue)
            Color(0xFF87CEFA), // Biru Muda Cerah
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A90E2).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Total Saldo Aktif",
                style: TextStyle(
                  color: Colors.white70, // Gunakan putih transparan (white70)
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Rp $total",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          children: widget.categories.map((cat) {
        // Ini sudah benar
        bool isSelected = selectedCategory == cat["label"];

        return Padding(
          padding: const EdgeInsets.only(right: 15),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = cat["label"];
              });
            },
            // --- Hapus Label ---
            onLongPress: () {
              _hapusKategori(cat); // Memanggil fungsi dialog hapus kategori
            },
            child: Column(children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  // GANTI: Gunakan isSelected, bukan cat["isSelected"]
                  color: isSelected ? const Color(0xFF5C59D4) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : Colors.grey.shade200),
                ),
                child: Icon(cat["icon"],
                    // GANTI: Gunakan isSelected
                    color: isSelected ? Colors.white : const Color(0xFF5C59D4)),
              ),
              const SizedBox(height: 8),
              Text(cat["label"],
                  style: TextStyle(
                      fontSize: 12,
                      // GANTI: Gunakan isSelected
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      // Tambahkan warna teks agar lebih cantik saat aktif
                      color:
                          isSelected ? const Color(0xFF5C59D4) : Colors.black)),
            ]),
          ),
        );
      }).toList()),
    );
  }

  Widget _buildWishlistItem(int index, Map<String, dynamic> data) {
    int target = int.tryParse(data['target'].toString()) ?? 1;
    int current = data['currentAmount'] ?? 0;
    double progress = current / target;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailWishlistScreen(
              wishlistData: data,
              onUpdate: (newAmount) {
                // 1. Buat copy dari list utama
                List<Map<String, dynamic>> newList =
                    List.from(widget.userWishlists);

                // 2. Cari index asli data ini di dalam list utama (bukan index tampilan)
                // Ini mencegah data tertukar saat kategori difilter
                int originalIndex =
                    newList.indexWhere((item) => item['name'] == data['name']);

                if (originalIndex != -1) {
                  // 3. Update hanya pada item yang benar
                  newList[originalIndex]['currentAmount'] = newAmount;

                  // 4. Kirim list yang sudah diperbarui ke fungsi utama
                  widget.onUpdate(newList);
                }
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
                color: const Color(0xFFF0EFFF),
                borderRadius: BorderRadius.circular(15)),
            child: const Icon(Icons.rocket_launch_rounded,
                color: Color(0xFF5C59D4)),
          ),
          const SizedBox(width: 15),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(data['name'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text("${(progress * 100).toStringAsFixed(0)}% Terkumpul",
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                      value: progress > 1.0 ? 1.0 : progress,
                      color: const Color(0xFF5C59D4),
                      backgroundColor: const Color(0xFFF0EFFF),
                      minHeight: 8),
                ),
              ])),

          // --- TOMBOL HAPUS BARU ---
          IconButton(
            icon: const Icon(Icons.delete_outline,
                color: Colors.redAccent, size: 22),
            onPressed: () {
              // Memanggil dialog konfirmasi menggunakan data item saat ini
              _tampilkanDialogHapus(data);
            },
          ),

          const Icon(Icons.arrow_forward_ios_rounded,
              size: 14, color: Colors.grey),
        ]),
      ),
    );
  }
}

// --- DETAIL WISHLIST ---
class DetailWishlistScreen extends StatefulWidget {
  final Map<String, dynamic> wishlistData;
  final Function(int) onUpdate;
  const DetailWishlistScreen(
      {super.key, required this.wishlistData, required this.onUpdate});

  @override
  State<DetailWishlistScreen> createState() => _DetailWishlistScreenState();
}

class _DetailWishlistScreenState extends State<DetailWishlistScreen> {
  late int jumlahTabungan;
  final TextEditingController _nabungController = TextEditingController();

  @override
  void initState() {
    super.initState();
    jumlahTabungan = widget.wishlistData['currentAmount'] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    int target = int.tryParse(widget.wishlistData['target'].toString()) ?? 0;
    double progress = target > 0 ? (jumlahTabungan / target) : 0.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Container(
              height: 150,
              width: 150,
              decoration: const BoxDecoration(
                  color: Color(0xFFF0EFFF), shape: BoxShape.circle),
              child: const Icon(Icons.stars_rounded,
                  size: 80, color: Color(0xFF5C59D4)),
            ),
            const SizedBox(height: 20),
            Text(widget.wishlistData['name'],
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(widget.wishlistData['category'],
                style: const TextStyle(
                    color: Color(0xFF5C59D4), fontWeight: FontWeight.w600)),
            const SizedBox(height: 40),
            _buildInfoCard(
                "Total Target", "Rp ${widget.wishlistData['target']}"),
            const SizedBox(height: 15),
            _buildInfoCard("Terkumpul", "Rp $jumlahTabungan", isPrimary: true),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Progres Tabungan",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("${(progress * 100).toStringAsFixed(0)}%",
                    style: const TextStyle(
                        color: Color(0xFF5C59D4), fontWeight: FontWeight.bold))
              ],
            ),
            const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                  value: progress > 1.0 ? 1.0 : progress,
                  minHeight: 15,
                  color: const Color(0xFF5C59D4),
                  backgroundColor: const Color(0xFFF0EFFF)),
            ),
            const SizedBox(height: 50),
            if (progress < 1.0)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5C59D4),
                      padding: const EdgeInsets.all(18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  onPressed: _showNabungDialog,
                  child: const Text("Isi Tabungan Sekarang",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
              )
            else
              const Text("🎉 Impian tercapai!",
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
          ],
        ),
      ),
    );
  }

  void _showNabungDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nabung Berapa?"),
        content: TextField(
          controller: _nabungController,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(prefixText: "Rp ", hintText: "0"),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal")),
          ElevatedButton(
              onPressed: () {
                if (_nabungController.text.isNotEmpty) {
                  setState(() {
                    jumlahTabungan += int.parse(_nabungController.text);
                    _nabungController.clear();
                  });
                  widget.onUpdate(jumlahTabungan);
                  Navigator.pop(context);
                }
              },
              child: const Text("Simpan")),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, {bool isPrimary = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isPrimary ? const Color(0xFFF0EFFF) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
            color: isPrimary ? const Color(0xFF5C59D4) : Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isPrimary ? const Color(0xFF5C59D4) : Colors.black)),
        ],
      ),
    );
  }
}

// --- TAMBAH WISHLIST ---
class AddWishlistScreen extends StatefulWidget {
  final List<String> availableCategories;
  const AddWishlistScreen({super.key, required this.availableCategories});

  @override
  State<AddWishlistScreen> createState() => _AddWishlistScreenState();
}

class _AddWishlistScreenState extends State<AddWishlistScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _newCatController = TextEditingController();
  String? selectedCat;
  bool showCustomInput = false;

  @override
  void initState() {
    super.initState();
    selectedCat = widget.availableCategories[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Mengubah background utama menjadi Biru Soft
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text(
          "Buat Impian Baru",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A237E), // Biru gelap agar profesional
          ),
        ),
        centerTitle: true,
        // AppBar dibuat transparan agar warna biru soft-nya menyatu ke atas
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1A237E)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                  labelText: "Apa impianmu?",
                  filled: true,
                  fillColor: Colors.white, // Kotak input tetap putih
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: "Berapa harganya? (Rp)",
                  filled: true,
                  fillColor: Colors.white, // Kotak input tetap putih
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: showCustomInput ? "+ Tambah Kategori" : selectedCat,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
              items: [...widget.availableCategories, "+ Tambah Kategori"]
                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
              onChanged: (v) => setState(() {
                showCustomInput = (v == "+ Tambah Kategori");
                selectedCat = v;
              }),
            ),
            if (showCustomInput)
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: TextField(
                  controller: _newCatController,
                  decoration: InputDecoration(
                      labelText: "Nama Kategori Baru",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                ),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  if (_nameController.text.isEmpty ||
                      _priceController.text.isEmpty) return;
                  Navigator.pop(context, {
                    'name': _nameController.text,
                    'target': _priceController.text,
                    'category':
                        showCustomInput ? _newCatController.text : selectedCat!,
                    'isNew': showCustomInput,
                    'currentAmount': 0
                  });
                },
                child: const Text("Simpan Sekarang",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

// --- PROFIL SCREEN ---
class ProfileScreen extends StatefulWidget {
  final List<Map<String, dynamic>> userWishlists;
  const ProfileScreen({super.key, required this.userWishlists});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _tampilkanDialogLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Keluar"),
        content: const Text("Apakah kamu yakin ingin keluar dari aplikasi?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                (route) => false,
              );
            },
            child: const Text("Keluar",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ongoingList = widget.userWishlists.where((item) {
      int target = int.tryParse(item['target'].toString()) ?? 1;
      int current = item['currentAmount'] ?? 0;
      return current < target;
    }).toList();

    int totalWishlistAktif = ongoingList.length;
    int totalTabunganSemua = widget.userWishlists
        .fold(0, (sum, item) => sum + (item['currentAmount'] as int));

    double progressAvg = 0;
    if (ongoingList.isNotEmpty) {
      progressAvg = (ongoingList.fold(
                  0.0,
                  (sum, item) =>
                      sum +
                      ((item['currentAmount'] as int) /
                          (int.tryParse(item['target'].toString()) ?? 1))) /
              ongoingList.length) *
          100;
    }

    return Scaffold(
      // Menggunakan Biru Soft agar selaras dengan Home
      backgroundColor: const Color(0xFFE3F2FD),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER DENGAN GRADASI BIRU LANGIT
            Container(
              padding: const EdgeInsets.fromLTRB(25, 60, 25, 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF87CEFA), Color(0xFF4A90E2)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 52,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor:
                          Color(0xFF5C59D4), // Sesuai warna logo profil
                      child: Text(
                        "AA",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Agnes Angelita",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Ganti bagian ini:
                  const Text(
                    "BIDADARI",
                    style: TextStyle(
                        color:
                            Colors.white70), // <--- Pastikan tertulis white70
                  ),
                  const SizedBox(height: 30),
                  // STATS CARD BOX
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat(totalWishlistAktif.toString(), "Aktif"),
                        _buildStat("Rp $totalTabunganSemua", "Saldo"),
                        _buildStat(
                            "${progressAvg.toStringAsFixed(0)}%", "Rata-rata"),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // MENU OPTIONS DALAM CARD PUTIH
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    _buildOption(Icons.security_rounded, "Keamanan Data"),
                    const Divider(height: 1, indent: 70),
                    _buildOption(Icons.help_center_rounded, "Pusat Bantuan"),
                    const Divider(height: 1, indent: 70),
                    _buildOption(
                      Icons.logout_rounded,
                      "Keluar",
                      isDanger: true,
                      onTap: () => _tampilkanDialogLogout(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String val, String label) {
    return Column(
      children: [
        Text(
          val,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildOption(IconData icon, String title,
      {VoidCallback? onTap, bool isDanger = false}) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color:
              isDanger ? Colors.red.withOpacity(0.1) : const Color(0xFFE3F2FD),
          shape: BoxShape.circle,
        ),
        child: Icon(icon,
            color: isDanger ? Colors.red : const Color(0xFF4A90E2), size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDanger ? Colors.red : Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded,
          size: 14, color: Colors.grey),
    );
  }
}
