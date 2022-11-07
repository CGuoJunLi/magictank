import 'package:magictank/swiper/src/swiper_plugin.dart';
import 'package:magictank/swiper/src/transformer_page_view/index_controller.dart';

class SwiperController extends IndexController {
  // Autoplay is started

  // ignore: constant_identifier_names
  static const int START_AUTOPLAY = 2;

  // Autoplay is stopped.
  // ignore: constant_identifier_names
  static const int STOP_AUTOPLAY = 3;

  // Indicate that the user is swiping
  // ignore: constant_identifier_names
  static const int SWIPE = 4;

  // Indicate that the `Swiper` has changed it's index and is building it's ui ,so that the
  // `SwiperPluginConfig` is available.
  // ignore: constant_identifier_names
  static const int BUILD = 5;

  // available when `event` == SwiperController.BUILD
  SwiperPluginConfig? config;

  // available when `event` == SwiperController.SWIPE
  // this value is PageViewController.pos
  double? pos;

  // ignore: overridden_fields, annotate_overrides
  int index = 0;
  // ignore: overridden_fields, annotate_overrides
  bool animation = false;
  bool? autoplay;

  SwiperController();

  void startAutoplay() {
    event = SwiperController.START_AUTOPLAY;
    autoplay = true;
    notifyListeners();
  }

  void stopAutoplay() {
    event = SwiperController.STOP_AUTOPLAY;
    autoplay = false;
    notifyListeners();
  }
}
