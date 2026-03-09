import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_pallete.dart';

class ImageArrowSelector extends StatefulWidget {
  final List<String> imageUrls;
  final void Function(String selectedUrl) onChanged;

  const ImageArrowSelector({
    super.key,
    required this.imageUrls,
    required this.onChanged,
  });

  @override
  State<ImageArrowSelector> createState() => _ImageArrowSelectorState();
}

class _ImageArrowSelectorState extends State<ImageArrowSelector> {
  int _currentIndex = 0;

  void _goLeft() {
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + widget.imageUrls.length) %
          widget.imageUrls.length;
      widget.onChanged(widget.imageUrls[_currentIndex]);
    });
  }

  void _goRight() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.imageUrls.length;
      widget.onChanged(widget.imageUrls[_currentIndex]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 112,
          width: double.infinity, // Stack selebar layar
          child: Stack(
            alignment: Alignment.center,
            children: [
              // gambar di tengah
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 112,
                  width: 144,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.imageUrls[_currentIndex],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // tombol kiri di pojok dengan margin 32
              Positioned(
                left: 24,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_left,
                    size: 48, // ukuran icon 20px
                    color: AppPallete
                        .primaryNormal, // atau AppPallete.primaryNormal
                  ),
                  onPressed: _goLeft,
                ),
              ),
              // tombol kanan di pojok dengan margin 32
              Positioned(
                right: 24,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_right,
                    size: 48, // ukuran icon 20px
                    color:
                        AppPallete.primaryNormal, // atau AppPallete.primaryDark
                  ),
                  onPressed: _goRight,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
