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
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.imageUrls[_currentIndex],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              left: 10,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_left,
                  size: 40,
                  color: AppPallete.primaryNormal,
                ),
                onPressed: _goLeft,
              ),
            ),
            Positioned(
              right: 10,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_right,
                  size: 40,
                  color: AppPallete.primaryDark,
                ),
                onPressed: _goRight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          "Image ${_currentIndex + 1} dari ${widget.imageUrls.length}",
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }
}
