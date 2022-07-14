
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speed_and_success/Screens/specific_course_page.dart';

class CategoryTile extends StatelessWidget {
  final String imageApiUrl, categoryName, excerpt, instructorName;
  final int categoryNum;

  CategoryTile(
      {required this.imageApiUrl,
      required this.categoryName,
      required this.categoryNum,
      required this.excerpt,
      required this.instructorName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (imageApiUrl != "") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SpecificCoursePage(
                categoryNum: categoryNum,
                categoryName: categoryName,
                instructorName: instructorName,
              ),
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Container(
                      height: 120,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          height: 120,
                          width: 200,
                          fit: BoxFit.cover,
                          imageUrl: imageApiUrl,
                          placeholder: (context, s) => Container(
                            height: 120,
                            width: 200,
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        height: 120,
                        // color: Colors.red,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Expanded(
                              child: FittedBox(
                                child: Text(
                                  categoryName,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Expanded(
                              child: FittedBox(
                                child: Text(
                                  'Instructor:\n  $instructorName',
                                  maxLines: 3,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 8),
              // Text(
              //   categoryName,
              //   style: TextStyle(
              //     fontSize: 20,
              //   ),
              // ),
              if (excerpt.length > 1)
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Text((excerpt.length > 250) ? excerpt.substring(0, 250) : excerpt),
                ),
              // Text(widget.desc)
            ],
          ),
        ),
      ),
    );
  }
}
