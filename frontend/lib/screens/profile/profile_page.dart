import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/toast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/community/community_me.dart';
import 'package:frontend/screens/error_page.dart';
import 'package:frontend/screens/profile/setting_page.dart';
import 'package:frontend/screens/profile/uploadprofile_page.dart';
import 'package:frontend/services/displayname_api_service.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/exception/timeout_exception.dart';

class ProfilePage extends ConsumerStatefulWidget {
  // final String userId;
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final DisplaynameApiService _apiService = DisplaynameApiService();
  String displayName = "Loading...";
  bool _isLoading = true;
  String _errorMessage = '';
  late dynamic user;
  @override
  void initState() {
    super.initState();
    user = ref.read(userProvider);
    _loadStudentDisplayName();
  }

  Future<void> _loadStudentDisplayName() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final name = await _apiService.getStudentDisplayName(user.id);

      if (!mounted) return;

      setState(() {
        displayName = name;
        _isLoading = false;
      });
    } on TimeoutException catch (e) {
      setState(() {
        _isLoading = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ErrorPage(errorMessage: e.message),
          ));
      // implement timeout page
    } catch (e) {
      if (!mounted) {
        return;
      }
      showToast(
        message: AppLocalizations.of(context)!.error_getdisplayname,
        toastType: ToastType.error,
      );
      setState(() {
        _isLoading = false;
      });
    }
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
      final success = await ref.read(userProvider.notifier).updateDisplayName(
            userId: user.id,
            newDisplayName: newName,
            context: context,
          );

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
          message: AppLocalizations.of(context)!.error_updatedisplayname,
          toastType: ToastType.error,
        );
        // _showSnackBar('Failed to update display name', isError: true);
      }
    } catch (e) {
      if (!mounted) return;
      showToast(message: e.toString(), toastType: ToastType.error);

      // Revert the optimistic update
      setState(() {
        displayName = previousName;
      });
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
            maxLength: 15,
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
              onPressed: () async {
                final newName = nameController.text.trim();
                Navigator.of(dialogContext).pop();
                // Call update method after dialog is closed
                _updateDisplayName(newName);
                await ref.read(userProvider.notifier).loadUser(user.id);
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
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
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
                      const SizedBox(height: 25),
                      InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CommunityMe(userId: user.id),
                            )),
                        child: Center(
                          child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).secondaryHeaderColor,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CachedNetworkImage(
                                    useOldImageOnUrlChange: true,
                                    fadeInDuration: Duration.zero,
                                    imageUrl: user?.profileImageUrl ??
                                        'https://default-placeholder-url.com/image.png',
                                    width: 100,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => SizedBox(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
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
                                              style:
                                                  const TextStyle(fontSize: 20),
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
                                        user.studentId,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      ),
                      const SizedBox(height: 30),
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
                      const SizedBox(height: 30),
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
                      const SizedBox(height: 30),
                      Center(
                          child: ElevatedButton(
                        onPressed: () async {
                          try {
                            await ref.read(userProvider.notifier).logout();
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/',
                              (Route<dynamic> route) =>
                                  false, // removes all previous routes
                            );
                          } catch (e) {
                            showToast(
                                message: "Fail to logout",
                                toastType: ToastType.error);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent, // Button color
                            minimumSize: const Size(350, 75),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            elevation: 5),
                        child: Text(AppLocalizations.of(context)!.signout,
                            style: TextStyle(fontSize: 20)),
                      )),
                    ],
                  ),
                ),
    );
  }
}
