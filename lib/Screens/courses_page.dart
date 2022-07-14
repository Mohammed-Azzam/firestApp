import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_and_success/StateManagement/blocs/login_cubit.dart';
import 'package:speed_and_success/Widgets/posts/category_tile.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5),
      child: BlocConsumer<LoginCubit, LoginStates>(
          listener: (BuildContext context, LoginStates state) {},
          builder: (BuildContext context, LoginStates state) {
            if (state is LoginStarted) {
              return Center(child: CircularProgressIndicator());
            } else if (state is LoginFinishedSuccessfully) {
              return ListView.builder(
                  itemCount: state.catNames.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CategoryTile(
                      imageApiUrl: (state.catUrls[index] != '')
                          ? state.catUrls[index]
                          : 'https://speedandsuccessphone.website/draft/old/wp-content/uploads/2021/04/E-Learning.jpg',
                      excerpt: '',
                      instructorName: state.catDrs[index],
                      categoryName: state.catDescriptiveNames[index],
                      categoryNum: state.catNumbers[index],
                    );
                  });
            } else {
              return Center(
                child: Container(
                  color: Colors.transparent,
                  height: 100,
                  child: Text('Loading Courses ..'),
                ),
              );
            }
          }),
    );
  }
}
