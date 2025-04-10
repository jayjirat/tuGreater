import 'package:flutter/material.dart';
import 'package:frontend/screens/profile/setting_page.dart';
import 'package:frontend/screens/profile/uploadprofile_page.dart';
import 'package:frontend/services/displayname_api_service.dart';

class ProfilePage extends StatefulWidget {
  final String studentId;
  const ProfilePage({super.key, this.studentId = '651111102'});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final DisplaynameApiService _apiService = DisplaynameApiService();

  String displayName = "Loading...";
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadStudentDisplayName();
  }

  Future<void> _loadStudentDisplayName() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final name = await _apiService.getStudentDisplayName(widget.studentId);

      if (!mounted) return;

      setState(() {
        displayName = name;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Failed to load display name';
        _isLoading = false;
      });
    }
  }

  // Separate method to show snackbar to avoid context issues
  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : null,
    ));
  }

  Future<void> _updateDisplayName(String newName) async {
    if (newName.trim().isEmpty || newName == displayName) {
      return; // No change or empty name
    }

    final previousName = displayName;

    // Set optimistic update
    setState(() {
      displayName = newName;
    });

    try {
      final success =
          await _apiService.updateStudentDisplayName(widget.studentId, newName);

      if (!mounted) return;

      if (success) {
        _showSnackBar('Display name updated successfully!');

        // Refresh the display name from server to ensure consistency
        _loadStudentDisplayName();
      } else {
        // API returned false but didn't throw an exception
        setState(() {
          displayName = previousName; // Revert to previous name
        });
        _showSnackBar('Failed to update display name', isError: true);
      }
    } catch (e) {
      if (!mounted) return;

      // Revert the optimistic update
      setState(() {
        displayName = previousName;
      });

      _showSnackBar('Error: ${e.toString()}', isError: true);
    }
  }

  void _showChangeNameDialog() {
    if (!mounted) return;

    final TextEditingController nameController =
        TextEditingController(text: displayName);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // Use separate context for dialog
        return AlertDialog(
          title: const Text('Change Display Name'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'New Display Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = nameController.text.trim();
                Navigator.of(dialogContext).pop();
                // Call update method after dialog is closed
                _updateDisplayName(newName);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 223, 130, 9),
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: const Color.fromARGB(255, 223, 130, 9),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadStudentDisplayName,
              tooltip: 'Refresh profile',
            ),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white))
            : _errorMessage.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _errorMessage,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _loadStudentDisplayName,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(height: 5),
                        Center(
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.all(10),
                              width: 350,
                              height: 300,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.network(
                                    "https://static.vecteezy.com/system/resources/previews/020/765/399/non_2x/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg",
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: _showChangeNameDialog,
                                        child: Row(
                                          children: [
                                            Text(
                                              displayName,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20),
                                            ),
                                            const SizedBox(width: 5),
                                            const Icon(Icons.edit, size: 16),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        widget.studentId,
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                        Center(
                            child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const UploadProfilePage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Button color
                            minimumSize: const Size(350, 75),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          child: const Text("Upload profile picture",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20)),
                        )),
                        Center(
                            child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SettingPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Button color
                            minimumSize: const Size(350, 75),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          child: const Text("Settings",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20)),
                        )),
                        Center(
                            child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent, // Button color
                            minimumSize: const Size(350, 75),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          child: const Text("SIGN OUT",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20)),
                        )),
                      ],
                    ),
                  ),
      ),
    );
  }
}
