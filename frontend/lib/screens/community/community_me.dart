import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/community_post.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/providers/community_provider.dart';
import 'package:frontend/providers/product_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/screens/community/community_view_post.dart';
import 'package:frontend/screens/shop/edit_items.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommunityMe extends ConsumerStatefulWidget {
  final String userId;
  const CommunityMe({super.key, required this.userId});

  @override
  CommunityMeState createState() => CommunityMeState();
}

class CommunityMeState extends ConsumerState<CommunityMe> {
  String capitalize(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  void initState() {
    super.initState();
    _initState();
  }

  User? loadedUser;

  void _initState() async {
    Future.microtask(() async {
      await ref.read(communityProvider.notifier).fetchMyPosts(widget.userId);
      final currentUser = ref.read(userProvider);
      if (widget.userId != currentUser!.id) {
        final postUser = await ref
            .read(userProvider.notifier)
            .getUserById(userId: widget.userId);
        if (postUser != null) {
          setState(() {
            loadedUser = postUser;
          });
        }
      } else {
        setState(() {
          loadedUser = currentUser;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      ref.refresh(productProviderByProductOwnerId(widget.userId));
    }
  }

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    if (loadedUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final posts = ref.watch(communityProvider);
    final communityPostController = ref.read(communityProvider.notifier);
    final productManageAsyncValue =
        ref.watch(productProviderByProductOwnerId(loadedUser!.id));
    final List<Widget> swapPage = [
      Expanded(
        child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                communityPost(
                    context: context,
                    nextRoute: CommunityViewpost(id: post.id),
                    post: post,
                    communityPostController: communityPostController),
                const SizedBox(height: 12),
              ],
            );
          },
        ),
      ),
      productManageAsyncValue.when(
        data: (products) => RefreshIndicator(
          onRefresh: () async {
            final user = ref.read(userProvider);
            ref.refresh(productProviderByProductOwnerId(user!.id));
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                children: [
                  ...products.map((product) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      height: 120,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 240, 239, 239),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width / 4,
                            margin: EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                              color: Color(0xFFD4ECF7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: product.productImageUrls.isNotEmpty
                                ? Image.network(product.productImageUrls[0],
                                    fit: BoxFit.cover)
                                : Icon(Icons.image_not_supported),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 20, top: 20, bottom: 15),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.productName,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  widget.userId == loadedUser!.id &&
                                          widget.userId ==
                                              product.productOwnerId
                                      ? FilledButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditItems(
                                                            productId: product
                                                                .productId,
                                                            productOwnerId:
                                                                loadedUser!
                                                                    .id)));
                                          },
                                          style: FilledButton.styleFrom(
                                            backgroundColor:
                                                Colors.white.withOpacity(0.8),
                                            foregroundColor: Colors.black,
                                            elevation: 0,
                                          ),
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .edit),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 8, right: 8),
                            child: IconButton(
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(AppLocalizations.of(context)!
                                        .confirmDelete),
                                    content: Text(AppLocalizations.of(context)!
                                        .confirmDeleteMessage),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .cancel),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: Text(
                                          AppLocalizations.of(context)!.delete,
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  await ref.read(deleteProduct(Tuple2(
                                      product.productOwnerId,
                                      product.productId)));

                                  await Future.delayed(
                                      Duration(milliseconds: 100));
                                  ref.refresh(productProviderByProductOwnerId(
                                      loadedUser!.id));

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Product deleted successfully')));
                                }
                              },
                              icon: Icon(Icons.delete),
                              color: Colors.redAccent,
                              tooltip: AppLocalizations.of(context)!.delete,
                            ),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(err.toString())),
      )
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 2,
        title: Text(
          loadedUser!.displayName,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            loadedUser!.profileImageUrl == ""
                ? CircleAvatar(
                    radius: 60,
                    backgroundColor: Theme.of(context).primaryColorDark,
                    child: Icon(
                      Icons.account_circle,
                      size: 120,
                      color: Theme.of(context).cardColor,
                    ),
                  )
                : CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(loadedUser!.profileImageUrl),
                    backgroundColor: Colors.transparent,
                  ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "${capitalize(loadedUser!.username.split(" ")[0])} ${capitalize(loadedUser!.username.split(" ")[1])}", //username
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              loadedUser!.displayName, //displayname
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color:
                        Theme.of(context).canvasColor.withValues(alpha: 0.05),
                    spreadRadius: 1,
                    blurRadius: 1,
                  ),
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  swapBar(
                      text: AppLocalizations.of(context)!.posts,
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                      },
                      selectedIndex: 0),
                  const SizedBox(
                    width: 4,
                  ),
                  swapBar(
                      text: AppLocalizations.of(context)!.shops,
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                      selectedIndex: 1),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            swapPage[_selectedIndex]
          ],
        ),
      ),
    );
  }

  Widget swapBar(
      {required String text,
      required GestureTapCallback onPressed,
      required int selectedIndex}) {
    return Expanded(
        child: TextButton(
      onPressed: onPressed,
      style: _selectedIndex == selectedIndex
          ? activeSwapBarStyle()
          : inactiveSwapBarStyle(),
      child: Text(text),
    ));
  }

  ButtonStyle inactiveSwapBarStyle() {
    return TextButton.styleFrom(
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      foregroundColor: Theme.of(context).canvasColor.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  ButtonStyle activeSwapBarStyle() {
    return TextButton.styleFrom(
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      backgroundColor: Theme.of(context).canvasColor.withValues(alpha: 0.05),
      foregroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
