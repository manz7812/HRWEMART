import 'package:es_drawer_controller/main.dart';
import 'package:flutter/material.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:index/pages/drawer_page/DrawAbout/drawer_aboutUS.dart';
import 'package:index/pages/drawer_page/DrawPoliciCom/drawer_companyPolicy.dart';
import 'package:index/pages/drawer_page/DrawJobWork/drawer_docJobWork.dart';
import 'package:index/pages/drawer_page/DrawNews/drawer_newsPublic.dart';
import 'package:index/pages/drawer_page/DrawQuoTaLa/drawer_quotaLA.dart';
import 'package:index/pages/widjet/singout.dart';
import 'package:ionicons/ionicons.dart';
import 'DrawDocDep/drawer_docdep.dart';
import 'DrawSalary/drawer_main_salary.dart';
import 'DrawSearchEm/drawer_main_Employee.dart';
import 'drawer_index.dart';
import 'DrawEmployee/drawer_employee.dart';
import 'drawer_main.dart';

enum eDrawerIndexHead {
  diDivider,
  diHome,
  diAboutUS,
  diEmployeedetail,
  diQuota_la,
  diTableManageTime,
  disalary,
  diMoreDocument,
  diSearchEmployee,
  diNews,
  diCompanyPolicy,
  diUnderPos,
  diExit,
}


// Now create a class for Navigation Drawer as below
class MainNavigation extends StatefulWidget {
  // This field is where you need to add your menu items { Ajmal }
  final List<ESDrawerItem<eDrawerIndexHead>> _cDrawerListHead =
  <ESDrawerItem<eDrawerIndexHead>>[
    const ESDrawerItem(
        type: eDrawerItemType.ditMenu,
        index: eDrawerIndexHead.diHome,
        labelName: 'หน้าหลัก',
        iconData: Icons.home),
    const ESDrawerItem(
        type: eDrawerItemType.ditLink,
        index: eDrawerIndexHead.diAboutUS,
        labelName: 'คำแนะนำ',
        iconData: Icons.help_outline_outlined),
    const ESDrawerItem(
        type: eDrawerItemType.ditLink,
        index: eDrawerIndexHead.diEmployeedetail,
        labelName: 'ข้อมูลพนักงาน',
        iconData: Icons.account_circle_rounded),
    const ESDrawerItem(
      type: eDrawerItemType.ditLink,
      index: eDrawerIndexHead.diQuota_la,
      labelName: 'โควต้าการลา',
      iconData: Icons.pending_actions_outlined,
    ),
    // const ESDrawerItem(
    //   type: eDrawerItemType.ditLink,
    //   index: eDrawerIndex.diTableManageTime,
    //   labelName: 'ตารางเข้าทำงาน',
    //   iconData: Icons.more_time_outlined,
    // ),
    const ESDrawerItem(
      type: eDrawerItemType.ditLink,
      index: eDrawerIndexHead.disalary,
      labelName: 'เงินเดือน',
      iconData: IcoFontIcons.money,
    ),
    const ESDrawerItem(
      type: eDrawerItemType.ditLink,
      index: eDrawerIndexHead.diNews,
      labelName: 'ประกาศข่าวสาร',
      iconData: IcoFontIcons.megaphone,
    ),
    const ESDrawerItem(
      type: eDrawerItemType.ditLink,
      index: eDrawerIndexHead.diCompanyPolicy,
      labelName: 'นโยบายบริษัท',
      iconData: Icons.receipt_long_outlined,
    ),
    const ESDrawerItem(
      type: eDrawerItemType.ditLink,
      index: eDrawerIndexHead.diSearchEmployee,
      labelName: 'ค้นหาพนักงาน',
      iconData: IcoFontIcons.searchUser,
    ),
    const ESDrawerItem(
      type: eDrawerItemType.ditLink,
      index: eDrawerIndexHead.diMoreDocument,
      labelName: 'เอกสารใบสมัคร',
      iconData: Ionicons.document_attach_outline,
    ),
    const ESDrawerItem(
      type: eDrawerItemType.ditMenu,
      index: eDrawerIndexHead.diUnderPos,
      labelName: 'เอกสารแผนก',
      iconData: Ionicons.document_outline,
    ),
    const ESDrawerItem(
        type: eDrawerItemType.ditDivider,
        index: eDrawerIndexHead.diDivider), // Add a divider here
    const ESDrawerItem(
      type: eDrawerItemType.ditLink,
      index: eDrawerIndexHead.diExit,
      labelName: 'ออกจากระบบ',
      iconData: Icons.exit_to_app_outlined,
    ),
  ];


  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  Widget screenView = const MainPagesDW();
  eDrawerIndexHead drawerIndexHead = eDrawerIndexHead.diHome;

