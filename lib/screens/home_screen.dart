import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late VideoPlayerController _controller;

  final List<Map<String, dynamic>> featuredWatches = [
    {
      'id': '1',
      'name': 'Royal Oak Perpetual',
      'brand': 'Audemars Piguet',
      'price': '\$125,000',
      'image': 'assets/images/watch4.jpg',
    },
    {
      'id': '2',
      'name': 'Daytona Platinum',
      'brand': 'Rolex',
      'price': '\$75,000',
      'image': 'assets/images/watch5.jpg',
    },
    {
      'id': '3',
      'name': 'Tourbillon Extra',
      'brand': 'Patek Philippe',
      'price': '\$250,000',
      'image': 'assets/images/watch6.jpg',
    },
  ];

  final List<Map<String, dynamic>> newArrivals = [
    {
      'id': '4',
      'name': 'Nautilus 5711',
      'brand': 'Patek Philippe',
      'price': '\$95,000',
      'image': 'assets/images/watch4.jpg',
    },
    {
      'id': '5',
      'name': 'Master Ultra Thin',
      'brand': 'Jaeger-LeCoultre',
      'price': '\$22,000',
      'image': 'assets/images/watch5.jpg',
    },
    {
      'id': '6',
      'name': 'Big Bang Unico',
      'brand': 'Hublot',
      'price': '\$28,000',
      'image': 'assets/images/watch6.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/luxury_watch_video.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            pinned: true, // <-- keeps it fixed at the top
            floating: false, // <-- disables floating behavior
            title: Text(
              'ECLIPSE',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.secondary,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: WatchSearchDelegate(),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(child: _buildVideoBanner()),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            sliver: SliverToBoxAdapter(child: _buildSectionHeader('Featured Collections')),
          ),
          SliverToBoxAdapter(child: _buildFeaturedCollections()),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            sliver: SliverToBoxAdapter(child: _buildSectionHeader('New Arrivals')),
          ),
          SliverToBoxAdapter(child: _buildNewArrivals()),
          const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildVideoBanner() {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: _controller.value.isInitialized
          ? Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'View All',
              style: GoogleFonts.raleway(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCollections() {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: featuredWatches.length,
        itemBuilder: (context, index) {
          final watch = featuredWatches[index];
          return _buildWatchCard(watch);
        },
      ),
    );
  }

  Widget _buildNewArrivals() {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: newArrivals.length,
        itemBuilder: (context, index) {
          final watch = newArrivals[index];
          return _buildWatchCard(watch);
        },
      ),
    );
  }

  Widget _buildWatchCard(Map<String, dynamic> watch) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/product', arguments: watch);
      },
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                watch['image'],
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    watch['brand'],
                    style: GoogleFonts.raleway(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    watch['name'],
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    watch['price'],
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
          switch (index) {
            case 1:
              Navigator.pushNamed(context, '/products');
              break;
            case 2:
              Navigator.pushNamed(context, '/cart');
              break;
            case 3:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).colorScheme.secondary,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.shop_2), label: 'Products'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}

// Dummy delegate for search – replace with your actual logic
class WatchSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) => [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(icon: Icon(Icons.arrow_back), onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) => Center(child: Text('Results for "$query"'));

  @override
  Widget buildSuggestions(BuildContext context) => Center(child: Text('Suggestions for "$query"'));
}
