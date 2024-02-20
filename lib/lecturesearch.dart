import 'package:flutter/material.dart';
import 'package:porkpoint_project/DataBase/lecturesearchdata.dart';
import 'package:porkpoint_project/frequentfunc.dart';
import 'package:porkpoint_project/introduce.dart';

class LectureSearch extends StatefulWidget {
  final String searchWord;
  const LectureSearch(this.searchWord, {super.key});

  @override
  State<LectureSearch> createState() => _LectureSearchState();
}

class _LectureSearchState extends State<LectureSearch> {
  LecturesSearch lecturesSearch = LecturesSearch(code: 0, lecture: []);
  late String actualSearchWord;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String actualSearchWord = Uri.encodeQueryComponent('%${widget.searchWord}%');
    print(actualSearchWord.toString());
    LecturesSearchData.getInfo(actualSearchWord).then((value) {
      setState(() {
        lecturesSearch = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String nowText = widget.searchWord;
    TextEditingController tec = TextEditingController(text: nowText);

    print('search: $lecturesSearch.code');

    return Scaffold(
        appBar: AppBarDefault("카테고리별 / 검색 결과별 목록"),
        body: lecturesSearch.lecture.isNotEmpty
            ? ListView(
                children: [
                  Row(
                    //검색 기능을 따로 나눌지도 모름
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: TextField(
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                              enabledBorder:
                                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                              hintText: "검색어를 입력해 주세요",
                            ),
                            controller: tec,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => LectureSearch(tec.text)));
                          },
                          icon: const Icon(Icons.search)), //onPressed
                    ],
                  ),
                  ListView.builder(
                      padding: const EdgeInsets.all(10),
                      shrinkWrap: true,
                      primary: false,
                      itemCount: lecturesSearch.lecture.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            print(lecturesSearch.lecture[index].lectureId);
                            TransferMap(
                                context, LectureIntroduce(lecturesSearch.lecture[index].lectureId));
                          },
                          child: ListTile(
                            leading: Image.network(lecturesSearch.lecture[index].lecturesImageUrl),
                            title: Text(lecturesSearch.lecture[index].title),
                            subtitle: Text(
                              lecturesSearch.lecture[index].description,
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