  DateTime lastBackPressTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ESDrawerController<eDrawerIndexHead>(
      // assetLogo: 'images/2.jpg',
      // title: 'ธีรภัทร เจริญวงค์',
      // titleStyle: const TextStyle(
      //   fontFamily: 'Mitr',
      //   fontSize: 22,
      //   fontWeight: FontWeight.bold,
      //   color: Colors.black,
      //   decoration: TextDecoration.none,
      // ),
      // subTitle: 'IT Support',
      // subTitleStyle: const TextStyle(
      //   fontFamily: 'Mitr',
      //   fontSize: 18,
      //   fontWeight: FontWeight.bold,
      //   color: Colors.black,
      //   decoration: TextDecoration.none,
      // ),
      screenView: screenView,
      screenIndex: drawerIndexHead,
      drawerList: widget._cDrawerListHead,
      drawerWidth: MediaQuery.of(context).size.width * 0.75,
      // When user click on the menu, onDrawerCall is triggered
      onDrawerCall: (ESDrawerItem drawerItem) => _changeIndexHead(drawerItem),
    );
  }

  void _changeIndexHead(ESDrawerItem drawerItem) {
    // If user click on the same menu which is not marked as link/share then no need to create the same class again
    if (drawerItem.type == eDrawerItemType.ditMenu &&
        (drawerIndexHead == drawerItem.index || !mounted)) return;

    // Update new drawer index
    drawerIndexHead = drawerItem.index;
    switch (drawerIndexHead) {
      case eDrawerIndexHead.diHome:
        setState(() => screenView = const MainPagesDW());
        break;
      case eDrawerIndexHead.diAboutUS:
        setState(() => screenView = const AboutUsPage(title: 'คำแนะนำ',));
        break;
      case eDrawerIndexHead.diEmployeedetail:
        setState(() => screenView = const EmployeePage(title: 'ข้อมูลพนักงาน',));
        break;
      case eDrawerIndexHead.diQuota_la:
        setState(() => screenView = const QuotaLaPage(title: "โควต้าการลา"));
        break;
      case eDrawerIndexHead.disalary:
        setState(() => screenView = const ManinSalaryPage());
        break;
      case eDrawerIndexHead.diMoreDocument:
        setState(() => screenView = const DocJobWorkPage(title: "ใบสมัครงาน"));
        break;
      case eDrawerIndexHead.diSearchEmployee:
        setState(() => screenView = const MainEmployeePages());
        break;
      case eDrawerIndexHead.diNews:
        setState(() => screenView = const NewsPublicPage(title: "ข่าวสาร"));
        break;
      case eDrawerIndexHead.diCompanyPolicy:
        setState(() => screenView = const CompanyPolicyPage(title: "นโยบายบริษัท"));
        break;
      case eDrawerIndexHead.diUnderPos:
        setState(() => screenView = const DocDepPage());
        break;
      case eDrawerIndexHead.diExit:
        // setState(() => Navigator.of(context, rootNavigator: true).pop(context));
        signOut(context);
      // setState(() => signOut(context)
      //     // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyApp(),), (route) => route.isFirst);
      // );
        break;
      default:
        break;
    }
  }

}