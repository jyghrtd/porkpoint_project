import 'package:flutter/material.dart';
import 'package:porkpoint_project/DataBase/categorysearchdata.dart';
import 'package:porkpoint_project/frequentfunc.dart';
import 'package:porkpoint_project/introduce.dart';

class CategorySearch extends StatefulWidget {
  final int categoryId; //-1일 경우 모든 카테고리에서 검색
  //final String searchWord;
  const CategorySearch(this.categoryId, {super.key});
  // const LectureSearch(this.categoryId, /*this.searchWord,*/ {super.key});

  @override
  State<CategorySearch> createState() => _CategorySearchState();
}

class _CategorySearchState extends State<CategorySearch> {
  // CategorySearch categorySearch = CategorySearch(code: 0, lecture: []);
  CategorySort categorySort = CategorySort(code: 0, lecture: []);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CategorySearchData.getInfo(widget.categoryId).then((value) {
      setState(() {
        categorySort = value;
      });
    });

    print(categorySort.code);
  }

  @override
  Widget build(BuildContext context) {
    int nowCategory = widget.categoryId;

    return Scaffold(
        appBar: AppBarDefault("카테고리별 / 검색 결과별 목록"),
        body: categorySort.lecture.isNotEmpty
            ? ListView(
                children: [
                  ListView.builder(
                      padding: const EdgeInsets.all(10),
                      shrinkWrap: true,
                      itemCount: categorySort.lecture.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            TransferMap(
                                context, LectureIntroduce(categorySort.lecture[index].lectureId));
                          },
                          child: ListTile(
                            leading: Image.network(categorySort.lecture[index].lecturesImageUrl),
                            title: Text(categorySort.lecture[index].title),
                            subtitle: Text(
                              categorySort.lecture[index].description,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      })
                ],
              )
            : const Text('검색 결과가 존재하지 않습니다.'));
  }
}



//검색 기능용 row
                  // Row( //검색 기능을 따로 나눌지도 모름
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Flexible(
                  //       flex: 1,
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(7.0),
                  //         child: TextField(
                  //           decoration: InputDecoration(
                  //             fillColor: Colors.white,
                  //             filled: true,
                  //             contentPadding:
                  //                 const EdgeInsets.symmetric(horizontal: 16),
                  //             enabledBorder: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.circular(5)),
                  //             hintText: "검색어를 입력해 주세요",
                  //             //labelText: nowText
                  //           ),
                  //           controller: tec,
                  //         ),
                  //       ),
                  //     ),
                  //     IconButton(
                  //         onPressed: () {
                  //           TransferMap(
                  //               context,
                  //               LectureSearch(
                  //                 nowCategory,
                  //                 //tec.text
                  //               ));
                  //         },
                  //         icon: const Icon(Icons.search)), //onPressed
                  //   ],
                  // ),