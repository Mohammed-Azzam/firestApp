import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:speed_and_success/StateManagement/blocs/visit_cubit.dart';

class VisitScreen3 extends StatelessWidget {
  const VisitScreen3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visit Screen'),
      ),
      body: BlocConsumer<VisitCubit, VisitStates>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is Visit3FinishedSuccessfully) {
              return Html(
                data: state.htmlString.toString(),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
