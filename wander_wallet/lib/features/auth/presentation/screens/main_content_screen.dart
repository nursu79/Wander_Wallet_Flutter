import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/widgets/bottom_nav_bar.dart';
import 'package:wander_wallet/core/widgets/buttons.dart';
import 'package:wander_wallet/core/widgets/custom_app_bar.dart';
import 'package:wander_wallet/core/widgets/texts.dart';
import 'package:wander_wallet/features/auth/presentation/providers/main_content_screen_provider.dart';

class MainContentScreen extends ConsumerStatefulWidget {
  const MainContentScreen({super.key});

  @override
  ConsumerState<MainContentScreen> createState() => _MainContentScreenState();
}

class _MainContentScreenState extends ConsumerState<MainContentScreen> {
  @override
  void initState() {
    super.initState();

    ref.listenManual(mainContentProvider, (prev, next) {
      next.when(
        data: (data) {},
        loading: () {},
        error: (error, stack) {
          if (error is MainContentError && error.loggedOut) {
            Navigator.pushNamed(context, '/login');
          }
        }
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<MainContentScreenState> state = ref.watch(mainContentProvider);

    return state.when(
      data: (data) {
        return Scaffold(
          appBar: CustomAppBar(user: (data as MainContentSuccess).userPayload.user),
          bottomNavigationBar: BottomNavBar(),
        );
      },
      error: (error, stack) {
        if (error is MainContentError && error.loggedOut) {
          return Center(
            child: Text("You are logged out. You'll be redirected to login"),
          );
        } else {
          return Center(
            child: Column(
              spacing: 16,
              children: [
                SmallErrorText(text: (error as MainContentError).messageError.message),
                RectangularButton(
                  onPressed: () {
                    ref.read(mainContentProvider.notifier).refresh();
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
