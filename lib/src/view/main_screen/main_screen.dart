import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sms_to_sheet/src/bloc/bottom_sheet_bloc/bottom_sheet_bloc.dart';
import 'package:sms_to_sheet/src/bloc/main_bloc/main_bloc.dart';
import 'package:sms_to_sheet/src/bloc/main_bloc/main_event.dart';
import 'package:sms_to_sheet/src/bloc/main_bloc/main_state.dart';
import 'package:sms_to_sheet/src/core/constants/general_constants.dart';
import 'package:sms_to_sheet/src/core/util/enums.dart';
import 'package:sms_to_sheet/src/data/model/sms_model.dart';
import 'package:sms_to_sheet/src/data/repositories/sms_list_update_repo.dart';
import 'package:sms_to_sheet/src/data/repositories/sms_repo.dart';

import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'widgets/failure_or_noInternet_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainView extends StatelessWidget {
  MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    localization = AppLocalizations.of(context);

    return BlocProvider(
      create: (context) =>
          RepositoryProvider.of<MainBloc>(context)..add(MainStarted()),
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          MainBloc mainBloc = context.read<MainBloc>();
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: _mainAppbar(mainBloc, context),
            body: _mainBody(mainBloc, context),
          );
        },
      ),
    );
  }

  AppBar _mainAppbar(MainBloc mainBloc, BuildContext context) {
    return AppBar(
      title: Text(
        localization!.smsListWithoutDescription,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }

  Widget _mainBody(MainBloc mainBloc, BuildContext context) {
    late Widget result;
    switch (mainBloc.state.mainStateStatus) {
      case MainStateStatus.loading:
        result = _mainViewLoadingState();
        break;
      case MainStateStatus.success:
      case MainStateStatus.update:
        if (mainBloc.state.smsList.isNotEmpty) {
          result = _mainViewSuccessState(mainBloc);
        } else {
          result = _mainViewEmptyState(mainBloc, context);
        }
        break;
      case MainStateStatus.failure:
        result = _mainViewFailureState(mainBloc);
        break;
      case MainStateStatus.noInternet:
        result = _mainViewNoInternetState(mainBloc);
        break;
    }
    return result;
  }

  Widget _mainViewLoadingState() => const Center(
        child: CupertinoActivityIndicator(
          radius: 16,
        ),
      );

  Widget _mainViewSuccessState(MainBloc mainBloc) {
    return RefreshIndicator(
      onRefresh: () async {
        mainBloc.add(MainPullToRefresh());
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: mainBloc.state.smsList.length,
        itemBuilder: (context, index) {
          var sms = mainBloc.state.smsList[index];
          return _smsItem(context: context, sms: sms, mainBloc: mainBloc);
        },
      ),
    );
  }

  Widget _mainViewEmptyState(MainBloc mainBloc, BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        mainBloc.add(MainPullToRefresh());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Center(
            child: FailureOrNoInternetOrEmptyWidget(
              title: localization!.empty,
              buttonText: localization!.retry,
              voidCallback: null,
              child: SvgPicture.asset(
                "assets/images/no_data.svg",
                width: 180,
                height: 140,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _mainViewFailureState(MainBloc mainBloc) {
    return Center(
      child: SizedBox(
        height: 300,
        child: FailureOrNoInternetOrEmptyWidget(
          title: localization!.failure,
          buttonText: localization!.retry,
          voidCallback: () {
            mainBloc.add(MainRetry());
          },
          child: SvgPicture.asset(
            "assets/images/warning.svg",
            width: 120,
            height: 120,
          ),
        ),
      ),
    );
  }

  Widget _mainViewNoInternetState(MainBloc mainBloc) {
    return Center(
      child: SizedBox(
        height: 300,
        child: FailureOrNoInternetOrEmptyWidget(
          title: localization!.noInternet,
          buttonText: localization!.retry,
          voidCallback: () {
            mainBloc.add(MainRetry());
          },
          child: const Icon(
            Icons.wifi_off_outlined,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _smsItem(
      {required BuildContext context,
      required SmsModel sms,
      required MainBloc mainBloc}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "مبلغ ${sms.amount.toString()}",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                sms.jalaliDate!,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              )
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            "توضیحات:",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
          const SizedBox(
            height: 8,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: IconButton(
              splashRadius: 24,
              onPressed: () {
                showModalBottomSheet(
                  isDismissible: false,
                  isScrollControlled: true,
                  context: context,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(8))),
                  builder: (context) => _BottomSheetBody(
                    sms: sms,
                  ),
                );
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomSheetBody extends StatefulWidget {
  SmsModel sms;

  _BottomSheetBody({Key? key, required this.sms})
      : super(key: key);

  @override
  State<_BottomSheetBody> createState() => _BottomSheetBodyState();
}

class _BottomSheetBodyState extends State<_BottomSheetBody> {
  late BottomSheetBloc _bottomSheetBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomSheetBloc(
          smsRepo: RepositoryProvider.of<SmsRepo>(context),
          smsListUpdateRepo: RepositoryProvider.of<SmsListUpdateRepo>(context)),
      child: BlocConsumer<BottomSheetBloc, BottomSheetState>(
          listener: (context, state) {
        if (state.status == BottomSheetStateStatus.noInternet) {

          showTopSnackBar(
            context,
            CustomSnackBar.info(
              backgroundColor: Colors.white,
              textStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.black,
              ),
              message: localization!.noInternet,
              icon: Icon(
                Icons.wifi_off_outlined,
                size: 120,
                color: Colors.grey.shade100,
              ),
            ),
          );
        }
        if (state.status == BottomSheetStateStatus.failure) {
          showTopSnackBar(
            context,
            CustomSnackBar.error(
              backgroundColor: Colors.white,
              textStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.black,
              ),
              message: localization!.failure,
            ),
          );
        }
      }, builder: (context, state) {
        _bottomSheetBloc = context.read<BottomSheetBloc>();
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    localization!.add,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _bottomSheetBloc.controller.clear();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
            _descriptionTextField(context),
            _editButton(context, state)
          ],
        );
      }),
    );
  }

  Widget _descriptionTextField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          right: 16,
          left: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 8),
      child: TextField(
        minLines: 4,
        maxLines: 5,
        controller: _bottomSheetBloc.controller,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: localization!.hint,
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _editButton(BuildContext context, BottomSheetState state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4, right: 16, left: 16),
      child: Align(
        alignment: AlignmentDirectional.bottomEnd,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              primary: Colors.blue),
          onPressed: () {
            _bottomSheetBloc.add(BottomSheetEdited(
                sms: widget.sms,
                context: context,
                value: _bottomSheetBloc.controller.text));
          },
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: state.status == BottomSheetStateStatus.sending
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CupertinoActivityIndicator(
                        radius: 12,
                        color: Colors.white,
                      ),
                    )
                  : Text(localization!.save,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 16),),),
        ),
      ),
    );
  }


  SnackBar _snackBar(String content, Icon trailingIcon) {
    return SnackBar(
      content:
      Padding(
        padding: const EdgeInsets.all(8),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            content,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          trailingIcon,
        ]),
      ),
      backgroundColor: Colors.grey.shade300,
      elevation: 4,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
    );
  }
}
