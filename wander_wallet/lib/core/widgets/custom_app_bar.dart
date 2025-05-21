import 'package:flutter/material.dart';
import 'package:wander_wallet/core/constants.dart';
import '../../features/auth/data/models.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final User user;
  final double height;
  const CustomAppBar({
    super.key,
    required this.user,
    this.height = kToolbarHeight + 100
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
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
            Text(
              'Hi ${user.username.split(' ')[0]} \uD83D\uDC4B',
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleSmall?.fontSize,
                color: Theme.of(context).colorScheme.onPrimary
              )
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
                        Navigator.pushNamed(context, '/notifications');
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