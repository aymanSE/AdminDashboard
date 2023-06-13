import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../dashboard/SysDetails.dart';
import '../../dashboard/components/reqOrg.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../dashboard/reqdashboard_screen.dart';
import '../main_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Organizers List",
            svgSrc: "assets/icons/menu_dashboard.svg",
            disabled:true,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(),
                ),
              );
            },
          ),
          DrawerListTile(
            title: "Requests",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                   backgroundColor: Colors.transparent,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Container(
                      padding: EdgeInsets.zero,
                      child: reqDashboardScreen(),
                    ),
                  );
                },
              );
            },
          ),
          DrawerListTile(
              title: "General Statistics",
              svgSrc: "assets/icons/menu_task.svg",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Details(),
                  ),
                );
              }),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.press,
    this.disabled = false, // Add a disabled flag
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback? press;
  final bool disabled; // Add a disabled flag

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: disabled ? null : press, // Disable the onTap if disabled is true
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(
          disabled ? Colors.grey : Colors.white54, // Apply a different color when disabled
          BlendMode.srcIn,
        ),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: disabled ? Colors.grey : Colors.white54, // Apply a different color when disabled
        ),
      ),
    );
  }


}
