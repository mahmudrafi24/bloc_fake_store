import 'package:flutter/material.dart';

/// Breakpoints for responsive design
class Breakpoints {
  // Private constructor to prevent instantiation
  Breakpoints._();

  /// Mobile breakpoint (< 600px)
  static const double mobile = 600;

  /// Tablet breakpoint (600px - 1200px)
  static const double tablet = 900;

  /// Desktop breakpoint (> 1200px)
  static const double desktop = 1200;

  /// Check if current width is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobile;
  }

  /// Check if current width is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < desktop;
  }

  /// Check if current width is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktop;
  }

  /// Get current device type
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktop) return DeviceType.desktop;
    if (width >= mobile) return DeviceType.tablet;
    return DeviceType.mobile;
  }
}

/// Device type enum
enum DeviceType { mobile, tablet, desktop }

/// Responsive builder widget for conditional rendering based on screen size
class ResponsiveBuilder extends StatelessWidget {
  /// Widget to display on mobile devices
  final Widget mobile;

  /// Widget to display on tablet devices (optional, falls back to mobile)
  final Widget? tablet;

  /// Widget to display on desktop devices (optional, falls back to tablet or mobile)
  final Widget? desktop;

  const ResponsiveBuilder({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= Breakpoints.desktop) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= Breakpoints.mobile) {
          return tablet ?? mobile;
        }
        return mobile;
      },
    );
  }
}

/// Responsive value selector - returns different values based on screen size
class ResponsiveValue<T> {
  final T mobile;
  final T? tablet;
  final T? desktop;

  const ResponsiveValue({required this.mobile, this.tablet, this.desktop});

  /// Get the appropriate value for the current screen size
  T getValue(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= Breakpoints.desktop) {
      return desktop ?? tablet ?? mobile;
    } else if (width >= Breakpoints.mobile) {
      return tablet ?? mobile;
    }
    return mobile;
  }
}

/// Responsive padding utilities
class ResponsivePadding {
  // Private constructor to prevent instantiation
  ResponsivePadding._();

  /// Get responsive horizontal padding
  static double horizontal(BuildContext context) {
    if (Breakpoints.isDesktop(context)) return 32.0;
    if (Breakpoints.isTablet(context)) return 24.0;
    return 16.0;
  }

  /// Get responsive vertical padding
  static double vertical(BuildContext context) {
    if (Breakpoints.isDesktop(context)) return 24.0;
    if (Breakpoints.isTablet(context)) return 20.0;
    return 16.0;
  }

  /// Get responsive padding as EdgeInsets
  static EdgeInsets all(BuildContext context) {
    final padding = horizontal(context);
    return EdgeInsets.all(padding);
  }

  /// Get responsive symmetric padding
  static EdgeInsets symmetric(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: horizontal(context),
      vertical: vertical(context),
    );
  }

  /// Get responsive page padding (for main content areas)
  static EdgeInsets page(BuildContext context) {
    if (Breakpoints.isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 48.0, vertical: 32.0);
    }
    if (Breakpoints.isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0);
    }
    return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0);
  }

  /// Get responsive card padding
  static EdgeInsets card(BuildContext context) {
    if (Breakpoints.isDesktop(context)) {
      return const EdgeInsets.all(20.0);
    }
    if (Breakpoints.isTablet(context)) {
      return const EdgeInsets.all(16.0);
    }
    return const EdgeInsets.all(12.0);
  }
}

/// Responsive spacing utilities
class ResponsiveSpacing {
  // Private constructor to prevent instantiation
  ResponsiveSpacing._();

  /// Extra small spacing
  static double xs(BuildContext context) {
    if (Breakpoints.isDesktop(context)) return 6.0;
    if (Breakpoints.isTablet(context)) return 5.0;
    return 4.0;
  }

  /// Small spacing
  static double sm(BuildContext context) {
    if (Breakpoints.isDesktop(context)) return 12.0;
    if (Breakpoints.isTablet(context)) return 10.0;
    return 8.0;
  }

