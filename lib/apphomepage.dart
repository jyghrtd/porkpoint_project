import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:porkpoint_project/DataBase/homepage.dart';
import 'package:porkpoint_project/DataBase/lecturesearchdata.dart';
import 'package:porkpoint_project/DataBase/post_content.dart';
import 'package:porkpoint_project/communitypost.dart';
import 'package:porkpoint_project/frequentfunc.dart';
import 'package:porkpoint_project/introduce.dart';
import 'package:porkpoint_project/categorysearch.dart';
import 'package:porkpoint_project/lectureevaluation.dart';
import 'package:porkpoint_project/lecturesearch.dart';
import 'package:porkpoint_project/qnapost.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AppHomePage extends StatefulWidget {
  const AppHomePage({super.key});

  @override
  State<AppHomePage> createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  bool loading = false;

  Homepage _homepageData =
      Homepage(code: 0, mainpageElement: [], popularElement: [], categorySort: [], newPost: []);

  int currentImage = 0;
  final CarouselController carouselController = CarouselController();
  List imageList = [];

  @override
  void initState() {
    super.initState();
    HomeScreenData.getInfo().then((value) {
      setState(() {
        _homepageData = value;
        loading = true;
        for (int i = 0; i < _homepageData.mainpageElement.length; i++) {
          imageList.add(_homepageData.mainpageElement[i].lecturesImageUrl);
        }
      });
    });
  }

  TextEditingController tec = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double imageHeightPosition = 120;
    double imageWidthPosition = 130;
    final ScrollController scrollController = ScrollController();
    int categoryParent = 5; //카테고리 대분류 갯수. sql에 정보를 정해놓지 않았으므로 현재는 고정값을 상황에 따라 변동.

    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: TextField(
                  decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      hintText: "검색어를 입력해 주세요"),
                  controller: tec,
                ),
              ),
              IconButton(
                  onPressed: () {
                    TransferMap(context, LectureSearch(tec.text));
                  },
                  icon: const Icon(Icons.search)), //onPressed
            ],
          ),
          backgroundColor: Colors.blue[300],
        ),
        drawer: _homepageData.categorySort.isNotEmpty
            ? Drawer(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: categoryParent, //대분류 갯수
                  itemBuilder: (context, index) {
                    return eachCategory(_homepageData.categorySort[index].categoryName, [
                      for (int i = 0; i < _homepageData.categorySort.length; i++)
                        if (_homepageData.categorySort[i].categoryParent == index + 1)
                          drawerBtn(_homepageData.categorySort[i].categoryName, i + 1)
                    ]);
                  },
                ),
              )
            : const Drawer(),
        //body
        body: Scrollbar(
          controller: scrollController,
          thickness: 5,
          child: _homepageData.mainpageElement.isNotEmpty
              ? ListView(
                  children: [
                    SizedBox(
                      height: 300,
                      child: Stack(
                        children: [sliderWidget(), sliderIndicator()],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: SizedBox(
                            width: imageWidthPosition,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(
                                  _homepageData.popularElement[0].lecturesImageUrl,
                                  width: imageWidthPosition,
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  _homepageData.popularElement[0].title,
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            TransferMap(context,
                                LectureIntroduce(_homepageData.popularElement[0].lectureId));
                          },
                        ),
                        InkWell(
                          child: SizedBox(
                            width: imageWidthPosition,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(
                                  _homepageData.popularElement[1].lecturesImageUrl,
                                  width: imageWidthPosition,
                                  fit: BoxFit.cover,
                                ),
                                Text(_homepageData.popularElement[1].title)
                              ],
                            ),
                          ),
                          onTap: () {
                            TransferMap(context,
                                LectureIntroduce(_homepageData.popularElement[1].lectureId));
                          },
                        ),
                        InkWell(
                          child: SizedBox(
                            width: imageWidthPosition,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(
                                  _homepageData.popularElement[2].lecturesImageUrl,
                                  width: imageWidthPosition,
                                  fit: BoxFit.cover,
                                ),
                                Text(_homepageData.popularElement[2].title)
                              ],
                            ),
                          ),
                          onTap: () {
                            TransferMap(context,
                                LectureIntroduce(_homepageData.popularElement[2].lectureId));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: SizedBox(
                            width: imageWidthPosition,
                            child: Column(
                              children: [
                                Image.network(
                                  _homepageData.popularElement[3].lecturesImageUrl,
                                  width: imageWidthPosition,
                                  fit: BoxFit.cover,
                                ),
                                Text(_homepageData.popularElement[3].title)
                              ],
                            ),
                          ),
                          onTap: () {
                            TransferMap(context,
                                LectureIntroduce(_homepageData.popularElement[3].lectureId));
                          },
                        ),
                        InkWell(
                          child: SizedBox(
                            width: imageWidthPosition,
                            child: Column(
                              children: [
                                Image.network(
                                  _homepageData.popularElement[4].lecturesImageUrl,
                                  width: imageWidthPosition,
                                  fit: BoxFit.cover,
                                ),
                                Text(_homepageData.popularElement[4].title)
                              ],
                            ),
                          ),
                          onTap: () {
                            TransferMap(context,
                                LectureIntroduce(_homepageData.popularElement[4].lectureId));
                          },
                        ),
                        InkWell(
                          child: SizedBox(
                            width: imageWidthPosition,
                            child: Column(
                              children: [
                                Image.network(
                                  _homepageData.popularElement[5].lecturesImageUrl,
                                  width: imageWidthPosition,
                                  fit: BoxFit.cover,
                                ),
                                Text(_homepageData.popularElement[5].title)
                              ],
                            ),
                          ),
                          onTap: () {
                            TransferMap(context,
                                LectureIntroduce(_homepageData.popularElement[5].lectureId));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        ListTile(
                            title: const Text('커뮤니티'),
                            trailing: TextButton(
                              onPressed: () {
                                TransferMap(context, const CommunityPost());
                              },
                              child: const Text('더보기'),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: _homepageData.newPost.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    if (_homepageData.newPost[index].postType == 1) {
                                      TransferMap(context,
                                          LectureEvaluation(_homepageData.newPost[index].postId));
                                    } else if (_homepageData.newPost[index].postType == 2) {
                                      TransferMap(
                                          context, QnAPost(_homepageData.newPost[index].postId));
                                    }
                                  },
                                  child: ListTile(
                                    title: Text(_homepageData.newPost[index].postTitle),
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                    if (_homepageData.mainpageElement.isEmpty) const Text('failed'),
                  ],
                )
              : const Text('Loading...'),
        ));
  }

  Widget drawerBtn(String listName, int categoryId) {
    return TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  fullscreenDialog: true,
                  // builder: (BuildContext context) => LectureSearch(-1, listName)));
                  builder: (BuildContext context) => CategorySearch(categoryId)));
        },
        child: Text(listName));
  }

  ExpansionTile eachCategory(String categoryName, List<Widget> childWidget) {
    return ExpansionTile(
      title: Text(categoryName),
      initiallyExpanded: false,
      childrenPadding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      children: [
        ListView(
          primary: false,
          shrinkWrap: true,
          children: childWidget,
        )
      ],
    );
  }

  Container lectureButton() {
    return Container(
      padding: const EdgeInsets.all(3),
      //decoration: InputDecoration(border: OutlineInputBorder()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            _homepageData.popularElement[0].lecturesImageUrl,
            // height: imageHeightPosition,
            width: 300,
            fit: BoxFit.cover,
          ),
          Text(_homepageData.popularElement[0].title)
        ],
      ),
    );
  }

  Widget sliderWidget() {
    return CarouselSlider(
      items: imageList.asMap().entries.map((e) {
        return Builder(builder: (context) {
          return InkWell(
            child: Image.network(
              e.value,
              height: 200,
              fit: BoxFit.cover,
            ),
            onTap: () {
              TransferMap(
                  context, LectureIntroduce(_homepageData.mainpageElement[e.key].lectureId));
            },
          );
        });
      }).toList(),
      options: CarouselOptions(
          height: 300,
          viewportFraction: 1.0,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          onPageChanged: (index, reason) {
            setState(() {
              currentImage = index;
            });
          }),
      carouselController: carouselController,
    );
  }

  Widget sliderIndicator() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: imageList.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => carouselController.animateToPage(entry.key),
            child: Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            ),
          );
        }).toList(),
      ),
    );
  }
}
