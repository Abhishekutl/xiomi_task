import 'package:demo/Views/detailScreen.dart';
import 'package:demo/provider/mainProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          ref.watch(mainProvider).imageIsLoaded) {
        // ref.read(mainProvider).increaseOffset();
        ref.read(mainProvider).setLoadMore(true);
      } else {
        ref.read(mainProvider).setLoadMore(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image List"),
        centerTitle: true,
      ),
      body: ref.watch(mainProvider).data.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: ref.watch(mainProvider).data.length,
                      padding: EdgeInsets.all(width * 0.03),
                      itemBuilder: (context, item) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                        image: ref
                                            .watch(mainProvider)
                                            .data[item]
                                            .xtImage
                                            .toString())));
                          },
                          child: Container(
                            padding: EdgeInsets.only(bottom: width * 0.02),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(width * 0.03))),
                            child: Image.network(
                              ref
                                  .watch(mainProvider)
                                  .data[item]
                                  .xtImage
                                  .toString(),
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      }),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                ref.watch(mainProvider).boolLoadMore
                    ? OutlinedButton(
                        onPressed: () {
                          ref.read(mainProvider).getImage();
                        },
                        child: const Text(
                          'Load More',
                          style: TextStyle(color: Colors.black),
                        ))
                    : const SizedBox.shrink()
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
