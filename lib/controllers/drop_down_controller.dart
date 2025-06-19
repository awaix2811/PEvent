import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CountryController extends GetxController {
  final RxString selectedCountry = 'Pakistan'.obs;
  final RxBool isDropdownOpen = false.obs;

  final List<String> countries = [
    'Pakistan',
    'United States',
    'United Kingdom',
    'China',
    'India',
    'Russia',
    'Germany',
    'France',
    'Australia',
    'Canada',
  ];

  void changeCountry(String country) {
    selectedCountry.value = country;
  }

  void toggleDropdown() {
    isDropdownOpen.value = !isDropdownOpen.value;
  }
}
