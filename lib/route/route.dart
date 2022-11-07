//import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:magictank/aboutus_page.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/apptools/appsetting_page.dart';
import 'package:magictank/apptools/getzip_page.dart';
import 'package:magictank/apptools/hidepage_page.dart';
import 'package:magictank/apptools/speek_page.dart';
import 'package:magictank/cncpage/bluecmd/selecncbt4_page.dart';
import 'package:magictank/cncpage/cnctools/cncachive_page.dart';
import 'package:magictank/cncpage/cnctools/cncsetting_page.dart';
import 'package:magictank/cncpage/cnctools/speedset_page.dart';
import 'package:magictank/cncpage/cnctools/toolsshow_page.dart';
import 'package:magictank/cncpage/cncworking_page.dart';
import 'package:magictank/cncpage/copykey/copykeylist_page.dart';
import 'package:magictank/cncpage/copykey/copykeywork_page.dart';
import 'package:magictank/cncpage/cutkey/allkeylist_page.dart';
import 'package:magictank/cncpage/cutkey/cardata_page.dart';
import 'package:magictank/cncpage/cutkey/carmodel_page.dart';
import 'package:magictank/cncpage/cutkey/gifshow_page.dart';
import 'package:magictank/cncpage/cutkey/highsearch_page.dart';
import 'package:magictank/cncpage/cutkey/nonconductive_page.dart';
import 'package:magictank/cncpage/cutkey/searchkey_page.dart';
import 'package:magictank/cncpage/cutkey/selekeydatabase_page.dart';
import 'package:magictank/cncpage/diykey/chanagekeydata_page.dart';
import 'package:magictank/cncpage/diykey/diy_page.dart';
import 'package:magictank/cncpage/diykey/diykey_page.dart';
import 'package:magictank/cncpage/diykey/diykeymarket_page.dart';
import 'package:magictank/cncpage/diykey/diykeystep_page.dart';
import 'package:magictank/cncpage/diykey/photodiy_page.dart';
import 'package:magictank/cncpage/keymode/changemodeldata_page.dart';
import 'package:magictank/cncpage/keymode/cutmodelready_page.dart';
import 'package:magictank/cncpage/keymode/diymodel_page.dart';

import 'package:magictank/cncpage/getphotokey/discoverkey_page.dart';
import 'package:magictank/cncpage/history_page.dart';
import 'package:magictank/cncpage/instacode/alllost_page.dart';
import 'package:magictank/cncpage/keymode/clampmodel_page.dart';
import 'package:magictank/cncpage/keymode/cutkeymodel_page.dart';
import 'package:magictank/cncpage/keymode/diymodelstep_page.dart';

