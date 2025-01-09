// lib/screens/dealer_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toyota_accessory_app/models/dealer.dart';
import 'package:toyota_accessory_app/services/api_service.dart';
import 'package:toyota_accessory_app/widgets/custom_header.dart';

class DealerSelectionScreen extends StatefulWidget {
  DealerSelectionScreen({Key? key}) : super(key: key);

  @override
  _DealerSelectionScreenState createState() => _DealerSelectionScreenState();
}

class _DealerSelectionScreenState extends State<DealerSelectionScreen> {
  final ApiService _apiService = Get.find();
  final TextEditingController _searchController = TextEditingController();
  final RxList<Dealer> _dealers = RxList<Dealer>();
  Dealer? _selectedDealer;

  @override
  void initState() {
    super.initState();
    _fetchDealers();
  }

  Future<void> _fetchDealers() async {
    try {
      final dealers = await _apiService.getDealers();
      _dealers.assignAll(dealers);
    } catch (e) {
      print('Error fetching dealers: $e');
    }
  }

  void _filterDealers(String query) {
    if (query.isEmpty) {
      _fetchDealers();
    } else {
      final filteredDealers = _dealers.where((dealer) {
        return dealer.name.toLowerCase().contains(query.toLowerCase()) ||
            (dealer.address ?? '').toLowerCase().contains(query.toLowerCase());
      }).toList();
      _dealers.assignAll(filteredDealers);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          const CustomHeader(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Select a Dealer',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterDealers,
              decoration: InputDecoration(
                hintText: 'Find a dealer',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Explore Nearby',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Obx(() {
            return _dealers.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _dealers.length,
                itemBuilder: (context, index) {
                  final dealer = _dealers[index];
                  return _buildDealerCard(context, dealer, isCarousel: true);
                },
              ),
            );
          }),
          if (_selectedDealer != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedDealer!.name,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_selectedDealer!.address != null)
                        Text(
                          _selectedDealer!.address!,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Checkbox(value: false, onChanged: (value) {}),
                          const Text('I accept the Privacy Policy'),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle submission
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const Divider(thickness: 1),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 2, // Example grouping by vehicle
              itemBuilder: (context, index) {
                return _buildAccordionCard(context, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDealerCard(BuildContext context, Dealer dealer,
      {bool isCarousel = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDealer = dealer;
        });
      },
      child: Card(
        margin: isCarousel
            ? const EdgeInsets.only(right: 16)
            : const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dealer.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (dealer.address != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    dealer.address!,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccordionCard(BuildContext context, int index) {
    return ExpansionTile(
      title: Row(
        children: [
          Image.network(
            'https://via.placeholder.com/60',
            width: 60,
            height: 60,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Vehicle Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Model Year',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const Text('02 | Accessories added'),
        ],
      ),
      children: List.generate(
        2, // Example accessory count
            (accessoryIndex) => ListTile(
          title: const Text('Accessory Name'),
          subtitle: const Text('Part Number: ABC123'),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // Handle deletion
            },
          ),
        ),
      ),
    );
  }
}
