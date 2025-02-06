import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toyota_accessory_app/widgets/custom_header.dart';
import 'package:toyota_accessory_app/models/dealer.dart';
import 'package:toyota_accessory_app/models/vehicle.dart';
import 'package:toyota_accessory_app/models/accessory.dart';
import 'package:toyota_accessory_app/services/api_service.dart';
import 'package:toyota_accessory_app/controllers/basket_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class DealerSelectionScreen extends StatefulWidget {
  const DealerSelectionScreen({Key? key}) : super(key: key);

  @override
  _DealerSelectionScreenState createState() => _DealerSelectionScreenState();
}

class _DealerSelectionScreenState extends State<DealerSelectionScreen> {
  final ApiService _apiService = Get.find();
  final BasketController _basketController = Get.find();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final RxList<Dealer> _dealers = RxList<Dealer>();
  final RxMap<String, List<Accessory>> _groupedAccessories = RxMap<String, List<Accessory>>();
  final RxBool _acceptedPrivacyPolicy = false.obs;

  Dealer? _selectedDealer;
  bool _isLoading = true;
  String? _emailError;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    await Future.wait([
      _fetchDealers(),
      _fetchBasketAccessories(),
    ]);
  }

  Future<void> _fetchDealers() async {
    try {
      setState(() => _isLoading = true);
      final dealers = await _apiService.getDealers();
      _dealers.assignAll(dealers);
    } catch (e) {
      _showErrorDialog('Error fetching dealers: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchBasketAccessories() async {
    try {
      final accessories = _basketController.basketItems;
      if (accessories.isNotEmpty) {
        _groupAccessoriesByVehicle(accessories);
      } else {
        _groupedAccessories.clear();
      }
    } catch (e) {
      _showErrorDialog('Error fetching basket accessories: $e');
    }
  }

  Future<void> _launchPrivacyPolicy() async {
    const privacyUrl = 'https://your-privacy-policy-url.com';
    if (await canLaunchUrl(Uri.parse(privacyUrl))) {
      await launchUrl(Uri.parse(privacyUrl));
    } else {
      throw 'Could not launch $privacyUrl';
    }
  }

  void _groupAccessoriesByVehicle(List<Accessory> accessories) {
    final Map<String, List<Accessory>> tempGrouped = {};

    // First, fetch vehicles to get the relationship data
    _apiService.getVehicles().then((vehicles) {
      for (var vehicle in vehicles) {
        // Find accessories that belong to this vehicle
        final vehicleAccessories = accessories.where((accessory) {
          return vehicle.accessories?.any((vehicleAcc) =>
          vehicleAcc.accessoriesId?.id == accessory.id) ?? false;
        }).toList();

        if (vehicleAccessories.isNotEmpty) {
          tempGrouped[vehicle.name] = vehicleAccessories;
        }
      }

      // Sort accessories within each vehicle group
      tempGrouped.forEach((key, list) {
        // First sort by type
        list.sort((a, b) => a.type.compareTo(b.type));
        // Then sort by name within each type
        list.sort((a, b) {
          if (a.type == b.type) {
            return a.name.compareTo(b.name);
          }
          return 0;
        });
      });

      _groupedAccessories.assignAll(tempGrouped);

      // Debug print to verify grouping
      print('Grouped Accessories:');
      tempGrouped.forEach((vehicleName, accessories) {
        print('Vehicle: $vehicleName');
        print('Number of accessories: ${accessories.length}');
        accessories.forEach((accessory) {
          print('  - ${accessory.name} (${accessory.type})');
        });
      });
    }).catchError((error) {
      print('Error fetching vehicles: $error');
      // Fallback to basic grouping if vehicle fetch fails
      _fallbackGrouping(accessories);
    });
  }

  void _fallbackGrouping(List<Accessory> accessories) {
    final Map<String, List<Accessory>> tempGrouped = {};

    for (var accessory in accessories) {
      final vehicleName = accessory.category ?? 'Unknown Vehicle';
      if (!tempGrouped.containsKey(vehicleName)) {
        tempGrouped[vehicleName] = [];
      }
      tempGrouped[vehicleName]!.add(accessory);
    }

    // Sort accessories within each group
    tempGrouped.forEach((key, list) {
      list.sort((a, b) => a.name.compareTo(b.name));
    });

    _groupedAccessories.assignAll(tempGrouped);
  }

  void _handleSearchQuery(String query) {
    if (query.isEmpty) {
      _fetchDealers();
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    final filteredDealers = _dealers.where((dealer) {
      return dealer.name.toLowerCase().contains(lowercaseQuery) ||
          (dealer.address ?? '').toLowerCase().contains(lowercaseQuery);
    }).toList();

    _dealers.assignAll(filteredDealers);
  }

  Widget _buildDealerCard(BuildContext context, int index) {
    final dealer = _dealers[index];
    final isSelected = _selectedDealer?.id == dealer.id;

    return GestureDetector(
      onTap: () => setState(() => _selectedDealer = dealer),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.8,
        margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: const Color(0xFFD1031F), width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dealer.name,
              style: const TextStyle(
                color: Color(0xFF333333),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (dealer.address != null)
              Text(
                dealer.address!,
                style: const TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedDealerCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Dealer: ${_selectedDealer!.name}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF222222),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            // Email field and submit button in a row
            Stack(
              children: [
                // Email TextField
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(right: 0), // Space for button
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter your email address',
                      hintStyle: const TextStyle(
                        color: Color(0xFF222222),
                        fontSize: 10,
                      ),
                      errorText: _emailError,
                      errorStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 2,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (_) => setState(() => _emailError = null),
                  ),
                ),
                // Submit Button positioned on top of the TextField
                Positioned(
                  right: 5,
                  top: 5,
                  child: SizedBox(
                    height: 38,
                    width: 110,
                    child: ElevatedButton(
                      onPressed: _submitInquiry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD1031F),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Enquire Now',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                          SizedBox(width: 4), // Space between text and icon
                          Icon(
                            Icons.arrow_forward,
                            size: 16, // Smaller icon size to match text
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Privacy Policy with clickable link
            Row(
              children: [
                Obx(() => SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: _acceptedPrivacyPolicy.value,
                    onChanged: (value) => _acceptedPrivacyPolicy.value = value ?? false,
                    checkColor: Colors.white, // White tick
                    fillColor: MaterialStateProperty.resolveWith(
                          (states) => states.contains(MaterialState.selected)
                          ? const Color(0xFFD1031F) // Red background when selected
                          : const Color(0xFFD1031F), // Red background when unselected
                    ),
                    side: const BorderSide(
                      color: Colors.transparent, // Removes border
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                )),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: _launchPrivacyPolicy,
                    child: RichText(
                      text: const TextSpan(
                        text: 'I accept the ',
                        style: TextStyle(
                          color: Colors.black, // Black text
                          fontSize: 11,
                        ),
                        children: [
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: Color(0xFFD1031F), // Red text for privacy policy
                              decoration: TextDecoration.underline,
                              decorationThickness: 1, // Optional: adjust underline thickness
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitInquiry() async {
    if (!_validateInquiryForm()) return;

    try {
      // Create inquiry data
      final inquiryData = {
        'dealer_id': _selectedDealer!.id,
        'email': _emailController.text,
        'basket_items': _basketController.basketItems.map((item) => {
          'accessory_id': item.id,
          'part_number': item.partNumber,
          'type': item.type,
          'category': item.category,
        }).toList(),
      };

      // await _apiService.submitDealerInquiry(inquiryData);

      Get.snackbar(
        'Success',
        'Your inquiry has been submitted successfully.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Clear form
      _emailController.clear();
      _acceptedPrivacyPolicy.value = false;
      setState(() => _selectedDealer = null);

    } catch (e) {
      _showErrorDialog('Error submitting inquiry: $e');
    }
  }

  bool _validateInquiryForm() {
    if (_emailController.text.isEmpty) {
      setState(() => _emailError = 'Email is required');
      return false;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(_emailController.text)) {
      setState(() => _emailError = 'Please enter a valid email');
      return false;
    }

    if (!_acceptedPrivacyPolicy.value) {
      _showErrorDialog('Please accept the privacy policy to continue');
      return false;
    }

    return true;
  }

  void _showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _initializeData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildBackButton(),
                      const SizedBox(height: 16),
                      _buildDealerSearch(),
                      const SizedBox(height: 16),
                      _buildNearbyDealersSection(),
                      if (_selectedDealer != null) _buildSelectedDealerCard(),
                      _buildOrderSummarySection(),
                      const SizedBox(height: 16), // Bottom padding
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: GestureDetector(
        onTap: () => Get.back(),
        child: const CircleAvatar(
          backgroundColor: Color(0xFFD1031F),
          radius: 18,
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDealerSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Find a dealer',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: _searchController,
            onChanged: _handleSearchQuery,
            decoration: InputDecoration(
              hintText: 'Search for a dealer...',
              prefixIcon: const Icon(Icons.search),
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildNearbyDealersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: Text(
            'Explore nearby',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
        ),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _dealers.length,
              itemBuilder: _buildDealerCard,
            ),
          ),
      ],
    );
  }

  Widget _buildOrderSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
        ),
        if (_groupedAccessories.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Your basket is empty. Please add accessories to proceed.',
              style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _groupedAccessories.length,
            itemBuilder: _buildVehicleAccessoryCard,
          ),
      ],
    );
  }

  Widget _buildVehicleAccessoryCard(BuildContext context, int index) {
    final vehicleName = _groupedAccessories.keys.elementAt(index);
    final accessories = _groupedAccessories[vehicleName]!;
    final expandedNotifier = ValueNotifier<bool>(false);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          onExpansionChanged: (isExpanded) {
            expandedNotifier.value = isExpanded;
          },
          tilePadding: EdgeInsets.zero,
          trailing: const SizedBox.shrink(),
          title: Padding(
            padding: const EdgeInsets.all(8), // Consistent padding all around
            child: SizedBox(
              height: 80, // Adjusted height
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image container
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2C),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: FutureBuilder<List<Vehicle>>(
                      future: _apiService.getVehicles(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final vehicle = snapshot.data!.firstWhere(
                                (v) => v.name == vehicleName,
                            orElse: () => Vehicle.empty(),
                          );
                          return Center(
                            child: Image.network(
                              'http://192.168.1.208:8055/assets/${vehicle.image}',
                              width: 70,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.directions_car, color: Colors.grey, size: 40),
                            ),
                          );
                        }
                        return const Icon(Icons.directions_car, color: Colors.grey, size: 40);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Vehicle details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Spacer(),
                        Text(
                          vehicleName,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        FutureBuilder<List<Vehicle>>(
                          future: _apiService.getVehicles(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final vehicle = snapshot.data!.firstWhere(
                                    (v) => v.name == vehicleName,
                                orElse: () => Vehicle.empty(),
                              );
                              return Text(
                                'Model Year ${vehicle.modelYear ?? ''}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ],
                    ),
                  ),
                  // Accessories count and rotating arrow
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${accessories.length}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const Text(
                            ' Accessories',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          ValueListenableBuilder<bool>(
                            valueListenable: expandedNotifier,
                            builder: (context, isExpanded, child) {
                              return AnimatedRotation(
                                turns: isExpanded ? 0.25 : 0,
                                duration: const Duration(milliseconds: 200),
                                child: const Icon(
                                  Icons.chevron_right,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          children: [
            Container(
              color: Colors.white,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: accessories.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey[300],
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final accessory = accessories[index];
                  return Padding(
                    padding: const EdgeInsets.all(16), // Consistent padding
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                accessory.name,
                                style: const TextStyle(
                                  color: Color(0xFFD1031F),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Part Number: ${accessory.partNumber}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                'Type: ${accessory.type}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.black, size: 20),
                          onPressed: () => _handleDeleteAccessory(context, accessory),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessoryImage(Accessory accessory) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        accessory.image ?? '',
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 60,
          height: 60,
          color: Colors.grey.shade300,
          child: const Icon(Icons.image_not_supported, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildAccessoryListItem(Accessory accessory) {
    return ListTile(
      title: Text(
        accessory.name,
        style: const TextStyle(fontSize: 14),
      ),
      subtitle: Text(
        'Part Number: ${accessory.partNumber}',
        style: const TextStyle(fontSize: 12),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () {
          _basketController.removeItem(context, accessory);
          _fetchBasketAccessories();
        },
      ),
    );
  }

  Future<void> _handleDeleteAccessory(BuildContext context, Accessory accessory) async {
    // Show confirmation dialog
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Accessory'),
          content: Text('Are you sure you want to remove ${accessory.name} from your basket?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    // If user didn't confirm or dialog was dismissed
    if (shouldDelete != true || !mounted) return;

    try {
      // Store the accessory for potential undo
      final removedAccessory = accessory;

      // Remove the item from basket
      _basketController.removeItem(context, accessory);

      // Refresh the grouped accessories
      _fetchBasketAccessories();

      if (!mounted) return;

      // Show snackbar with undo option
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${accessory.name} removed from basket'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              // Add the item back to basket
              _basketController.addItem(context, removedAccessory);
              // Refresh the grouped accessories
              _fetchBasketAccessories();
            },
          ),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove accessory: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }
}