import 'package:magictank/cncpage/keymode/keymodel_page.dart';
import 'package:magictank/cncpage/keymode/modelist_page.dart';
import 'package:magictank/cncpage/keymode/selediymodel_page.dart';
import 'package:magictank/cncpage/testkey/testkey_page.dart';
import 'package:magictank/cncpage/unlocktools/unlocktoolslist_page.dart';
import 'package:magictank/cncpage/userstar/myclient_page.dart';
import 'package:magictank/cncpage/userstar/myclientedit_page.dart';
import 'package:magictank/cncpage/userstar/mystar_page.dart';
import 'package:magictank/cncpage/cutkey/openclamp_page.dart';
import 'package:magictank/drawer_page.dart';
import 'package:magictank/cncpage/instacode/getcodelist_page.dart';
import 'package:magictank/cncpage/instacode/inputcde_page.dart';
import 'package:magictank/cncpage/cutkey/keydata_page.dart';
import 'package:magictank/cncpage/cutkey/showkey_page.dart';
import 'package:magictank/forgetpwd_page.dart';
import 'package:magictank/home4_page.dart';
import 'package:magictank/login_page.dart';
import 'package:magictank/magicclone/bluetooth/mccloneselebt_page.dart';
import 'package:magictank/magicclone/copychip/copychip_page.dart';
import 'package:magictank/magicclone/copychip/copychiplist_page.dart';
import 'package:magictank/magicclone/copychip/copychipstep_page.dart';
import 'package:magictank/magicclone/copychip/edigchip_page.dart';
import 'package:magictank/magicclone/copychip/editicchip_page.dart';
import 'package:magictank/magicclone/copychip/editshow_page.dart';
import 'package:magictank/magicclone/creatchip/createchip_page.dart';
import 'package:magictank/magicclone/creatchip/createchiphandle_page.dart';
import 'package:magictank/magicclone/creatchip/createchiplist_page.dart';
import 'package:magictank/magicclone/firecheck/firecheck_page.dart';
import 'package:magictank/magicclone/mccloneinf_page.dart';
import 'package:magictank/magicclone/superchip/setsuperchip_page.dart';
import 'package:magictank/magicclone/updata/mcupgradelist_page.dart';
import 'package:magictank/magicclone/updata/upgradecenter_page.dart';
import 'package:magictank/magicsmart/bluetooth/mscloneselebt_page.dart';
import 'package:magictank/magicsmart/creartsmart/createsmart_page.dart';
import 'package:magictank/magicsmart/creartsmart/createsmarthandle_page.dart';
import 'package:magictank/magicsmart/creartsmart/createsmartlist_page.dart';
import 'package:magictank/magicsmart/updata/smartupgradecenter_page.dart';
import 'package:magictank/magicsmart/updata/smartupgradelist_page.dart';
import 'package:magictank/morepage/devt_page.dart';
import 'package:magictank/morepage/gettoken_page.dart';

import 'package:magictank/morepage/news_page.dart';
import 'package:magictank/morepage/qrcode_page.dart';
import 'package:magictank/morepage/videotutorial_page.dart';
import 'package:magictank/privacy_page.dart';
import 'package:magictank/register_page.dart';

import 'package:magictank/apptools/languagepage.dart';

import 'package:magictank/cncpage/cnctools/toolswait_page.dart';
import 'package:magictank/cncpage/upgrade/upgrade_page.dart';
import 'package:magictank/cncpage/upgrade/upgradelist_page.dart';
import 'package:magictank/usercenter_page.dart';
import '../ad_page.dart';
import '../cncpage/cutkey/searchresult_page.dart';
import '../cncpage/diykey/smartdiy_page.dart';
import '../cncpage/keymode/diymodelmarket_page.dart';
import '../cncpage/keymode/smartdiymodelstep_page.dart';
import '../cncpage/testkey/testkeylist_page.dart';
import '../cncpage/unlocktools/unlocktools_page.dart';
import '../cncpage/upgrade/upgradelcdlist_page.dart';

import '../morepage/feedback_page.dart';
import '../morepage/videoplayer_page.dart';
import '../userinfo_page.dart';