  /// Medium spacing
  static double md(BuildContext context) {
    if (Breakpoints.isDesktop(context)) return 20.0;
    if (Breakpoints.isTablet(context)) return 16.0;
    return 12.0;
  }

  /// Large spacing
  static double lg(BuildContext context) {
    if (Breakpoints.isDesktop(context)) return 32.0;
    if (Breakpoints.isTablet(context)) return 24.0;
    return 16.0;
  }

  /// Extra large spacing
  static double xl(BuildContext context) {
    if (Breakpoints.isDesktop(context)) return 48.0;
    if (Breakpoints.isTablet(context)) return 36.0;
    return 24.0;
  }

  /// Get SizedBox with responsive height
  static SizedBox verticalBox(BuildContext context, {required String size}) {
    double height;
    switch (size) {
      case 'xs':
        height = xs(context);
        break;
      case 'sm':
        height = sm(context);
        break;
      case 'md':
        height = md(context);
        break;
      case 'lg':
        height = lg(context);
        break;
      case 'xl':
        height = xl(context);
        break;
      default:
        height = md(context);
    }
    return SizedBox(height: height);
  }

  /// Get SizedBox with responsive width
  static SizedBox horizontalBox(BuildContext context, {required String size}) {
    double width;
    switch (size) {
      case 'xs':
        width = xs(context);
        break;
      case 'sm':
        width = sm(context);
        break;
      case 'md':
        width = md(context);
        break;
      case 'lg':
        width = lg(context);
        break;
      case 'xl':
        width = xl(context);
        break;
      default:
        width = md(context);
    }
    return SizedBox(width: width);
  }
}

/// Responsive grid utilities
class ResponsiveGrid {
  // Private constructor to prevent instantiation
  ResponsiveGrid._();

  /// Get responsive column count for product grids
  static int getColumnCount(BuildContext context) {
    if (Breakpoints.isDesktop(context)) return 4;
    if (Breakpoints.isTablet(context)) return 3;
    return 2;
  }

  /// Get responsive cross axis spacing
  static double getCrossAxisSpacing(BuildContext context) {
    if (Breakpoints.isDesktop(context)) return 16.0;
    if (Breakpoints.isTablet(context)) return 12.0;
    return 8.0;
  }

  /// Get responsive main axis spacing
  static double getMainAxisSpacing(BuildContext context) {
    if (Breakpoints.isDesktop(context)) return 16.0;
    if (Breakpoints.isTablet(context)) return 12.0;
    return 8.0;
  }

  /// Get responsive child aspect ratio for grid items
  static double getChildAspectRatio(BuildContext context) {
    if (Breakpoints.isDesktop(context)) return 0.75;
    if (Breakpoints.isTablet(context)) return 0.7;
    return 0.65;
  }
}

/// Responsive font size utilities
class ResponsiveFontSize {
  // Private constructor to prevent instantiation
  ResponsiveFontSize._();

  /// Scale factor for tablet
  static const double tabletScale = 1.1;

  /// Scale factor for desktop
  static const double desktopScale = 1.2;

  /// Get responsive font size
  static double scale(BuildContext context, double baseSize) {
    if (Breakpoints.isDesktop(context)) {
      return baseSize * desktopScale;
    }
    if (Breakpoints.isTablet(context)) {
      return baseSize * tabletScale;
    }
    return baseSize;
  }
}

/// Responsive width constraints for content
class ResponsiveConstraints {
  // Private constructor to prevent instantiation
  ResponsiveConstraints._();

  /// Maximum width for content on large screens
  static const double maxContentWidth = 1200.0;

  /// Maximum width for forms
  static const double maxFormWidth = 600.0;

  /// Get constrained box for content
  static Widget constrainContent(Widget child) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxContentWidth),
        child: child,
      ),
    );
  }

  /// Get constrained box for forms
  static Widget constrainForm(Widget child) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxFormWidth),
        child: child,
      ),
    );
  }
}
