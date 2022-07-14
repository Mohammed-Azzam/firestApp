import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_and_success/Widgets/common/dialogs.dart';
import 'package:speed_and_success/Widgets/common/rounded_button.dart';
import 'package:speed_and_success/constants.dart';
import 'package:speed_and_success/flutter_wordpress-0.2.1/flutter_wordpress.dart';
import 'package:speed_and_success/flutter_wordpress-0.2.1/flutter_wordpress.dart'
    as wp;

part 'visit_states.dart';

class VisitCubit extends Cubit<VisitStates> {
  VisitCubit() : super(VisitStateInitial());

  Map<String, List<String>> doctorsMap = {};
  String htmlString='';

  static VisitCubit instance(BuildContext context) => BlocProvider.of(context);

  Future<bool> internetChecks(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      Dialogs().showErrorDialog(context,
          errorStatement: 'please, check the internet connectivity');
      return false;
    }
  }

  void init() {
    doctorsMap = {};
  }

  Future<void> getDoctorsMap(BuildContext context) async {
    bool internetIsConnected = await internetChecks(context);
    if (internetIsConnected) {
      emit(VisitStarted());

      List<Category> catList = await myWordPress.fetchCategories(
        params: ParamsCategoryList(
            context: WordPressContext.embed,
            orderBy: CategoryTagOrderBy.slug,
            perPage: 100),
      );

      doctorsMap = {};
      catList.forEach((element) {
        final drName = element.slug;
        final courseName = element.name;
        if (!doctorsMap.containsKey(drName)) {
          print('new dr added: [$drName] with course: [$courseName]');
          doctorsMap[drName] = [courseName];
        } else {
          print(
              'dr [$drName] is added before, add new course to his list: [$courseName]');
          doctorsMap[drName]!.add(courseName);
        }
      });
      emit(Visit2FinishedSuccessfully(doctorsMap: doctorsMap));
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Network Error'),
              content: Text('Please check your network adaptor'),
              actions: [
                RoundedButton(
                  text: 'Ok',
                  heightRatio: 0.05,
                  press: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  Future<String> getHtmlContent() async {
    print('start');
    List<wp.Page> list = await myWordPress.fetchPages(
        params: ParamsPageList(includePageIDs: [2968]));
    wp.Page p = list[0];
    print(list);
    htmlString = p.content!.rendered!;
    emit(Visit3FinishedSuccessfully(htmlString: htmlString));
    print(htmlString);
    return htmlString;
  }
}