final routes = {
  '/': (context, {arguments}) => const Tips4Page(),
  '/cardata': (context, {arguments}) => CarDataPage(arguments),
  '/drawer': (context, {arguments}) => DrawerPage(arguments),
  '/keydata': (context, {arguments}) => KeyDataPage(arguments),
  '/carmodel': (context, {arguments}) => CarModelPage(arguments),
  '/selecnc': (context, {arguments}) => SeleCncBT4Page(arguments),
  '/changekeydata': (context, {arguments}) => ChangeKeyDataPage(arguments),
  '/changemodeldata': (context, {arguments}) => ChangeModelDataPage(arguments),
  '/selemc': (context, {arguments}) => const SeleMCPage(),
  '/selems': (context, {arguments}) => const SeleMSPage(),
  '/showprivacy': (context, {arguments}) => const Privacy(),
  '/keyshow': (context, {arguments}) => ShowKeyPage(arguments),
  '/alllost': (context, {arguments}) => const AllLostPage(),
  '/inputcode': (context, {arguments}) => InputCodePage(arguments),
  '/getcodelist': (context, {arguments}) => GetCodeListPage(arguments),
  '/upgrade': (context, {arguments}) => const UpgradePage(),
  '/cncsetting': (context, {arguments}) => const CnCSettingPage(),
  '/speedset': (context, {arguments}) => const SpeedSetPage(),
  '/selelanguage': (context, {arguments}) => const LanguagePage(),
  '/toolswait': (context, {arguments}) => ToolsWaitPage(
        arguments,
      ),
  '/upgradelist': (context, {arguments}) => const UpgradeListPage(),
  '/upgradelcdlist': (context, {arguments}) => const UpgradeLcdListPage(),
  '/copykey': (context, {arguments}) => const CopyKeyPage(),
  '/copykeywork': (context, {arguments}) => const CopyKeyWorkPage(),
  '/openclamp': (context, {arguments}) => OpenClampPage(arguments),
  '/mycollection': (context, {arguments}) => const MyCollectionPage(),
  '/myclient': (context, {arguments}) => const ClientPage(),
  '/myclientedit': (context, {arguments}) => MyClientEdit(arguments),
  '/keymodel': (context, {arguments}) => const KeyModelPage(),
  '/diykey': (context, {arguments}) => const DiyKeyPage(),
  '/diykeystep': (context, {arguments}) => const DiyKeyStepPage(),
  '/login': (context, {arguments}) => const LoginPage(),
  '/usercenter': (context, {arguments}) => const UserCenterPage(),
  '/userinfo': (context, {arguments}) => const UserInfoPage(),
  '/discoverkey': (context, {arguments}) => DiscoverKeyPage(arguments),
  '/cncworking': (context, {arguments}) => const CnCWorkingPage(),
  '/register': (context, {arguments}) => const RegisterPage(),
  '/forgetpwd': (context, {arguments}) => const ForgetPwdPage(),
  '/history': (context, {arguments}) => const HistoryPage(),
  '/getzip': (context, {arguments}) => const GetZipPage(),
  '/toolsshow': (context, {arguments}) => TooolsShowPage(
        arguments,
      ),
  '/diy': (context, {arguments}) => const DiyPage(),
  '/photodiy': (context, {arguments}) => const PhotoDiyPage(),
  '/diykeymarket': (context, {arguments}) => const DiyKeyMarketPage(),
  '/diymodelmarket': (context, {arguments}) => const DiyModelMarketPage(),
  '/news': (context, {arguments}) => const NewsPage(),
  '/modellist': (context, {arguments}) => ModelListPage(
        arguments,
      ),
  '/clampmodel': (context, {arguments}) => ClampModelPage(
        arguments,
      ),
  '/cutkeymodel': (context, {arguments}) => const CutKeyModelPage(),
  '/diymodel': (context, {arguments}) => const DiyModelPage(),
  '/diymodelstep': (context, {arguments}) => const DiyModelStepPage(),
  '/smartdiymodelstep': (context, {arguments}) => const SmartDiyModelStepPage(),
  '/adpage': (context, {arguments}) => const AdPage(),
  '/allkeydata': (context, {arguments}) => const AllKeyDataPage(),
  '/nonconductive': (context, {arguments}) => const NonConductivePage(),
  '/appsetting': (context, {arguments}) => const AppSettingPage(),
  '/unlocktools': (context, {arguments}) => UnlockTools(arguments),
  '/unlocktoolslist': (context, {arguments}) => const UnlockToolsList(),
  '/searchkey': (context, {arguments}) => SearchKeyPage(
        arguments,
      ),
  '/smartdiy': (context, {arguments}) => const SmartDiyPage(),
  '/selekeydatabase': (context, {arguments}) => const SeleKeyDataBasePage(),
  '/testkey': (context, {arguments}) => const TestKeyPage(),
  '/testkeylist': (context, {arguments}) => TestKeyListPage(
        arguments,
      ),
  '/searchresult': (context, {arguments}) => SearchResult(arguments),
  '/highsearch': (context, {arguments}) => const HighSearchPage(),
  '/selediymodel': (context, {arguments}) => const SeleDiyModelPage(),
  '/gifshow': (context, {arguments}) => GifShowPage(arguments),
  '/cutmodelready': (context, {arguments}) => CutModelReadyPage(arguments),
  '/achive': (context, {arguments}) => const AchivePage(),
  '/copychip': (context, {arguments}) => const CopyChipPage(),
  '/editchip': (context, {arguments}) => EdigChipPage(arguments: arguments),
  '/editicchip': (context, {arguments}) => const EditIcChipPage(),
  '/editshow': (context, {arguments}) => const EditShow(),
  '/copychipinstructions': (context, {arguments}) =>
      CopyChipInstructionsPage(arguments: arguments),
  '/copychiplist': (context, {arguments}) => const CopyChipListPage(),
  '/setsuperchip': (context, {arguments}) => const SetSuperChipPage(),
  '/mcupgradelist': (context, {arguments}) => const McUpgradeListPage(),
  '/smartupgradelist': (context, {arguments}) => const SmartUpgradeListPage(),
  //'/login': (context, {arguments}) => const LoginPage(),
  //'/usercenter': (context, {arguments}) => const UserCenterPage(),
  // '/userinfo': (context, {arguments}) => const UserInfoPage(),
  '/createchip': (context, {arguments}) => const CreateChipPage(),
  '/createchiplist': (context, {arguments}) =>
      CreateChipListPage(arguments: arguments),
  '/createchiphandle': (context, {arguments}) =>
      CreateChipHandlePage(arguments: arguments),
  '/createsmarthandle': (context, {arguments}) =>
      CreateSmartHandlePage(arguments: arguments),
  // '/appsetting': (context, {arguments}) => const AppSettingPage(),
  '/createsmart': (context, {arguments}) => const CreateSmartPage(),
  '/createsmartlist': (context, {arguments}) =>
      CreateSmartListPage(arguments: arguments),
  '/upgradecenter': (context, {arguments}) => const UpgradeCenterPage(),
  '/smartupgradecenter': (context, {arguments}) =>
      const SmartUpgradeCenterPage(),
  '/speek': (context, {arguments}) => const SpeekPage(),
  '/hidepage': (context, {arguments}) => const HidePagePage(),
  '/mccloneinf': (context, {arguments}) => const McCloneInf(),
  '/firecheck': (context, {arguments}) => const FireCheckPage(),
  '/gettoken': (context, {arguments}) => const GetTokenPage(),
  '/qrcode': (context, {arguments}) => const QRViewExample(),
  '/aboutus': (context, {arguments}) => const AboutUSPage(),
  '/videotutorial': (context, {arguments}) => const VideoTutorialPage(),
  '/devt': (context, {arguments}) => const DEVTPage(),
  '/feedback': (context, {arguments}) => const FeedBackPage(),
  '/videotutorial': (context, {arguments}) => const VideoTutorialPage(),
  '/videoplayer': (context, {arguments}) => VideoPlayerPage(arguments),
  '/videolist': (context, {arguments}) => VideoListPage(arguments),
  // '/firstpage': (context, {arguments}) => const FirstPagePage(),
};
// var onGenerateRoute = (RouteSettings settings) {
//   ////print(settings.name);
//   final String? name = settings.name;
//   final Function? pageContentBuilder = routes[name];
//   if (pageContentBuilder != null) {
//     if (settings.arguments != null) {
//       final Route route = MaterialPageRoute(
//           builder: (context) =>
//               pageContentBuilder(context, arguments: settings.arguments));
//       return route;
//     } else {
//       final Route route =
//           MaterialPageRoute(builder: (context) => pageContentBuilder(context));
//       return route;
//     }
//   }
// };

class FadeRoute extends PageRoute {
  FadeRoute({
    this.barrierColor,
    this.barrierLabel,
    required this.builder,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.opaque = true,
    this.barrierDismissible = false,
    this.maintainState = true,
  });

  final WidgetBuilder builder;

  @override
  final Duration transitionDuration;

  @override
  final bool opaque;

  @override
  final bool barrierDismissible;

  @override
  final Color? barrierColor;

  @override
  final String? barrierLabel;

  @override
  final bool maintainState;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      builder(context);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: builder(context),
    );
  }
}
