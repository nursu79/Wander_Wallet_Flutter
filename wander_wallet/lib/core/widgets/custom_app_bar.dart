import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/constants/constants.dart';
import 'package:wander_wallet/core/di/providers.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/features/notifications/presentation/providers/notifications_provider.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final User user;
  final double height;

  const CustomAppBar({ super.key, required this.user, this.height = kToolbarHeight + 100 });


  @override
  Size get preferredSize => Size.fromHeight(height);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final innerNavigator = ref.watch(innerNavigatorKeyProvider);
    final title = ref.watch(screenTitleProvider);
  
    return Container(
      height: preferredSize.height,
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        color: Theme.of(context).colorScheme.primary
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi ${user.username.split(' ')[0]} \uD83D\uDC4B',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleSmall?.fontSize,
                    color: Theme.of(context).colorScheme.onPrimary
                  )
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                  spacing: 8,
                  children: [
                    if (title != 'Trips') 
                      IconButton(
                        onPressed: () {
                          innerNavigator.currentState?.pop();
                        },
                        icon: Icon(Icons.arrow_back), color: Theme.of(context).colorScheme.onPrimary
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                          color: Theme.of(context).colorScheme.onPrimary
                        )
                      )
                    ],
                  ),
                )
              ],
            ),
            Row(          
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset('images/topbar_image.png', fit: BoxFit.cover),
                SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: (user.avatarUrl != null) 
                        ? NetworkImage('$baseUrl/userAvatars/${user.avatarUrl}') 
                        : AssetImage('images/default_avatar.jpg'),
                    ),
                    IconButton(
                      onPressed: () {
                        ref.invalidate(notificationsScreenProvider);
                        innerNavigator.currentState?.pushNamed('/notifications');
                      },
                      color: Theme.of(context).colorScheme.onPrimary,
                      icon: Icon(
                        Icons.notifications
                      )
                    )
                  ]
                )
              ],
            ),
          ],
        )
      )
    );
  }
}

// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final User user;
//   final String title;
//   final double height;
//   final VoidCallback onNotificationsClick;
//   const CustomAppBar({
//     super.key,
//     required this.user,
//     required this.title,
//     this.height = kToolbarHeight + 100,
//     required this.onNotificationsClick
//   });

//   @override
//   Size get preferredSize => Size.fromHeight(height);

//   @override
//   Widget build(BuildContext context) {
//     print(title);
//     return Container(
//       height: preferredSize.height,
//       padding: EdgeInsets.only(left: 20, right: 20, top: 20),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
//         color: Theme.of(context).colorScheme.primary
//       ),
//       child: SafeArea(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'Hi ${user.username.split(' ')[0]} \uD83D\uDC4B',
//               style: TextStyle(
//                 fontSize: Theme.of(context).textTheme.titleSmall?.fontSize,
//                 color: Theme.of(context).colorScheme.onPrimary
//               )
//             ),
//             Row(          
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Image.asset('images/topbar_image.png', fit: BoxFit.cover),
//                 SizedBox(width: 8),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     CircleAvatar(
//                       radius: 24,
//                       backgroundImage: (user.avatarUrl != null) 
//                         ? NetworkImage('$baseUrl/userAvatars/${user.avatarUrl}') 
//                         : AssetImage('images/default_avatar.jpg'),
//                     ),
//                     IconButton(
//                       onPressed: onNotificationsClick,
//                       color: Theme.of(context).colorScheme.onPrimary,
//                       icon: Icon(
//                         Icons.notifications
//                       )
//                     )
//                   ]
//                 )
//               ],
//             ),
//           ],
//         )
//       )
//     );
//   }
// }