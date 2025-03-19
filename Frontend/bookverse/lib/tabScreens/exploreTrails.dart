import 'package:bookverse/tabScreens/trailDetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Add http package
import 'dart:convert'; // For jsonDecode

class ExploreTrails extends StatefulWidget {
  final Function(String trailKey) onTrailsSelected;
  const ExploreTrails({super.key, required this.onTrailsSelected});

  @override
  State<ExploreTrails> createState() => _ExploreTrailsState();
}

class _ExploreTrailsState extends State<ExploreTrails> {
  List<dynamic> trails = []; // Use dynamic list to hold trail data
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTrails(); // Fetch trails when the widget is initialized
  }

  Future<void> fetchTrails() async {
    setState(() {
      isLoading = true; // Set loading to true when fetching data
    });
    
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/trails/except/person/1a84e09a-c439-4308-b174-8b6a76864e0e'));

      print('Response status: ${response.statusCode}'); // Debugging log
      print('Response body: ${response.body}'); // Log the body of the response

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          trails = jsonData;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load trails. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading if there's an error
      });
      print('Error fetching trails: $e'); // Print error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: fetchTrails, // Fetch trails when the user pulls to refresh
        child: isLoading
            ? const Center(child: CircularProgressIndicator()) // Show loading indicator while fetching data
            : Column(
              children: [
                const SizedBox(height: 80),
                const Text(
                  "Explore Trails",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: trails.length,
                      itemBuilder: (context, index) {
                        final trail = trails[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 14), // Add margin for spacing
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color for the container
                            borderRadius: BorderRadius.circular(8), // Rounded corners
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200, // Shadow color
                                spreadRadius: 2, // Spread radius
                                blurRadius: 2, // Blur radius
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    trail['title'] ?? 'No Title',
                                    style: const TextStyle(
                                      fontSize: 16, // Adjust title font size
                                      fontWeight: FontWeight.w500, // Make the title bold
                                    ),
                                  ), // Access title directly from JSON
                                  subtitle: Text(
                                    trail['description'] ?? 'No Description',
                                    maxLines: 2, // Limit to 3 lines
                                    overflow: TextOverflow.ellipsis, // Show ellipsis when text overflows
                                    style: const TextStyle(
                                      fontSize: 14, // Adjust subtitle font size
                                    ),
                                  ),
                                  leading: ClipOval(
                                    child: Image.asset(
                                      'assets/book_background.png', // Update this path to your asset image
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),                      
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    widget.onTrailsSelected(trail['trailId'].toString());
                                  },
                                  label: const Text('Explore', style: TextStyle(fontSize: 14),), // Button label
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFDCAA), // Use the desired background color
                                    foregroundColor: Colors.black87,
                                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                            
                              ],
                            ),
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
}


