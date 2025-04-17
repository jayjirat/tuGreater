import 'package:flutter/material.dart';
import 'package:frontend/components/toast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/login.dart';
import 'package:frontend/screens/profile/setting_page.dart';
import 'package:frontend/screens/profile/uploadprofile_page.dart';
import 'package:frontend/services/displayname_api_service.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends ConsumerStatefulWidget {
  final String studentId;
  const ProfilePage({super.key, required this.studentId});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final DisplaynameApiService _apiService = DisplaynameApiService();
  String displayName = "Loading...";
  bool _isLoading = true;
  String _errorMessage = '';
  late String studentId;

  @override
  void initState() {
    super.initState();
    _loadStudentDisplayName();
    studentId = widget.studentId;
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
  // void _showSnackBar(String message, {bool isError = false}) {
  //   if (!mounted) return;

  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: Text(message),
  //     backgroundColor: isError ? Colors.red : null,
  //   ));
  // }

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
        showToast(
          message: "Display name updated successfully!",
          toastType: ToastType.success,
        );
        // _showSnackBar('Display name updated successfully!');

        // Refresh the display name from server to ensure consistency
        _loadStudentDisplayName();
      } else {
        // API returned false but didn't throw an exception
        setState(() {
          displayName = previousName; // Revert to previous name
        });
        showToast(
          message: 'Failed to update display name',
          toastType: ToastType.error,
        );
        // _showSnackBar('Failed to update display name', isError: true);
      }
    } catch (e) {
      if (!mounted) return;

      // Revert the optimistic update
      setState(() {
        displayName = previousName;
      });

      // TODO push error screen
      // _showSnackBar('Error: ${e.toString()}', isError: true);
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
                ref.read(userProvider.notifier).loadUser(studentId);
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
    final user = ref.watch(userProvider);
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _loadStudentDisplayName;
                          ref.invalidate(userProvider);
                        },
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
                      Row(
                        children: [
                          Spacer(),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: _loadStudentDisplayName,
                            tooltip: 'Refresh profile',
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Center(
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                  offset: Offset(
                                      0, 4), // changes position of shadow
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(10),
                            width: 350,
                            height: 300,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.network(
                                  user?.profileImageUrl ??
                                      'https://default-placeholder-url.com/image.png',
                                  width: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 100,
                                      height: 100,
                                      color: Colors.grey[300],
                                      child: Icon(Icons.person,
                                          size: 50, color: Colors.grey[600]),
                                    );
                                  },
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
                                          const Icon(
                                            Icons.edit,
                                            size: 16,
                                            color: Colors.black,
                                          ),
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
                            minimumSize: const Size(350, 75),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            elevation: 5),
                        child: Text(
                            AppLocalizations.of(context)!
                                .upload_profile_picture,
                            style: TextStyle(fontSize: 20)),
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
                            minimumSize: const Size(350, 75),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            elevation: 5),
                        child: Text(AppLocalizations.of(context)!.settings,
                            style: TextStyle(fontSize: 20)),
                      )),
                      Center(
                          child: ElevatedButton(
                        onPressed: () {
                          ref.read(userProvider.notifier).logout();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                            (Route<dynamic> route) =>
                                false, // removes all previous routes
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent, // Button color
                            minimumSize: const Size(350, 75),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            elevation: 5),
                        child: Text(AppLocalizations.of(context)!.signout,
                            style:
                                TextStyle(color: Colors.black, fontSize: 20)),
                      )),
                    ],
                  ),
                ),
    );
  }
}
