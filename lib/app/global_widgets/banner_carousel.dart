import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data/models/banner_model.dart';

class BannerCarousel extends StatefulWidget {
  final List<BannerModel> banners;
  final Function(String) onView;
  final Function(BannerModel) onTap;

  const BannerCarousel({
    super.key,
    required this.banners,
    required this.onView,
    required this.onTap,
  });

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _currentIndex = 0;
  final Set<String> _recordedViews = {};

  @override
  void initState() {
    super.initState();
    // Record view for the first banner
    if (widget.banners.isNotEmpty) {
      _recordView(widget.banners[0].id);
    }
  }

  void _recordView(String bannerId) {
    if (!_recordedViews.contains(bannerId)) {
      _recordedViews.add(bannerId);
      widget.onView(bannerId);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        FlutterCarousel(
          options: CarouselOptions(
            height: 180,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: false,
            showIndicator: false,
            slideIndicator: null,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
              // Record view when banner is displayed
              _recordView(widget.banners[index].id);
            },
          ),
          items: widget.banners.map((banner) {
            return GestureDetector(
              onTap: () => widget.onTap(banner),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Banner Image
                      CachedNetworkImage(
                        imageUrl: banner.image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: const Color(0xFF1A1A1A),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                const Color(0xFFD4AF37).withOpacity(0.5),
                              ),
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: const Color(0xFF1A1A1A),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_not_supported,
                                color: const Color(0xFF808080),
                                size: 40,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                banner.title,
                                style: const TextStyle(
                                  color: Color(0xFFE0E0E0),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Gradient Overlay for better text readability
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.5),
                            ],
                            stops: const [0.5, 1.0],
                          ),
                        ),
                      ),
                      // Optional: Display title at the bottom
                      if (banner.description != null &&
                          banner.description!.isNotEmpty)
                        Positioned(
                          bottom: 12,
                          left: 12,
                          right: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                banner.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black45,
                                      offset: Offset(0, 1),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                banner.description!,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black45,
                                      offset: Offset(0, 1),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      // Type Badge (optional)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getBadgeColor(banner.type),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _getBadgeLabel(banner.type),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        // Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.banners.asMap().entries.map((entry) {
            final isActive = _currentIndex == entry.key;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isActive ? 24 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: isActive
                    ? const Color(0xFFD4AF37)
                    : const Color(0xFF2A2A2A),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getBadgeColor(String type) {
    switch (type.toLowerCase()) {
      case 'promotion':
        return const Color(0xFFD4AF37); // Gold
      case 'announcement':
        return Colors.blue;
      case 'featured_service':
        return Colors.purple;
      case 'seasonal':
        return Colors.orange;
      default:
        return const Color(0xFF808080); // Gray
    }
  }

  String _getBadgeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'promotion':
        return 'PROMO';
      case 'announcement':
        return 'NEWS';
      case 'featured_service':
        return 'FEATURED';
      case 'seasonal':
        return 'SEASONAL';
      default:
        return type.toUpperCase();
    }
  }
}
