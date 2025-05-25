import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/widgets/bottom_nav_bar.dart';
import 'package:wander_wallet/core/widgets/buttons.dart';
import 'package:wander_wallet/core/widgets/custom_app_bar.dart';
import 'package:wander_wallet/core/widgets/texts.dart';
import 'package:wander_wallet/features/dashboard/navigation/user_dashboard_navigator.dart';
import '../providers/user_dashboard_provider.dart';

class UserDashboard extends ConsumerStatefulWidget {
  const UserDashboard({super.key});

  @override
  ConsumerState<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends ConsumerState<UserDashboard> {
  @override
  void initState() {
    super.initState();

    ref.listenManual(userDashBoardProvider, (prev, next) {
      next.when(
        data: (data) {},
        loading: () {},
        error: (error, stack) {
          if (error is UserDashBoardError && error.loggedOut) {
            Navigator.pushNamed(context, '/login');
          }
        }
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<UserDashBoardScreenState> state = ref.watch(userDashBoardProvider);

    return state.when(
      data: (data) {
        return Scaffold(
          appBar: CustomAppBar(user: (data as UserDashBoardSuccess).userPayload.user),
          bottomNavigationBar: BottomNavBar(),
          body: UserDashboardNavigator()
        );
      },
      error: (error, stack) {
        if (error is UserDashBoardError && error.loggedOut) {
          return Center(
            child: Text("You are logged out. You'll be redirected to login"),
          );
        } else {
          return Center(
            child: Column(
              spacing: 16,
              children: [
                SmallErrorText(text: (error as UserDashBoardError).messageError.message),
                RectangularButton(
                  onPressed: () {
                    ref.read(userDashBoardProvider.notifier).refresh();
                  },
                  text: 'Retry'
                )
              ],
            ),
          );
        }
      },
      loading: () => Center(
        child: CircularProgressIndicator()
      )
    );
  }
}
