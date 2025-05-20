import 'package:bloomy/views/explore/explore_view.dart';
import 'package:bloomy/views/float_play/float_play_view.dart';
import 'package:bloomy/views/home/home_view.dart';
import 'package:bloomy/views/library/library_view.dart';
import 'package:flutter/material.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  // Biến để theo dõi chỉ số tab hiện tại
  int _currentIndex = 0;

  // Danh sách các trang
  final List<Widget> _pages = [
    HomeView(),
    ExploreView(),
    LibraryView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Cho phép body mở rộng đến dưới BottomNavigationBar
      backgroundColor: Colors.black, // Màu nền tối để phù hợp với gradient
      body: Stack(
        children: [
          _pages[_currentIndex],
          // FloatPlayView(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70, // Chiều cao tùy chỉnh cho BottomNavigationBar
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent, // Phần trên trong suốt để lộ hình ảnh
              Colors.black,
              Colors.black // Chuyển sang xanh dương
            ],
            stops: [0.0, 0.5, 1.0], // Điều chỉnh điểm dừng để gradient mượt mà
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: Color(0xFF00C2CB),
          unselectedItemColor: Colors.white,
          backgroundColor: Colors.transparent,
          // Đảm bảo trong suốt
          type: BottomNavigationBarType.fixed,
          // Giữ kiểu cố định
          showUnselectedLabels: true,
          elevation: 0,
          // Loại bỏ bóng mặc định của BottomNavigationBar
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_copy_outlined),
              label: 'Library',
            ),
          ],
        ),
      ),
    );
  }
}
