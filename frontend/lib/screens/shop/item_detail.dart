import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/item_image_slider.dart';
import 'package:frontend/components/report_modal.dart';
import 'package:frontend/components/toolbar.dart';
import 'package:frontend/providers/product_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemDetail extends ConsumerWidget {
  final String productId;
  const ItemDetail({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsyncValue =
        ref.watch(productProviderById(productId)); // Watch the product directly
    final user = ref.read(userProvider);
    return Scaffold(
      appBar:
          Toolbar(title: AppLocalizations.of(context)!.product_detail_title),
      body: productAsyncValue.when(
        data: (product) {
          return SingleChildScrollView(
            child: SafeArea(
                child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 254, 227, 121),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      )),
                  child: Stack(
                    children: [
                      Center(
                        child:
                            ItemImageSlider(images: product.productImageUrls),
                      )
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5, top: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: product.productTags.map((tag) {
                        final localizations = AppLocalizations.of(context)!;
                        final displayTag = {
                              "มือหนึ่ง": localizations.tag_first_hand,
                              "มือสอง": localizations.tag_second_hand,
                              "สภาพดี": localizations.tag_good_quality,
                              "อร่อย": localizations.tag_delicious,
                              "สะอาด": localizations.tag_clean,
                            }[tag] ??
                            tag;

                        return Container(
                          height: 40,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 254, 227, 121),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                spreadRadius: 2,
                              )
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: Center(
                              child: Text(
                                displayTag,
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 30, top: 10, right: 30), // Add right padding
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // Pushes items apart
                    children: [
                      Expanded(
                        child: Text(
                          product.productName,
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        "฿ ${NumberFormat('#,###').format(product.productPrice.toInt())}",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "@${user!.displayName}",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      product.productDatePost.toString(),
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, top: 15, right: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      product.productDescription,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, top: 25, right: 30),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return ReportModal(
                                id: product.productId,
                              );
                            });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.product_detail_report,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ),
                )
              ],
            )),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
