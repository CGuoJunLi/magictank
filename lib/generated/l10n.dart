// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `cnc page`
  String get cncmainpage {
    return Intl.message(
      'cnc page',
      name: 'cncmainpage',
      desc: '',
      args: [],
    );
  }

  /// `cutter`
  String get xd {
    return Intl.message(
      'cutter',
      name: 'xd',
      desc: '',
      args: [],
    );
  }

  /// `probe`
  String get pz {
    return Intl.message(
      'probe',
      name: 'pz',
      desc: '',
      args: [],
    );
  }

  /// `magic Tank`
  String get mctankname {
    return Intl.message(
      'magic Tank',
      name: 'mctankname',
      desc: '',
      args: [],
    );
  }

  /// `Sync failed`
  String get asyncerror {
    return Intl.message(
      'Sync failed',
      name: 'asyncerror',
      desc: '',
      args: [],
    );
  }

  /// `synchronizing...`
  String get asyncing {
    return Intl.message(
      'synchronizing...',
      name: 'asyncing',
      desc: '',
      args: [],
    );
  }

  /// `Sync service data`
  String get asyncbt {
    return Intl.message(
      'Sync service data',
      name: 'asyncbt',
      desc: '',
      args: [],
    );
  }

  /// `Sync complete`
  String get asyncok {
    return Intl.message(
      'Sync complete',
      name: 'asyncok',
      desc: '',
      args: [],
    );
  }

  /// `key database`
  String get keydatabase {
    return Intl.message(
      'key database',
      name: 'keydatabase',
      desc: '',
      args: [],
    );
  }

  /// `test key`
  String get testkey {
    return Intl.message(
      'test key',
      name: 'testkey',
      desc: '',
      args: [],
    );
  }

  /// `cut by bitting`
  String get keycodecut {
    return Intl.message(
      'cut by bitting',
      name: 'keycodecut',
      desc: '',
      args: [],
    );
  }

  /// `All Key Lost`
  String get alllost {
    return Intl.message(
      'All Key Lost',
      name: 'alllost',
      desc: '',
      args: [],
    );
  }

  /// `Find Bitting`
  String get findbitting {
    return Intl.message(
      'Find Bitting',
      name: 'findbitting',
      desc: '',
      args: [],
    );
  }

  /// `Too location numbers are missing, please enter a few more`
  String get findbittingtip {
    return Intl.message(
      'Too location numbers are missing, please enter a few more',
      name: 'findbittingtip',
      desc: '',
      args: [],
    );
  }

  /// `Universal key replication`
  String get copykey {
    return Intl.message(
      'Universal key replication',
      name: 'copykey',
      desc: '',
      args: [],
    );
  }

  /// `Create key model`
  String get keymodelcut {
    return Intl.message(
      'Create key model',
      name: 'keymodelcut',
      desc: '',
      args: [],
    );
  }

  /// `custom key`
  String get diykey {
    return Intl.message(
      'custom key',
      name: 'diykey',
      desc: '',
      args: [],
    );
  }

  /// `2-in-1 Assistant`
  String get keytools {
    return Intl.message(
      '2-in-1 Assistant',
      name: 'keytools',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade Center`
  String get upgradecenter {
    return Intl.message(
      'Upgrade Center',
      name: 'upgradecenter',
      desc: '',
      args: [],
    );
  }

  /// `history record`
  String get userhistory {
    return Intl.message(
      'history record',
      name: 'userhistory',
      desc: '',
      args: [],
    );
  }

  /// `my collection`
  String get userstar {
    return Intl.message(
      'my collection',
      name: 'userstar',
      desc: '',
      args: [],
    );
  }

  /// `collection`
  String get star {
    return Intl.message(
      'collection',
      name: 'star',
      desc: '',
      args: [],
    );
  }

  /// `Cancel collection`
  String get removestar {
    return Intl.message(
      'Cancel collection',
      name: 'removestar',
      desc: '',
      args: [],
    );
  }

  /// `Device Information`
  String get deviceinfo {
    return Intl.message(
      'Device Information',
      name: 'deviceinfo',
      desc: '',
      args: [],
    );
  }

  /// `car database`
  String get cardatabase {
    return Intl.message(
      'car database',
      name: 'cardatabase',
      desc: '',
      args: [],
    );
  }

  /// `motorcycle database`
  String get motordatabase {
    return Intl.message(
      'motorcycle database',
      name: 'motordatabase',
      desc: '',
      args: [],
    );
  }

  /// `Civil database`
  String get civildatabase {
    return Intl.message(
      'Civil database',
      name: 'civildatabase',
      desc: '',
      args: [],
    );
  }

  /// `non-conductive key`
  String get nondatabase {
    return Intl.message(
      'non-conductive key',
      name: 'nondatabase',
      desc: '',
      args: [],
    );
  }

  /// `Smart card key second side`
  String get smartkeyside2 {
    return Intl.message(
      'Smart card key second side',
      name: 'smartkeyside2',
      desc: '',
      args: [],
    );
  }

  /// `The second side is a special clamping method, whether to check`
  String get smartkeyside2clamp {
    return Intl.message(
      'The second side is a special clamping method, whether to check',
      name: 'smartkeyside2clamp',
      desc: '',
      args: [],
    );
  }

  /// `The non-conductive key is about to be processed, please do not clamp the key first, and install the key according to the prompts (non-conductive keys cannot learn keys):`
  String get cutnontip {
    return Intl.message(
      'The non-conductive key is about to be processed, please do not clamp the key first, and install the key according to the prompts (non-conductive keys cannot learn keys):',
      name: 'cutnontip',
      desc: '',
      args: [],
    );
  }

  /// `The non-conductive key cannot learn the key, whether to check the position number by taking a photo`
  String get readnontip {
    return Intl.message(
      'The non-conductive key cannot learn the key, whether to check the position number by taking a photo',
      name: 'readnontip',
      desc: '',
      args: [],
    );
  }

  /// `Please enter make or model`
  String get searchcartip {
    return Intl.message(
      'Please enter make or model',
      name: 'searchcartip',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the lock number`
  String get searchcodetip {
    return Intl.message(
      'Please enter the lock number',
      name: 'searchcodetip',
      desc: '',
      args: [],
    );
  }

  /// `continue`
  String get continuebt {
    return Intl.message(
      'continue',
      name: 'continuebt',
      desc: '',
      args: [],
    );
  }

  /// `Clamping schematic`
  String get fixkey {
    return Intl.message(
      'Clamping schematic',
      name: 'fixkey',
      desc: '',
      args: [],
    );
  }

  /// `APP welcome page`
  String get appwelcomepage {
    return Intl.message(
      'APP welcome page',
      name: 'appwelcomepage',
      desc: '',
      args: [],
    );
  }

  /// `Enable new version`
  String get usenewver {
    return Intl.message(
      'Enable new version',
      name: 'usenewver',
      desc: '',
      args: [],
    );
  }

  /// `Voice settings`
  String get voicesetting {
    return Intl.message(
      'Voice settings',
      name: 'voicesetting',
      desc: '',
      args: [],
    );
  }

  /// `speed of speech`
  String get voicespeed {
    return Intl.message(
      'speed of speech',
      name: 'voicespeed',
      desc: '',
      args: [],
    );
  }

  /// `intonation`
  String get voicehight {
    return Intl.message(
      'intonation',
      name: 'voicehight',
      desc: '',
      args: [],
    );
  }

  /// `Example`
  String get example {
    return Intl.message(
      'Example',
      name: 'example',
      desc: '',
      args: [],
    );
  }

  /// `Homepage settings`
  String get mainpage {
    return Intl.message(
      'Homepage settings',
      name: 'mainpage',
      desc: '',
      args: [],
    );
  }

  /// `standard mode`
  String get standardmodel {
    return Intl.message(
      'standard mode',
      name: 'standardmodel',
      desc: '',
      args: [],
    );
  }

  /// `Advanced Mode`
  String get highmodel {
    return Intl.message(
      'Advanced Mode',
      name: 'highmodel',
      desc: '',
      args: [],
    );
  }

  /// `Tip:The more parameters provided, the more accurate the search results will be`
  String get highmodeltip {
    return Intl.message(
      'Tip:The more parameters provided, the more accurate the search results will be',
      name: 'highmodeltip',
      desc: '',
      args: [],
    );
  }

  /// `deepin keyboard`
  String get cutdepthboard {
    return Intl.message(
      'deepin keyboard',
      name: 'cutdepthboard',
      desc: '',
      args: [],
    );
  }

  /// `Parameter fine-tuning`
  String get finetuning {
    return Intl.message(
      'Parameter fine-tuning',
      name: 'finetuning',
      desc: '',
      args: [],
    );
  }

  /// `Learning details`
  String get learningdetails {
    return Intl.message(
      'Learning details',
      name: 'learningdetails',
      desc: '',
      args: [],
    );
  }

  /// `Photograph Identify`
  String get photokey {
    return Intl.message(
      'Photograph Identify',
      name: 'photokey',
      desc: '',
      args: [],
    );
  }

  /// `Select image source`
  String get selephoto {
    return Intl.message(
      'Select image source',
      name: 'selephoto',
      desc: '',
      args: [],
    );
  }

  /// `taking photos`
  String get carmerphoto {
    return Intl.message(
      'taking photos',
      name: 'carmerphoto',
      desc: '',
      args: [],
    );
  }

  /// `photo album`
  String get photoalbum {
    return Intl.message(
      'photo album',
      name: 'photoalbum',
      desc: '',
      args: [],
    );
  }

  /// `avatar`
  String get headimage {
    return Intl.message(
      'avatar',
      name: 'headimage',
      desc: '',
      args: [],
    );
  }

  /// `customer information`
  String get customerinf {
    return Intl.message(
      'customer information',
      name: 'customerinf',
      desc: '',
      args: [],
    );
  }

  /// `Save customer data`
  String get savecustomerinf {
    return Intl.message(
      'Save customer data',
      name: 'savecustomerinf',
      desc: '',
      args: [],
    );
  }

  /// `client's name`
  String get customername {
    return Intl.message(
      'client\'s name',
      name: 'customername',
      desc: '',
      args: [],
    );
  }

  /// `Customer mobile number`
  String get customerphone {
    return Intl.message(
      'Customer mobile number',
      name: 'customerphone',
      desc: '',
      args: [],
    );
  }

  /// `Customer license plate number`
  String get customercarnum {
    return Intl.message(
      'Customer license plate number',
      name: 'customercarnum',
      desc: '',
      args: [],
    );
  }

  /// `key learning`
  String get readkey {
    return Intl.message(
      'key learning',
      name: 'readkey',
      desc: '',
      args: [],
    );
  }

  /// `cutting`
  String get cuttingkey {
    return Intl.message(
      'cutting',
      name: 'cuttingkey',
      desc: '',
      args: [],
    );
  }

  /// `file download successfully`
  String get downfileok {
    return Intl.message(
      'file download successfully',
      name: 'downfileok',
      desc: '',
      args: [],
    );
  }

  /// `File download failed`
  String get downfileerror {
    return Intl.message(
      'File download failed',
      name: 'downfileerror',
      desc: '',
      args: [],
    );
  }

  /// `cutter diameter`
  String get xdr {
    return Intl.message(
      'cutter diameter',
      name: 'xdr',
      desc: '',
      args: [],
    );
  }

  /// `download`
  String get download {
    return Intl.message(
      'download',
      name: 'download',
      desc: '',
      args: [],
    );
  }

  /// `position`
  String get keytoothnum {
    return Intl.message(
      'position',
      name: 'keytoothnum',
      desc: '',
      args: [],
    );
  }

  /// `location number`
  String get keytoothcode {
    return Intl.message(
      'location number',
      name: 'keytoothcode',
      desc: '',
      args: [],
    );
  }

  /// `space`
  String get keytoothsa {
    return Intl.message(
      'space',
      name: 'keytoothsa',
      desc: '',
      args: [],
    );
  }

  /// `difference value`
  String get diffdata {
    return Intl.message(
      'difference value',
      name: 'diffdata',
      desc: '',
      args: [],
    );
  }

  /// `depth`
  String get keytoothdepth {
    return Intl.message(
      'depth',
      name: 'keytoothdepth',
      desc: '',
      args: [],
    );
  }

  /// `depths number `
  String get keytoothdepthnum {
    return Intl.message(
      'depths number ',
      name: 'keytoothdepthnum',
      desc: '',
      args: [],
    );
  }

  /// `reference value`
  String get reference {
    return Intl.message(
      'reference value',
      name: 'reference',
      desc: '',
      args: [],
    );
  }

  /// `actual Numerical value`
  String get really {
    return Intl.message(
      'actual Numerical value',
      name: 'really',
      desc: '',
      args: [],
    );
  }

  /// `refer to Numerical value`
  String get standarddata {
    return Intl.message(
      'refer to Numerical value',
      name: 'standarddata',
      desc: '',
      args: [],
    );
  }

  /// `Depth of cut (default value recommended)`
  String get cutdepth {
    return Intl.message(
      'Depth of cut (default value recommended)',
      name: 'cutdepth',
      desc: '',
      args: [],
    );
  }

  /// `This type is not supported`
  String get nosupoort {
    return Intl.message(
      'This type is not supported',
      name: 'nosupoort',
      desc: '',
      args: [],
    );
  }

  /// `Next step`
  String get nextstep {
    return Intl.message(
      'Next step',
      name: 'nextstep',
      desc: '',
      args: [],
    );
  }

  /// `It is detected that the cutter parameters have changed, whether to replace it with a 2.0mm cutter`
  String get checkxdchange {
    return Intl.message(
      'It is detected that the cutter parameters have changed, whether to replace it with a 2.0mm cutter',
      name: 'checkxdchange',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `head abrasion`
  String get headabrase {
    return Intl.message(
      'head abrasion',
      name: 'headabrase',
      desc: '',
      args: [],
    );
  }

  /// `both sides abrasion`
  String get toothabrase {
    return Intl.message(
      'both sides abrasion',
      name: 'toothabrase',
      desc: '',
      args: [],
    );
  }

  /// `Need 1.5mm cutter, whether to replace the cutter?`
  String get needchangexd1 {
    return Intl.message(
      'Need 1.5mm cutter, whether to replace the cutter?',
      name: 'needchangexd1',
      desc: '',
      args: [],
    );
  }

  /// `Need 1.5mm/1.9mm cutter, whether to replace the cutter?`
  String get needchangexd2 {
    return Intl.message(
      'Need 1.5mm/1.9mm cutter, whether to replace the cutter?',
      name: 'needchangexd2',
      desc: '',
      args: [],
    );
  }

  /// `Select the cutter that needs to be replaced`
  String get selexd {
    return Intl.message(
      'Select the cutter that needs to be replaced',
      name: 'selexd',
      desc: '',
      args: [],
    );
  }

  /// `determine`
  String get okbt {
    return Intl.message(
      'determine',
      name: 'okbt',
      desc: '',
      args: [],
    );
  }

  /// `select axis`
  String get seleaxis {
    return Intl.message(
      'select axis',
      name: 'seleaxis',
      desc: '',
      args: [],
    );
  }

  /// `The B-axis smart card key is a special clamping method, check the clamping diagram`
  String get smart162tb {
    return Intl.message(
      'The B-axis smart card key is a special clamping method, check the clamping diagram',
      name: 'smart162tb',
      desc: '',
      args: [],
    );
  }

  /// `pause`
  String get suspend {
    return Intl.message(
      'pause',
      name: 'suspend',
      desc: '',
      args: [],
    );
  }

  /// `Pausing....`
  String get suspending {
    return Intl.message(
      'Pausing....',
      name: 'suspending',
      desc: '',
      args: [],
    );
  }

  /// `stop`
  String get stop {
    return Intl.message(
      'stop',
      name: 'stop',
      desc: '',
      args: [],
    );
  }

  /// `Equipment is running...`
  String get working {
    return Intl.message(
      'Equipment is running...',
      name: 'working',
      desc: '',
      args: [],
    );
  }

  /// `Advanced Search`
  String get highsearch {
    return Intl.message(
      'Advanced Search',
      name: 'highsearch',
      desc: '',
      args: [],
    );
  }

  /// `Fixture`
  String get fixture {
    return Intl.message(
      'Fixture',
      name: 'fixture',
      desc: '',
      args: [],
    );
  }

  /// `search`
  String get search {
    return Intl.message(
      'search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `No data found`
  String get searchno {
    return Intl.message(
      'No data found',
      name: 'searchno',
      desc: '',
      args: [],
    );
  }

  /// `Need to determine the car model first`
  String get needcarmode {
    return Intl.message(
      'Need to determine the car model first',
      name: 'needcarmode',
      desc: '',
      args: [],
    );
  }

  /// `Please select the car model first`
  String get selecarmode {
    return Intl.message(
      'Please select the car model first',
      name: 'selecarmode',
      desc: '',
      args: [],
    );
  }

  /// `Please learn the key first, or enter the full position number`
  String get needreadcode {
    return Intl.message(
      'Please learn the key first, or enter the full position number',
      name: 'needreadcode',
      desc: '',
      args: [],
    );
  }

  /// `Function`
  String get function {
    return Intl.message(
      'Function',
      name: 'function',
      desc: '',
      args: [],
    );
  }

  /// `Choose the type to cut`
  String get selesmart {
    return Intl.message(
      'Choose the type to cut',
      name: 'selesmart',
      desc: '',
      args: [],
    );
  }

  /// `smart key`
  String get smartkey {
    return Intl.message(
      'smart key',
      name: 'smartkey',
      desc: '',
      args: [],
    );
  }

  /// `standard key`
  String get standardkey {
    return Intl.message(
      'standard key',
      name: 'standardkey',
      desc: '',
      args: [],
    );
  }

  /// `searching...`
  String get searching {
    return Intl.message(
      'searching...',
      name: 'searching',
      desc: '',
      args: [],
    );
  }

  /// `key type`
  String get keyclass {
    return Intl.message(
      'key type',
      name: 'keyclass',
      desc: '',
      args: [],
    );
  }

  /// `position Way`
  String get keyloact {
    return Intl.message(
      'position Way',
      name: 'keyloact',
      desc: '',
      args: [],
    );
  }

  /// `valid edge`
  String get keyside {
    return Intl.message(
      'valid edge',
      name: 'keyside',
      desc: '',
      args: [],
    );
  }

  /// `key identification`
  String get keydiscern {
    return Intl.message(
      'key identification',
      name: 'keydiscern',
      desc: '',
      args: [],
    );
  }

  /// `Is it a smart key`
  String get issmartkey {
    return Intl.message(
      'Is it a smart key',
      name: 'issmartkey',
      desc: '',
      args: [],
    );
  }

  /// `Is it a non-conductive key?`
  String get isnon {
    return Intl.message(
      'Is it a non-conductive key?',
      name: 'isnon',
      desc: '',
      args: [],
    );
  }

  /// `space amount`
  String get keytooth {
    return Intl.message(
      'space amount',
      name: 'keytooth',
      desc: '',
      args: [],
    );
  }

  /// `The more parameters provided, the more accurate the search results.`
  String get searchtip {
    return Intl.message(
      'The more parameters provided, the more accurate the search results.',
      name: 'searchtip',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a brand`
  String get alllostsearch {
    return Intl.message(
      'Please enter a brand',
      name: 'alllostsearch',
      desc: '',
      args: [],
    );
  }

  /// `Example description`
  String get alllosttip {
    return Intl.message(
      'Example description',
      name: 'alllosttip',
      desc: '',
      args: [],
    );
  }

  /// `Missing location number not found`
  String get searchbittingtip {
    return Intl.message(
      'Missing location number not found',
      name: 'searchbittingtip',
      desc: '',
      args: [],
    );
  }

  /// `Standard bilateral`
  String get keyclass0 {
    return Intl.message(
      'Standard bilateral',
      name: 'keyclass0',
      desc: '',
      args: [],
    );
  }

  /// `standard unilateral`
  String get keyclass1 {
    return Intl.message(
      'standard unilateral',
      name: 'keyclass1',
      desc: '',
      args: [],
    );
  }

  /// `Laser Internal Dual`
  String get keyclass2 {
    return Intl.message(
      'Laser Internal Dual',
      name: 'keyclass2',
      desc: '',
      args: [],
    );
  }

  /// `Laser Internal Single`
  String get keyclass5 {
    return Intl.message(
      'Laser Internal Single',
      name: 'keyclass5',
      desc: '',
      args: [],
    );
  }

  /// `Laser external unilateral`
  String get keyclass3 {
    return Intl.message(
      'Laser external unilateral',
      name: 'keyclass3',
      desc: '',
      args: [],
    );
  }

  /// `Laser external bilateral`
  String get keyclass4 {
    return Intl.message(
      'Laser external bilateral',
      name: 'keyclass4',
      desc: '',
      args: [],
    );
  }

  /// `Side clip laser`
  String get keyclass6 {
    return Intl.message(
      'Side clip laser',
      name: 'keyclass6',
      desc: '',
      args: [],
    );
  }

  /// `Side clip standard`
  String get keyclass7 {
    return Intl.message(
      'Side clip standard',
      name: 'keyclass7',
      desc: '',
      args: [],
    );
  }

  /// `Shoulder positioning`
  String get keylocat0 {
    return Intl.message(
      'Shoulder positioning',
      name: 'keylocat0',
      desc: '',
      args: [],
    );
  }

  /// `Front end positioning`
  String get keylocat1 {
    return Intl.message(
      'Front end positioning',
      name: 'keylocat1',
      desc: '',
      args: [],
    );
  }

  /// `placed in area A(A axis)`
  String get keyside0 {
    return Intl.message(
      'placed in area A(A axis)',
      name: 'keyside0',
      desc: '',
      args: [],
    );
  }

  /// `placed in area A(B axis)`
  String get keyside1 {
    return Intl.message(
      'placed in area A(B axis)',
      name: 'keyside1',
      desc: '',
      args: [],
    );
  }

  /// `placed in area B(A axis)Thin`
  String get keyside3 {
    return Intl.message(
      'placed in area B(A axis)Thin',
      name: 'keyside3',
      desc: '',
      args: [],
    );
  }

  /// `placed in area B(B axis)Thin`
  String get keyside4 {
    return Intl.message(
      'placed in area B(B axis)Thin',
      name: 'keyside4',
      desc: '',
      args: [],
    );
  }

  /// `placed in area A`
  String get keyside5 {
    return Intl.message(
      'placed in area A',
      name: 'keyside5',
      desc: '',
      args: [],
    );
  }

  /// `placed in area B(Thin)`
  String get keyside6 {
    return Intl.message(
      'placed in area B(Thin)',
      name: 'keyside6',
      desc: '',
      args: [],
    );
  }

  /// `read key`
  String get copykeyread {
    return Intl.message(
      'read key',
      name: 'copykeyread',
      desc: '',
      args: [],
    );
  }

  /// `key preview`
  String get copykeypreview {
    return Intl.message(
      'key preview',
      name: 'copykeypreview',
      desc: '',
      args: [],
    );
  }

  /// `key cutting`
  String get copykeycut {
    return Intl.message(
      'key cutting',
      name: 'copykeycut',
      desc: '',
      args: [],
    );
  }

  /// `Please read key first`
  String get copykeytip {
    return Intl.message(
      'Please read key first',
      name: 'copykeytip',
      desc: '',
      args: [],
    );
  }

  /// `Getting data...`
  String get getdata {
    return Intl.message(
      'Getting data...',
      name: 'getdata',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get timershow {
    return Intl.message(
      'Time',
      name: 'timershow',
      desc: '',
      args: [],
    );
  }

  /// `edit`
  String get editdata {
    return Intl.message(
      'edit',
      name: 'editdata',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get complete {
    return Intl.message(
      'Finish',
      name: 'complete',
      desc: '',
      args: [],
    );
  }

  /// `delete`
  String get del {
    return Intl.message(
      'delete',
      name: 'del',
      desc: '',
      args: [],
    );
  }

  /// `Delete data?\r\nNotice:This operation cannot be recover!\r\nShared resources are also deleted!`
  String get deltip {
    return Intl.message(
      'Delete data?\r\nNotice:This operation cannot be recover!\r\nShared resources are also deleted!',
      name: 'deltip',
      desc: '',
      args: [],
    );
  }

  /// `Standard blank key`
  String get modelclass0 {
    return Intl.message(
      'Standard blank key',
      name: 'modelclass0',
      desc: '',
      args: [],
    );
  }

  /// `laser blank key`
  String get modelclass1 {
    return Intl.message(
      'laser blank key',
      name: 'modelclass1',
      desc: '',
      args: [],
    );
  }

  /// `DIY key`
  String get diymodel {
    return Intl.message(
      'DIY key',
      name: 'diymodel',
      desc: '',
      args: [],
    );
  }

  /// `Choose model`
  String get selemodel {
    return Intl.message(
      'Choose model',
      name: 'selemodel',
      desc: '',
      args: [],
    );
  }

  /// `Choose key`
  String get selekey {
    return Intl.message(
      'Choose key',
      name: 'selekey',
      desc: '',
      args: [],
    );
  }

  /// `Create blank key`
  String get creatmodel {
    return Intl.message(
      'Create blank key',
      name: 'creatmodel',
      desc: '',
      args: [],
    );
  }

  /// `measure to create a blank key`
  String get measuremodel {
    return Intl.message(
      'measure to create a blank key',
      name: 'measuremodel',
      desc: '',
      args: [],
    );
  }

  /// `Intelligently create blank keys`
  String get smartmodel {
    return Intl.message(
      'Intelligently create blank keys',
      name: 'smartmodel',
      desc: '',
      args: [],
    );
  }

  /// `Laser - Front End Positioning`
  String get diymodelclass0 {
    return Intl.message(
      'Laser - Front End Positioning',
      name: 'diymodelclass0',
      desc: '',
      args: [],
    );
  }

  /// `Laser - Shoulder Positioning`
  String get diymodelclass1 {
    return Intl.message(
      'Laser - Shoulder Positioning',
      name: 'diymodelclass1',
      desc: '',
      args: [],
    );
  }

  /// `standard-Front End Positioning`
  String get diymodelclass2 {
    return Intl.message(
      'standard-Front End Positioning',
      name: 'diymodelclass2',
      desc: '',
      args: [],
    );
  }

  /// `standard-Shoulder Positioning`
  String get diymodelclass3 {
    return Intl.message(
      'standard-Shoulder Positioning',
      name: 'diymodelclass3',
      desc: '',
      args: [],
    );
  }

  /// `Feature selection`
  String get selemodeltype {
    return Intl.message(
      'Feature selection',
      name: 'selemodeltype',
      desc: '',
      args: [],
    );
  }

  /// `middle groove`
  String get mgroove {
    return Intl.message(
      'middle groove',
      name: 'mgroove',
      desc: '',
      args: [],
    );
  }

  /// `upper groove`
  String get ugroove {
    return Intl.message(
      'upper groove',
      name: 'ugroove',
      desc: '',
      args: [],
    );
  }

  /// `Bottom groove`
  String get lgroove {
    return Intl.message(
      'Bottom groove',
      name: 'lgroove',
      desc: '',
      args: [],
    );
  }

  /// `right angle groove`
  String get linegroove {
    return Intl.message(
      'right angle groove',
      name: 'linegroove',
      desc: '',
      args: [],
    );
  }

  /// `V-groove`
  String get vgroove {
    return Intl.message(
      'V-groove',
      name: 'vgroove',
      desc: '',
      args: [],
    );
  }

  /// `front-end processing`
  String get modelhead {
    return Intl.message(
      'front-end processing',
      name: 'modelhead',
      desc: '',
      args: [],
    );
  }

  /// `width`
  String get wdiemodelhead0 {
    return Intl.message(
      'width',
      name: 'wdiemodelhead0',
      desc: '',
      args: [],
    );
  }

  /// `narrow`
  String get wdiemodelhead1 {
    return Intl.message(
      'narrow',
      name: 'wdiemodelhead1',
      desc: '',
      args: [],
    );
  }

  /// `Basic Features`
  String get basetype {
    return Intl.message(
      'Basic Features',
      name: 'basetype',
      desc: '',
      args: [],
    );
  }

  /// `Key width (0.01mm)`
  String get keywide {
    return Intl.message(
      'Key width (0.01mm)',
      name: 'keywide',
      desc: '',
      args: [],
    );
  }

  /// `Key thickness (0.01mm)`
  String get keythickness {
    return Intl.message(
      'Key thickness (0.01mm)',
      name: 'keythickness',
      desc: '',
      args: [],
    );
  }

  /// `Shoulder width (0.01mm)`
  String get keylocatwide {
    return Intl.message(
      'Shoulder width (0.01mm)',
      name: 'keylocatwide',
      desc: '',
      args: [],
    );
  }

  /// `Shoulder length (0.01mm)`
  String get keylocatlen {
    return Intl.message(
      'Shoulder length (0.01mm)',
      name: 'keylocatlen',
      desc: '',
      args: [],
    );
  }

  /// `Middle groove length (0.01mm)`
  String get mgroovelen {
    return Intl.message(
      'Middle groove length (0.01mm)',
      name: 'mgroovelen',
      desc: '',
      args: [],
    );
  }

  /// `Middle groove width (0.01mm)`
  String get mgroovewide {
    return Intl.message(
      'Middle groove width (0.01mm)',
      name: 'mgroovewide',
      desc: '',
      args: [],
    );
  }

  /// `The position of the middle groove(0.01mm)`
  String get mgroovedistance {
    return Intl.message(
      'The position of the middle groove(0.01mm)',
      name: 'mgroovedistance',
      desc: '',
      args: [],
    );
  }

  /// `Middle groove depth (0.01mm)`
  String get mgroovedepth {
    return Intl.message(
      'Middle groove depth (0.01mm)',
      name: 'mgroovedepth',
      desc: '',
      args: [],
    );
  }

  /// `Bottom groove length`
  String get lgroovelen {
    return Intl.message(
      'Bottom groove length',
      name: 'lgroovelen',
      desc: '',
      args: [],
    );
  }

  /// `Bottom groove width(0.01mm)`
  String get lgroovewide {
    return Intl.message(
      'Bottom groove width(0.01mm)',
      name: 'lgroovewide',
      desc: '',
      args: [],
    );
  }

  /// `Bottom groove position(0.01mm)`
  String get lgroovedistance {
    return Intl.message(
      'Bottom groove position(0.01mm)',
      name: 'lgroovedistance',
      desc: '',
      args: [],
    );
  }

  /// `Bottom groove depth(0.01mm)`
  String get lgroovedepth {
    return Intl.message(
      'Bottom groove depth(0.01mm)',
      name: 'lgroovedepth',
      desc: '',
      args: [],
    );
  }

  /// `Upper groove length(0.01mm)`
  String get ugroovelen {
    return Intl.message(
      'Upper groove length(0.01mm)',
      name: 'ugroovelen',
      desc: '',
      args: [],
    );
  }

  /// `Upper groove width(0.01mm)`
  String get ugroovewide {
    return Intl.message(
      'Upper groove width(0.01mm)',
      name: 'ugroovewide',
      desc: '',
      args: [],
    );
  }

  /// `upper groove position(0.01mm)`
  String get ugroovedistance {
    return Intl.message(
      'upper groove position(0.01mm)',
      name: 'ugroovedistance',
      desc: '',
      args: [],
    );
  }

  /// `Upper groove depth(0.01mm)`
  String get ugroovedepth {
    return Intl.message(
      'Upper groove depth(0.01mm)',
      name: 'ugroovedepth',
      desc: '',
      args: [],
    );
  }

  /// `V-groove length(0.01mm)`
  String get vgroovelen {
    return Intl.message(
      'V-groove length(0.01mm)',
      name: 'vgroovelen',
      desc: '',
      args: [],
    );
  }

  /// `V-groove width(0.01mm)`
  String get vgroovewide {
    return Intl.message(
      'V-groove width(0.01mm)',
      name: 'vgroovewide',
      desc: '',
      args: [],
    );
  }

  /// `V-groove positio(0.01mm)`
  String get vgroovedistance {
    return Intl.message(
      'V-groove positio(0.01mm)',
      name: 'vgroovedistance',
      desc: '',
      args: [],
    );
  }

  /// `V-groove depth(0.01mm)`
  String get vgroovedepth {
    return Intl.message(
      'V-groove depth(0.01mm)',
      name: 'vgroovedepth',
      desc: '',
      args: [],
    );
  }

  /// `Second middle groove length(0.01mm)`
  String get l2groovelen {
    return Intl.message(
      'Second middle groove length(0.01mm)',
      name: 'l2groovelen',
      desc: '',
      args: [],
    );
  }

  /// `Second middle groove width(0.01mm)`
  String get l2groovewide {
    return Intl.message(
      'Second middle groove width(0.01mm)',
      name: 'l2groovewide',
      desc: '',
      args: [],
    );
  }

  /// `Second intermediate groove depth(0.01mm)`
  String get l2groovedepth {
    return Intl.message(
      'Second intermediate groove depth(0.01mm)',
      name: 'l2groovedepth',
      desc: '',
      args: [],
    );
  }

  /// `Front end length(0.01mm)`
  String get modelheadlen {
    return Intl.message(
      'Front end length(0.01mm)',
      name: 'modelheadlen',
      desc: '',
      args: [],
    );
  }

  /// `model name`
  String get modelname {
    return Intl.message(
      'model name',
      name: 'modelname',
      desc: '',
      args: [],
    );
  }

  /// `brand name`
  String get modelbrand {
    return Intl.message(
      'brand name',
      name: 'modelbrand',
      desc: '',
      args: [],
    );
  }

  /// `Brand model`
  String get brandcar {
    return Intl.message(
      'Brand model',
      name: 'brandcar',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a brand name`
  String get needmodelbrand {
    return Intl.message(
      'Please enter a brand name',
      name: 'needmodelbrand',
      desc: '',
      args: [],
    );
  }

  /// `Please enter key name`
  String get needkeyname {
    return Intl.message(
      'Please enter key name',
      name: 'needkeyname',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to use it now?`
  String get asknowuse {
    return Intl.message(
      'Do you want to use it now?',
      name: 'asknowuse',
      desc: '',
      args: [],
    );
  }

  /// `Remark`
  String get note {
    return Intl.message(
      'Remark',
      name: 'note',
      desc: '',
      args: [],
    );
  }

  /// `save`
  String get save {
    return Intl.message(
      'save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Whether to process this blank key now`
  String get nowcutmodeltip {
    return Intl.message(
      'Whether to process this blank key now',
      name: 'nowcutmodeltip',
      desc: '',
      args: [],
    );
  }

  /// `Tips information`
  String get tipmessage {
    return Intl.message(
      'Tips information',
      name: 'tipmessage',
      desc: '',
      args: [],
    );
  }

  /// `Machining settings`
  String get cutsetting {
    return Intl.message(
      'Machining settings',
      name: 'cutsetting',
      desc: '',
      args: [],
    );
  }

  /// `Get calibration data`
  String get getcalibrationdata {
    return Intl.message(
      'Get calibration data',
      name: 'getcalibrationdata',
      desc: '',
      args: [],
    );
  }

  /// `Cutting calibration`
  String get cutcalibration {
    return Intl.message(
      'Cutting calibration',
      name: 'cutcalibration',
      desc: '',
      args: [],
    );
  }

  /// `replace cutter/probe`
  String get changexdpz {
    return Intl.message(
      'replace cutter/probe',
      name: 'changexdpz',
      desc: '',
      args: [],
    );
  }

  /// `Stepper Motor Test`
  String get motortest {
    return Intl.message(
      'Stepper Motor Test',
      name: 'motortest',
      desc: '',
      args: [],
    );
  }

  /// `Fixture correction`
  String get fixturecalibration {
    return Intl.message(
      'Fixture correction',
      name: 'fixturecalibration',
      desc: '',
      args: [],
    );
  }

  /// `Conductivity test`
  String get electrictest {
    return Intl.message(
      'Conductivity test',
      name: 'electrictest',
      desc: '',
      args: [],
    );
  }

  /// `Machine detection`
  String get cnccheck {
    return Intl.message(
      'Machine detection',
      name: 'cnccheck',
      desc: '',
      args: [],
    );
  }

  /// `account`
  String get account {
    return Intl.message(
      'account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `Select fixture`
  String get selefixture {
    return Intl.message(
      'Select fixture',
      name: 'selefixture',
      desc: '',
      args: [],
    );
  }

  /// `new fixture`
  String get newfixture {
    return Intl.message(
      'new fixture',
      name: 'newfixture',
      desc: '',
      args: [],
    );
  }

  /// `old fixture`
  String get oldfixture {
    return Intl.message(
      'old fixture',
      name: 'oldfixture',
      desc: '',
      args: [],
    );
  }

  /// `X,Y control`
  String get xycontrol {
    return Intl.message(
      'X,Y control',
      name: 'xycontrol',
      desc: '',
      args: [],
    );
  }

  /// `Z control`
  String get zcontrol {
    return Intl.message(
      'Z control',
      name: 'zcontrol',
      desc: '',
      args: [],
    );
  }

  /// `brushless motor on`
  String get bldcopen {
    return Intl.message(
      'brushless motor on',
      name: 'bldcopen',
      desc: '',
      args: [],
    );
  }

  /// `Brushless  motor Off`
  String get bldcclose {
    return Intl.message(
      'Brushless  motor Off',
      name: 'bldcclose',
      desc: '',
      args: [],
    );
  }

  /// `Brushless Motor Test`
  String get bldctest {
    return Intl.message(
      'Brushless Motor Test',
      name: 'bldctest',
      desc: '',
      args: [],
    );
  }

  /// `Moving speed`
  String get movespeed {
    return Intl.message(
      'Moving speed',
      name: 'movespeed',
      desc: '',
      args: [],
    );
  }

  /// `Note: Please pay attention when operating, beware of cutting to fixture`
  String get motortesttip {
    return Intl.message(
      'Note: Please pay attention when operating, beware of cutting to fixture',
      name: 'motortesttip',
      desc: '',
      args: [],
    );
  }

  /// `Enter groove width`
  String get inputkeygroovewide {
    return Intl.message(
      'Enter groove width',
      name: 'inputkeygroovewide',
      desc: '',
      args: [],
    );
  }

  /// `jump`
  String get jump {
    return Intl.message(
      'jump',
      name: 'jump',
      desc: '',
      args: [],
    );
  }

  /// `fxitrure夹具号_钥匙类型_新旧夹具_index`
  String get fixturex_x_x_x {
    return Intl.message(
      'fxitrure夹具号_钥匙类型_新旧夹具_index',
      name: 'fixturex_x_x_x',
      desc: '',
      args: [],
    );
  }

  /// `Fo21操作说明`
  String get fo21 {
    return Intl.message(
      'Fo21操作说明',
      name: 'fo21',
      desc: '',
      args: [],
    );
  }

  /// `Loosen the screw and remove the fixture`
  String get fixture_fo21_0_1 {
    return Intl.message(
      'Loosen the screw and remove the fixture',
      name: 'fixture_fo21_0_1',
      desc: '',
      args: [],
    );
  }

  /// `remove probe`
  String get fixture_fo21_0_2 {
    return Intl.message(
      'remove probe',
      name: 'fixture_fo21_0_2',
      desc: '',
      args: [],
    );
  }

  /// `Insert FO21 fixture`
  String get fixture_fo21_0_3 {
    return Intl.message(
      'Insert FO21 fixture',
      name: 'fixture_fo21_0_3',
      desc: '',
      args: [],
    );
  }

  /// `locking screw`
  String get fixture_fo21_0_4 {
    return Intl.message(
      'locking screw',
      name: 'fixture_fo21_0_4',
      desc: '',
      args: [],
    );
  }

  /// `insert key`
  String get fixture_fo21_0_5 {
    return Intl.message(
      'insert key',
      name: 'fixture_fo21_0_5',
      desc: '',
      args: [],
    );
  }

  /// `Turn the key to approximately level`
  String get fixture_fo21_0_6 {
    return Intl.message(
      'Turn the key to approximately level',
      name: 'fixture_fo21_0_6',
      desc: '',
      args: [],
    );
  }

  /// `Rotate the block, fix the key`
  String get fixture_fo21_0_7 {
    return Intl.message(
      'Rotate the block, fix the key',
      name: 'fixture_fo21_0_7',
      desc: '',
      args: [],
    );
  }

  /// `pull the key back`
  String get fixture_fo21_0_8 {
    return Intl.message(
      'pull the key back',
      name: 'fixture_fo21_0_8',
      desc: '',
      args: [],
    );
  }

  /// `Pre-tighten the nut by hand`
  String get fixture_fo21_0_9 {
    return Intl.message(
      'Pre-tighten the nut by hand',
      name: 'fixture_fo21_0_9',
      desc: '',
      args: [],
    );
  }

  /// `Tighten the nut with a FO21 wrench`
  String get fixture_fo21_0_10 {
    return Intl.message(
      'Tighten the nut with a FO21 wrench',
      name: 'fixture_fo21_0_10',
      desc: '',
      args: [],
    );
  }

  /// `Spin the block away from the key`
  String get fixture_fo21_0_11 {
    return Intl.message(
      'Spin the block away from the key',
      name: 'fixture_fo21_0_11',
      desc: '',
      args: [],
    );
  }

  /// `Loosen the screw and remove the fixture`
  String get fixture_fo21_1_1 {
    return Intl.message(
      'Loosen the screw and remove the fixture',
      name: 'fixture_fo21_1_1',
      desc: '',
      args: [],
    );
  }

  /// `remove probe`
  String get fixture_fo21_1_2 {
    return Intl.message(
      'remove probe',
      name: 'fixture_fo21_1_2',
      desc: '',
      args: [],
    );
  }

  /// `Insert FO21 fixture`
  String get fixture_fo21_1_3 {
    return Intl.message(
      'Insert FO21 fixture',
      name: 'fixture_fo21_1_3',
      desc: '',
      args: [],
    );
  }

  /// `locking screw`
  String get fixture_fo21_1_4 {
    return Intl.message(
      'locking screw',
      name: 'fixture_fo21_1_4',
      desc: '',
      args: [],
    );
  }

  /// `insert key`
  String get fixture_fo21_1_5 {
    return Intl.message(
      'insert key',
      name: 'fixture_fo21_1_5',
      desc: '',
      args: [],
    );
  }

  /// `Turn the key to approximately level`
  String get fixture_fo21_1_6 {
    return Intl.message(
      'Turn the key to approximately level',
      name: 'fixture_fo21_1_6',
      desc: '',
      args: [],
    );
  }

  /// `Rotate the block, fix the key`
  String get fixture_fo21_1_7 {
    return Intl.message(
      'Rotate the block, fix the key',
      name: 'fixture_fo21_1_7',
      desc: '',
      args: [],
    );
  }

  /// `pull the key back`
  String get fixture_fo21_1_8 {
    return Intl.message(
      'pull the key back',
      name: 'fixture_fo21_1_8',
      desc: '',
      args: [],
    );
  }

  /// `Pre-tighten the nut by hand`
  String get fixture_fo21_1_9 {
    return Intl.message(
      'Pre-tighten the nut by hand',
      name: 'fixture_fo21_1_9',
      desc: '',
      args: [],
    );
  }

  /// `Tighten the nut with a FO21 wrench`
  String get fixture_fo21_1_10 {
    return Intl.message(
      'Tighten the nut with a FO21 wrench',
      name: 'fixture_fo21_1_10',
      desc: '',
      args: [],
    );
  }

  /// `Spin the block away from the key`
  String get fixture_fo21_1_11 {
    return Intl.message(
      'Spin the block away from the key',
      name: 'fixture_fo21_1_11',
      desc: '',
      args: [],
    );
  }

  /// `通用立铣对头`
  String get fixture1 {
    return Intl.message(
      '通用立铣对头',
      name: 'fixture1',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in the left area`
  String get fixture0_1_0_1 {
    return Intl.message(
      'Place the key in the left area',
      name: 'fixture0_1_0_1',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in area A`
  String get fixture0_1_1_1 {
    return Intl.message(
      'Place the key in area A',
      name: 'fixture0_1_1_1',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 1st groove`
  String get fixture0_1_0_2 {
    return Intl.message(
      'Align the head of the key with the 1st groove',
      name: 'fixture0_1_0_2',
      desc: '',
      args: [],
    );
  }

  /// `Align the key head with the 1st reference line`
  String get fixture0_1_1_2 {
    return Intl.message(
      'Align the key head with the 1st reference line',
      name: 'fixture0_1_1_2',
      desc: '',
      args: [],
    );
  }

  /// `通用立铣对肩`
  String get fixture0 {
    return Intl.message(
      '通用立铣对肩',
      name: 'fixture0',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in the left area,and insert the block`
  String get fixture0_0_0_1 {
    return Intl.message(
      'Place the key in the left area,and insert the block',
      name: 'fixture0_0_0_1',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in area A上,and insert the block`
  String get fixture0_0_1_1 {
    return Intl.message(
      'Place the key in area A上,and insert the block',
      name: 'fixture0_0_1_1',
      desc: '',
      args: [],
    );
  }

  /// `Hold the key shoulder against the block, clamp the key and remove the block`
  String get fixture0_0_0_2 {
    return Intl.message(
      'Hold the key shoulder against the block, clamp the key and remove the block',
      name: 'fixture0_0_0_2',
      desc: '',
      args: [],
    );
  }

  /// `Hold the key shoulder against the block, clamp the key and remove the block`
  String get fixture0_0_1_2 {
    return Intl.message(
      'Hold the key shoulder against the block, clamp the key and remove the block',
      name: 'fixture0_0_1_2',
      desc: '',
      args: [],
    );
  }

  /// `通用平铣对肩`
  String get fixture51 {
    return Intl.message(
      '通用平铣对肩',
      name: 'fixture51',
      desc: '',
      args: [],
    );
  }

  /// `Put the key in the area on the right,and insert the block`
  String get fixture5_0_0_1 {
    return Intl.message(
      'Put the key in the area on the right,and insert the block',
      name: 'fixture5_0_0_1',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in area B,and insert the block`
  String get fixture5_0_1_1 {
    return Intl.message(
      'Place the key in area B,and insert the block',
      name: 'fixture5_0_1_1',
      desc: '',
      args: [],
    );
  }

  /// `Rest the shoulder of the key against the block,Clamp the key and remove the block`
  String get fixture5_0_0_2 {
    return Intl.message(
      'Rest the shoulder of the key against the block,Clamp the key and remove the block',
      name: 'fixture5_0_0_2',
      desc: '',
      args: [],
    );
  }

  /// `Rest the shoulder of the key against the block,Clamp the key`
  String get fixture5_0_1_2 {
    return Intl.message(
      'Rest the shoulder of the key against the block,Clamp the key',
      name: 'fixture5_0_1_2',
      desc: '',
      args: [],
    );
  }

  /// `Tighten the screw on the block against the key,and remove the block(Tighten the screws lightly, not forcefully!)`
  String get fixture5_0_1_3 {
    return Intl.message(
      'Tighten the screw on the block against the key,and remove the block(Tighten the screws lightly, not forcefully!)',
      name: 'fixture5_0_1_3',
      desc: '',
      args: [],
    );
  }

  /// `通用平铣对头`
  String get fixture50 {
    return Intl.message(
      '通用平铣对头',
      name: 'fixture50',
      desc: '',
      args: [],
    );
  }

  /// `Put the key in the area on the right,and insert the block`
  String get fixture5_1_0_1 {
    return Intl.message(
      'Put the key in the area on the right,and insert the block',
      name: 'fixture5_1_0_1',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in area B,and insert the block`
  String get fixture5_1_1_1 {
    return Intl.message(
      'Place the key in area B,and insert the block',
      name: 'fixture5_1_1_1',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 1st groove,and remove the block`
  String get fixture5_1_0_2 {
    return Intl.message(
      'Align the head of the key with the 1st groove,and remove the block',
      name: 'fixture5_1_0_2',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 1st reference line,Clamp the key`
  String get fixture5_1_1_2 {
    return Intl.message(
      'Align the head of the key with the 1st reference line,Clamp the key',
      name: 'fixture5_1_1_2',
      desc: '',
      args: [],
    );
  }

  /// `Tighten the screw on the block against the key,and remove the block(Tighten the screws lightly, not forcefully!)`
  String get fixture5_1_1_3 {
    return Intl.message(
      'Tighten the screw on the block against the key,and remove the block(Tighten the screws lightly, not forcefully!)',
      name: 'fixture5_1_1_3',
      desc: '',
      args: [],
    );
  }

  /// `通用立铣夹右边对头`
  String get fixture541 {
    return Intl.message(
      '通用立铣夹右边对头',
      name: 'fixture541',
      desc: '',
      args: [],
    );
  }

  /// `Put the key in the area on the right`
  String get fixture5_4_0_1 {
    return Intl.message(
      'Put the key in the area on the right',
      name: 'fixture5_4_0_1',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 1st groove,Clamp the key`
  String get fixture5_4_0_2 {
    return Intl.message(
      'Align the head of the key with the 1st groove,Clamp the key',
      name: 'fixture5_4_0_2',
      desc: '',
      args: [],
    );
  }

  /// `remove small block`
  String get fixture5_4_1_1 {
    return Intl.message(
      'remove small block',
      name: 'fixture5_4_1_1',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in area B`
  String get fixture5_4_1_2 {
    return Intl.message(
      'Place the key in area B',
      name: 'fixture5_4_1_2',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 1st reference line,Clamp the key`
  String get fixture5_4_1_3 {
    return Intl.message(
      'Align the head of the key with the 1st reference line,Clamp the key',
      name: 'fixture5_4_1_3',
      desc: '',
      args: [],
    );
  }

  /// `通用立铣夹右边对肩膀`
  String get fixture540 {
    return Intl.message(
      '通用立铣夹右边对肩膀',
      name: 'fixture540',
      desc: '',
      args: [],
    );
  }

  /// `Put the key in the area on the right,and insert the block`
  String get fixture8_0_0_1 {
    return Intl.message(
      'Put the key in the area on the right,and insert the block',
      name: 'fixture8_0_0_1',
      desc: '',
      args: [],
    );
  }

  /// `Hold the key shoulder against the block, clamp the key and remove the block`
  String get fixture8_0_0_2 {
    return Intl.message(
      'Hold the key shoulder against the block, clamp the key and remove the block',
      name: 'fixture8_0_0_2',
      desc: '',
      args: [],
    );
  }

  /// `remove small block`
  String get fixture8_0_1_1 {
    return Intl.message(
      'remove small block',
      name: 'fixture8_0_1_1',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in area B`
  String get fixture8_0_1_2 {
    return Intl.message(
      'Place the key in area B',
      name: 'fixture8_0_1_2',
      desc: '',
      args: [],
    );
  }

  /// `Hold the key shoulder against the block, clamp the key and remove the block`
  String get fixture8_0_1_3 {
    return Intl.message(
      'Hold the key shoulder against the block, clamp the key and remove the block',
      name: 'fixture8_0_1_3',
      desc: '',
      args: [],
    );
  }

  /// `hu66操作说明`
  String get fixturehu66 {
    return Intl.message(
      'hu66操作说明',
      name: 'fixturehu66',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in the left area。`
  String get fixture_hu66_0_1 {
    return Intl.message(
      'Place the key in the left area。',
      name: 'fixture_hu66_0_1',
      desc: '',
      args: [],
    );
  }

  /// `remove small block`
  String get fixture_hu66_1_1 {
    return Intl.message(
      'remove small block',
      name: 'fixture_hu66_1_1',
      desc: '',
      args: [],
    );
  }

  /// `Hold the shoulder of the key against the edge of the fixture,Clamp the key。`
  String get fixture_hu66_0_2 {
    return Intl.message(
      'Hold the shoulder of the key against the edge of the fixture,Clamp the key。',
      name: 'fixture_hu66_0_2',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in area A`
  String get fixture_hu66_1_2 {
    return Intl.message(
      'Place the key in area A',
      name: 'fixture_hu66_1_2',
      desc: '',
      args: [],
    );
  }

  /// `Hold the shoulder of the key against the edge of the fixture,Clamp the key。`
  String get fixture_hu66_1_3 {
    return Intl.message(
      'Hold the shoulder of the key against the edge of the fixture,Clamp the key。',
      name: 'fixture_hu66_1_3',
      desc: '',
      args: [],
    );
  }

  /// `sx9a操作说明`
  String get fixturesx9a {
    return Intl.message(
      'sx9a操作说明',
      name: 'fixturesx9a',
      desc: '',
      args: [],
    );
  }

  /// `Put the key in the area on the right`
  String get fixture_sx9a_0_1 {
    return Intl.message(
      'Put the key in the area on the right',
      name: 'fixture_sx9a_0_1',
      desc: '',
      args: [],
    );
  }

  /// `remove small block`
  String get fixture_sx9a_1_1 {
    return Intl.message(
      'remove small block',
      name: 'fixture_sx9a_1_1',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 2nd groove,Clamp the key`
  String get fixture_sx9a_0_2 {
    return Intl.message(
      'Align the head of the key with the 2nd groove,Clamp the key',
      name: 'fixture_sx9a_0_2',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in area B`
  String get fixture_sx9a_1_2 {
    return Intl.message(
      'Place the key in area B',
      name: 'fixture_sx9a_1_2',
      desc: '',
      args: [],
    );
  }

  /// `Pay attention to the level of the key`
  String get fixture_sx9a_0_3 {
    return Intl.message(
      'Pay attention to the level of the key',
      name: 'fixture_sx9a_0_3',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 2nd reference line,Clamp the key`
  String get fixture_sx9a_1_3 {
    return Intl.message(
      'Align the head of the key with the 2nd reference line,Clamp the key',
      name: 'fixture_sx9a_1_3',
      desc: '',
      args: [],
    );
  }

  /// `Pay attention to the level of the key`
  String get fixture_sx9a_1_4 {
    return Intl.message(
      'Pay attention to the level of the key',
      name: 'fixture_sx9a_1_4',
      desc: '',
      args: [],
    );
  }

  /// `Put the key in the area on the right,and insert the block。`
  String get fixture_sx9b_0_1 {
    return Intl.message(
      'Put the key in the area on the right,and insert the block。',
      name: 'fixture_sx9b_0_1',
      desc: '',
      args: [],
    );
  }

  /// `remove small block`
  String get fixture_sx9b_1_1 {
    return Intl.message(
      'remove small block',
      name: 'fixture_sx9b_1_1',
      desc: '',
      args: [],
    );
  }

  /// `Align key head with 2nd groove,Clamp the key and remove the block`
  String get fixture_sx9b_0_2 {
    return Intl.message(
      'Align key head with 2nd groove,Clamp the key and remove the block',
      name: 'fixture_sx9b_0_2',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in area B`
  String get fixture_sx9b_1_2 {
    return Intl.message(
      'Place the key in area B',
      name: 'fixture_sx9b_1_2',
      desc: '',
      args: [],
    );
  }

  /// `Pay attention to the level of the key`
  String get fixture_sx9b_0_3 {
    return Intl.message(
      'Pay attention to the level of the key',
      name: 'fixture_sx9b_0_3',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 2nd reference line`
  String get fixture_sx9b_1_3 {
    return Intl.message(
      'Align the head of the key with the 2nd reference line',
      name: 'fixture_sx9b_1_3',
      desc: '',
      args: [],
    );
  }

  /// `Pay attention to the level of the key`
  String get fixture_sx9b_1_4 {
    return Intl.message(
      'Pay attention to the level of the key',
      name: 'fixture_sx9b_1_4',
      desc: '',
      args: [],
    );
  }

  /// `民用`
  String get fixture11 {
    return Intl.message(
      '民用',
      name: 'fixture11',
      desc: '',
      args: [],
    );
  }

  /// `remove small block`
  String get fixture1_1_1 {
    return Intl.message(
      'remove small block',
      name: 'fixture1_1_1',
      desc: '',
      args: [],
    );
  }

  /// `Turn the handle to move the slider to the far right`
  String get fixture1_1_2 {
    return Intl.message(
      'Turn the handle to move the slider to the far right',
      name: 'fixture1_1_2',
      desc: '',
      args: [],
    );
  }

  /// `Loosen the D block screw and take it up`
  String get fixture1_1_3 {
    return Intl.message(
      'Loosen the D block screw and take it up',
      name: 'fixture1_1_3',
      desc: '',
      args: [],
    );
  }

  /// `Rotate the D-block 180 degrees and place back into the fixture`
  String get fixture1_1_4 {
    return Intl.message(
      'Rotate the D-block 180 degrees and place back into the fixture',
      name: 'fixture1_1_4',
      desc: '',
      args: [],
    );
  }

  /// `Place the key on the D area`
  String get fixture1_1_5 {
    return Intl.message(
      'Place the key on the D area',
      name: 'fixture1_1_5',
      desc: '',
      args: [],
    );
  }

  /// `Align the end of the key with the edge of the fixture`
  String get fixture1_1_6 {
    return Intl.message(
      'Align the end of the key with the edge of the fixture',
      name: 'fixture1_1_6',
      desc: '',
      args: [],
    );
  }

  /// `Tighten the D block`
  String get fixture1_1_7 {
    return Intl.message(
      'Tighten the D block',
      name: 'fixture1_1_7',
      desc: '',
      args: [],
    );
  }

  /// `hu64专用夹块`
  String get fixturehu64 {
    return Intl.message(
      'hu64专用夹块',
      name: 'fixturehu64',
      desc: '',
      args: [],
    );
  }

  /// `Insert the key into the HU64 fixture,locking screw`
  String get fixture_hu64_0_1 {
    return Intl.message(
      'Insert the key into the HU64 fixture,locking screw',
      name: 'fixture_hu64_0_1',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in area A`
  String get fixture_hu64_1_1 {
    return Intl.message(
      'Place the key in area A',
      name: 'fixture_hu64_1_1',
      desc: '',
      args: [],
    );
  }

  /// `Please pay attention to the horizontal state of the key`
  String get fixture_hu64_0_2 {
    return Intl.message(
      'Please pay attention to the horizontal state of the key',
      name: 'fixture_hu64_0_2',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 1st reference line,Clamp the key`
  String get fixture_hu64_1_2 {
    return Intl.message(
      'Align the head of the key with the 1st reference line,Clamp the key',
      name: 'fixture_hu64_1_2',
      desc: '',
      args: [],
    );
  }

  /// `Place the HU64 fixture on the right side of the fixture`
  String get fixture_hu64_0_3 {
    return Intl.message(
      'Place the HU64 fixture on the right side of the fixture',
      name: 'fixture_hu64_0_3',
      desc: '',
      args: [],
    );
  }

  /// `against the side of the fixture`
  String get fixture_hu64_0_4 {
    return Intl.message(
      'against the side of the fixture',
      name: 'fixture_hu64_0_4',
      desc: '',
      args: [],
    );
  }

  /// `hu101夹具说明`
  String get fixture_hu101 {
    return Intl.message(
      'hu101夹具说明',
      name: 'fixture_hu101',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in area A`
  String get fixture_hu101_1_1 {
    return Intl.message(
      'Place the key in area A',
      name: 'fixture_hu101_1_1',
      desc: '',
      args: [],
    );
  }

  /// `Move the head of the key beyond the first reference line,Clamp the key`
  String get fixture_hu101_1_2 {
    return Intl.message(
      'Move the head of the key beyond the first reference line,Clamp the key',
      name: 'fixture_hu101_1_2',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in the left area`
  String get fixture_hu101_0_1 {
    return Intl.message(
      'Place the key in the left area',
      name: 'fixture_hu101_0_1',
      desc: '',
      args: [],
    );
  }

  /// `Push the head of the key beyond the first groove,Clamp the key`
  String get fixture_hu101_0_2 {
    return Intl.message(
      'Push the head of the key beyond the first groove,Clamp the key',
      name: 'fixture_hu101_0_2',
      desc: '',
      args: [],
    );
  }

  /// `智能卡类夹具说明`
  String get smartkeyfixture {
    return Intl.message(
      '智能卡类夹具说明',
      name: 'smartkeyfixture',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in area A`
  String get fixture_smart_1_1 {
    return Intl.message(
      'Place the key in area A',
      name: 'fixture_smart_1_1',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 1st reference line`
  String get fixture_smart_1_2 {
    return Intl.message(
      'Align the head of the key with the 1st reference line',
      name: 'fixture_smart_1_2',
      desc: '',
      args: [],
    );
  }

  /// `Rotate the key 180 degrees and place it in area A`
  String get fixture_smart_1_3 {
    return Intl.message(
      'Rotate the key 180 degrees and place it in area A',
      name: 'fixture_smart_1_3',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 4th reference line`
  String get fixture_smart_1_4 {
    return Intl.message(
      'Align the head of the key with the 4th reference line',
      name: 'fixture_smart_1_4',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in the left area`
  String get fixture_smart_0_1 {
    return Intl.message(
      'Place the key in the left area',
      name: 'fixture_smart_0_1',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 1st groove`
  String get fixture_smart_0_2 {
    return Intl.message(
      'Align the head of the key with the 1st groove',
      name: 'fixture_smart_0_2',
      desc: '',
      args: [],
    );
  }

  /// `Rotate the key 180 degrees and place it in the left area`
  String get fixture_smart_0_3 {
    return Intl.message(
      'Rotate the key 180 degrees and place it in the left area',
      name: 'fixture_smart_0_3',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 4th groove,Clamp the key`
  String get fixture_smart_0_4 {
    return Intl.message(
      'Align the head of the key with the 4th groove,Clamp the key',
      name: 'fixture_smart_0_4',
      desc: '',
      args: [],
    );
  }

  /// `toy2操作说明`
  String get fixturetoy2 {
    return Intl.message(
      'toy2操作说明',
      name: 'fixturetoy2',
      desc: '',
      args: [],
    );
  }

  /// `remove small block`
  String get fixture_toy2_1_1 {
    return Intl.message(
      'remove small block',
      name: 'fixture_toy2_1_1',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in area B`
  String get fixture_toy2_1_2 {
    return Intl.message(
      'Place the key in area B',
      name: 'fixture_toy2_1_2',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 2nd reference line`
  String get fixture_toy2_1_3 {
    return Intl.message(
      'Align the head of the key with the 2nd reference line',
      name: 'fixture_toy2_1_3',
      desc: '',
      args: [],
    );
  }

  /// `Put the key in the area on the right`
  String get fixture_toy2_0_1 {
    return Intl.message(
      'Put the key in the area on the right',
      name: 'fixture_toy2_0_1',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 2nd groove`
  String get fixture_toy2_0_2 {
    return Intl.message(
      'Align the head of the key with the 2nd groove',
      name: 'fixture_toy2_0_2',
      desc: '',
      args: [],
    );
  }

  /// `remove small block`
  String get fixture_siyu2_1_1 {
    return Intl.message(
      'remove small block',
      name: 'fixture_siyu2_1_1',
      desc: '',
      args: [],
    );
  }

  /// `Turn the handle to move the slider to the far right`
  String get fixture_siyu2_1_2 {
    return Intl.message(
      'Turn the handle to move the slider to the far right',
      name: 'fixture_siyu2_1_2',
      desc: '',
      args: [],
    );
  }

  /// `Loosen the D block screw and take it up`
  String get fixture_siyu2_1_3 {
    return Intl.message(
      'Loosen the D block screw and take it up',
      name: 'fixture_siyu2_1_3',
      desc: '',
      args: [],
    );
  }

  /// `Rotate the D-block 180 degrees and place back into the fixture`
  String get fixture_siyu2_1_4 {
    return Intl.message(
      'Rotate the D-block 180 degrees and place back into the fixture',
      name: 'fixture_siyu2_1_4',
      desc: '',
      args: [],
    );
  }

  /// `Hold the block against the fixture edge`
  String get fixture_siyu2_1_5 {
    return Intl.message(
      'Hold the block against the fixture edge',
      name: 'fixture_siyu2_1_5',
      desc: '',
      args: [],
    );
  }

  /// `Place the key on the D area`
  String get fixture_siyu2_1_6 {
    return Intl.message(
      'Place the key on the D area',
      name: 'fixture_siyu2_1_6',
      desc: '',
      args: [],
    );
  }

  /// `Move the key to the left against the D block, with the head against the block`
  String get fixture_siyu2_1_7 {
    return Intl.message(
      'Move the key to the left against the D block, with the head against the block',
      name: 'fixture_siyu2_1_7',
      desc: '',
      args: [],
    );
  }

  /// `Tighten the D block`
  String get fixture_siyu2_1_8 {
    return Intl.message(
      'Tighten the D block',
      name: 'fixture_siyu2_1_8',
      desc: '',
      args: [],
    );
  }

  /// `remove small block`
  String get fixture_siyu2_1_9 {
    return Intl.message(
      'remove small block',
      name: 'fixture_siyu2_1_9',
      desc: '',
      args: [],
    );
  }

  /// `Turn the handle to move the slider to the far right`
  String get fixture_siyu2_1_10 {
    return Intl.message(
      'Turn the handle to move the slider to the far right',
      name: 'fixture_siyu2_1_10',
      desc: '',
      args: [],
    );
  }

  /// `Loosen the D block screw and take it up`
  String get fixture_siyu2_1_11 {
    return Intl.message(
      'Loosen the D block screw and take it up',
      name: 'fixture_siyu2_1_11',
      desc: '',
      args: [],
    );
  }

  /// `Rotate the D-block 180 degrees and place back into the fixture`
  String get fixture_siyu2_1_12 {
    return Intl.message(
      'Rotate the D-block 180 degrees and place back into the fixture',
      name: 'fixture_siyu2_1_12',
      desc: '',
      args: [],
    );
  }

  /// `Hold the block against the fixture edge`
  String get fixture_siyu2_1_13 {
    return Intl.message(
      'Hold the block against the fixture edge',
      name: 'fixture_siyu2_1_13',
      desc: '',
      args: [],
    );
  }

  /// `Place the key on the D area`
  String get fixture_siyu2_1_14 {
    return Intl.message(
      'Place the key on the D area',
      name: 'fixture_siyu2_1_14',
      desc: '',
      args: [],
    );
  }

  /// `Move the key to the left against the D block, with the head against the block`
  String get fixture_siyu2_1_15 {
    return Intl.message(
      'Move the key to the left against the D block, with the head against the block',
      name: 'fixture_siyu2_1_15',
      desc: '',
      args: [],
    );
  }

  /// `Tighten the D block`
  String get fixture_siyu2_1_16 {
    return Intl.message(
      'Tighten the D block',
      name: 'fixture_siyu2_1_16',
      desc: '',
      args: [],
    );
  }

  /// `remove small block`
  String get fixture_siyu1_1_1 {
    return Intl.message(
      'remove small block',
      name: 'fixture_siyu1_1_1',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in area B`
  String get fixture_siyu1_1_2 {
    return Intl.message(
      'Place the key in area B',
      name: 'fixture_siyu1_1_2',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 2nd reference line(Pay attention to the direction of the head of the key)`
  String get fixture_siyu1_1_3 {
    return Intl.message(
      'Align the head of the key with the 2nd reference line(Pay attention to the direction of the head of the key)',
      name: 'fixture_siyu1_1_3',
      desc: '',
      args: [],
    );
  }

  /// `remove small block`
  String get fixture_siyu1_1_4 {
    return Intl.message(
      'remove small block',
      name: 'fixture_siyu1_1_4',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in area B`
  String get fixture_siyu1_1_5 {
    return Intl.message(
      'Place the key in area B',
      name: 'fixture_siyu1_1_5',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 2nd reference line(Pay attention to the direction of the head of the key)`
  String get fixture_siyu1_1_6 {
    return Intl.message(
      'Align the head of the key with the 2nd reference line(Pay attention to the direction of the head of the key)',
      name: 'fixture_siyu1_1_6',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in area A`
  String get fixture_smart_1_hu101_1 {
    return Intl.message(
      'Place the key in area A',
      name: 'fixture_smart_1_hu101_1',
      desc: '',
      args: [],
    );
  }

  /// `Move the head of the key beyond the first reference line`
  String get fixture_smart_1_hu101_2 {
    return Intl.message(
      'Move the head of the key beyond the first reference line',
      name: 'fixture_smart_1_hu101_2',
      desc: '',
      args: [],
    );
  }

  /// `Rotate the key 180 degrees and place it in area A`
  String get fixture_smart_1_hu101_3 {
    return Intl.message(
      'Rotate the key 180 degrees and place it in area A',
      name: 'fixture_smart_1_hu101_3',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 4th reference line`
  String get fixture_smart_1_hu101_4 {
    return Intl.message(
      'Align the head of the key with the 4th reference line',
      name: 'fixture_smart_1_hu101_4',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in area A`
  String get fixture_smart_1_hu162ta_1 {
    return Intl.message(
      'Place the key in area A',
      name: 'fixture_smart_1_hu162ta_1',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 1st reference line`
  String get fixture_smart_1_hu162ta_2 {
    return Intl.message(
      'Align the head of the key with the 1st reference line',
      name: 'fixture_smart_1_hu162ta_2',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in area A`
  String get fixture_smart_1_hu162ta_3 {
    return Intl.message(
      'Place the key in area A',
      name: 'fixture_smart_1_hu162ta_3',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 1st reference line`
  String get fixture_smart_1_hu162ta_4 {
    return Intl.message(
      'Align the head of the key with the 1st reference line',
      name: 'fixture_smart_1_hu162ta_4',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in the C area`
  String get fixture_smart_1_hu162tb_1 {
    return Intl.message(
      'Place the key in the C area',
      name: 'fixture_smart_1_hu162tb_1',
      desc: '',
      args: [],
    );
  }

  /// `Note that the key groove is on the top`
  String get fixture_smart_1_hu162tb_2 {
    return Intl.message(
      'Note that the key groove is on the top',
      name: 'fixture_smart_1_hu162tb_2',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 1st reference line`
  String get fixture_smart_1_hu162tb_3 {
    return Intl.message(
      'Align the head of the key with the 1st reference line',
      name: 'fixture_smart_1_hu162tb_3',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in the C area`
  String get fixture_smart_1_hu162tc_1 {
    return Intl.message(
      'Place the key in the C area',
      name: 'fixture_smart_1_hu162tc_1',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 1st reference line`
  String get fixture_smart_1_hu162tc_2 {
    return Intl.message(
      'Align the head of the key with the 1st reference line',
      name: 'fixture_smart_1_hu162tc_2',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in the left area`
  String get fixture_smart_0_hu101_1 {
    return Intl.message(
      'Place the key in the left area',
      name: 'fixture_smart_0_hu101_1',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 1st reference line`
  String get fixture_smart_0_hu101_2 {
    return Intl.message(
      'Align the head of the key with the 1st reference line',
      name: 'fixture_smart_0_hu101_2',
      desc: '',
      args: [],
    );
  }

  /// `Rotate the key 180 degrees and place it in the left area`
  String get fixture_smart_0_hu101_3 {
    return Intl.message(
      'Rotate the key 180 degrees and place it in the left area',
      name: 'fixture_smart_0_hu101_3',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 4th groove`
  String get fixture_smart_0_hu101_4 {
    return Intl.message(
      'Align the head of the key with the 4th groove',
      name: 'fixture_smart_0_hu101_4',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in the left area`
  String get fixture_smart_0_hu162ta_1 {
    return Intl.message(
      'Place the key in the left area',
      name: 'fixture_smart_0_hu162ta_1',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 1st groove`
  String get fixture_smart_0_hu162ta_2 {
    return Intl.message(
      'Align the head of the key with the 1st groove',
      name: 'fixture_smart_0_hu162ta_2',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in the left area`
  String get fixture_smart_0_hu162ta_3 {
    return Intl.message(
      'Place the key in the left area',
      name: 'fixture_smart_0_hu162ta_3',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 1st groove`
  String get fixture_smart_0_hu162ta_4 {
    return Intl.message(
      'Align the head of the key with the 1st groove',
      name: 'fixture_smart_0_hu162ta_4',
      desc: '',
      args: [],
    );
  }

  /// `Rotate the key 180 degrees and place it in the lower left area`
  String get fixture_smart_0_hu162tb_1 {
    return Intl.message(
      'Rotate the key 180 degrees and place it in the lower left area',
      name: 'fixture_smart_0_hu162tb_1',
      desc: '',
      args: [],
    );
  }

  /// `Note that the key groove is on the top`
  String get fixture_smart_0_hu162tb_2 {
    return Intl.message(
      'Note that the key groove is on the top',
      name: 'fixture_smart_0_hu162tb_2',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 1st groove`
  String get fixture_smart_0_hu162tb_3 {
    return Intl.message(
      'Align the head of the key with the 1st groove',
      name: 'fixture_smart_0_hu162tb_3',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in the lower left area`
  String get fixture_smart_0_hu162tc_1 {
    return Intl.message(
      'Place the key in the lower left area',
      name: 'fixture_smart_0_hu162tc_1',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 1st groove`
  String get fixture_smart_0_hu162tc_2 {
    return Intl.message(
      'Align the head of the key with the 1st groove',
      name: 'fixture_smart_0_hu162tc_2',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in the left area`
  String get fixture_hu162ta_0_1 {
    return Intl.message(
      'Place the key in the left area',
      name: 'fixture_hu162ta_0_1',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 1st groove`
  String get fixture_hu162ta_0_2 {
    return Intl.message(
      'Align the head of the key with the 1st groove',
      name: 'fixture_hu162ta_0_2',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in the left area`
  String get fixture_hu162ta_0_3 {
    return Intl.message(
      'Place the key in the left area',
      name: 'fixture_hu162ta_0_3',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 1st groove`
  String get fixture_hu162ta_0_4 {
    return Intl.message(
      'Align the head of the key with the 1st groove',
      name: 'fixture_hu162ta_0_4',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in the lower left area`
  String get fixture_hu162tb_0_1 {
    return Intl.message(
      'Place the key in the lower left area',
      name: 'fixture_hu162tb_0_1',
      desc: '',
      args: [],
    );
  }

  /// `Note that the key groove is on the top`
  String get fixture_hu162tb_0_2 {
    return Intl.message(
      'Note that the key groove is on the top',
      name: 'fixture_hu162tb_0_2',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 1st groove`
  String get fixture_hu162tb_0_3 {
    return Intl.message(
      'Align the head of the key with the 1st groove',
      name: 'fixture_hu162tb_0_3',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in the lower left area`
  String get fixture_hu162tc_0_1 {
    return Intl.message(
      'Place the key in the lower left area',
      name: 'fixture_hu162tc_0_1',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 1st groove`
  String get fixture_hu162tc_0_2 {
    return Intl.message(
      'Align the head of the key with the 1st groove',
      name: 'fixture_hu162tc_0_2',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in area A`
  String get fixture_hu162ta_1_1 {
    return Intl.message(
      'Place the key in area A',
      name: 'fixture_hu162ta_1_1',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 1st reference line`
  String get fixture_hu162ta_1_2 {
    return Intl.message(
      'Align the head of the key with the 1st reference line',
      name: 'fixture_hu162ta_1_2',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in area A`
  String get fixture_hu162ta_1_3 {
    return Intl.message(
      'Place the key in area A',
      name: 'fixture_hu162ta_1_3',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 1st reference line`
  String get fixture_hu162ta_1_4 {
    return Intl.message(
      'Align the head of the key with the 1st reference line',
      name: 'fixture_hu162ta_1_4',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in the C area`
  String get fixture_hu162tb_1_1 {
    return Intl.message(
      'Place the key in the C area',
      name: 'fixture_hu162tb_1_1',
      desc: '',
      args: [],
    );
  }

  /// `Note that the key groove is on the top`
  String get fixture_hu162tb_1_2 {
    return Intl.message(
      'Note that the key groove is on the top',
      name: 'fixture_hu162tb_1_2',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 1st reference line`
  String get fixture_hu162tb_1_3 {
    return Intl.message(
      'Align the head of the key with the 1st reference line',
      name: 'fixture_hu162tb_1_3',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in the C area`
  String get fixture_hu162tc_1_1 {
    return Intl.message(
      'Place the key in the C area',
      name: 'fixture_hu162tc_1_1',
      desc: '',
      args: [],
    );
  }

  /// `Align the head of the key with the 1st reference line`
  String get fixture_hu162tc_1_2 {
    return Intl.message(
      'Align the head of the key with the 1st reference line',
      name: 'fixture_hu162tc_1_2',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in area A`
  String get fixture_non_1_1_1 {
    return Intl.message(
      'Place the key in area A',
      name: 'fixture_non_1_1_1',
      desc: '',
      args: [],
    );
  }

  /// `Hold the head of the key against the probe`
  String get fixture_non_1_1_2 {
    return Intl.message(
      'Hold the head of the key against the probe',
      name: 'fixture_non_1_1_2',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in the left area`
  String get fixture_non_0_1_1 {
    return Intl.message(
      'Place the key in the left area',
      name: 'fixture_non_0_1_1',
      desc: '',
      args: [],
    );
  }

  /// `Hold the head of the key against the probe`
  String get fixture_non_0_1_2 {
    return Intl.message(
      'Hold the head of the key against the probe',
      name: 'fixture_non_0_1_2',
      desc: '',
      args: [],
    );
  }

  /// `模型加工文字说明`
  String get fixture_model {
    return Intl.message(
      '模型加工文字说明',
      name: 'fixture_model',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in area A`
  String get fixture_model_1_1_1 {
    return Intl.message(
      'Place the key in area A',
      name: 'fixture_model_1_1_1',
      desc: '',
      args: [],
    );
  }

  /// `Align the end of the key with the fourth reference line`
  String get fixture_model_1_1_2 {
    return Intl.message(
      'Align the end of the key with the fourth reference line',
      name: 'fixture_model_1_1_2',
      desc: '',
      args: [],
    );
  }

  /// `Flip the key and place it in the A area`
  String get fixture_model_1_2_1 {
    return Intl.message(
      'Flip the key and place it in the A area',
      name: 'fixture_model_1_2_1',
      desc: '',
      args: [],
    );
  }

  /// `Align the end of the key with the fourth reference line`
  String get fixture_model_1_2_2 {
    return Intl.message(
      'Align the end of the key with the fourth reference line',
      name: 'fixture_model_1_2_2',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in the C area`
  String get fixture_model_1_3_1 {
    return Intl.message(
      'Place the key in the C area',
      name: 'fixture_model_1_3_1',
      desc: '',
      args: [],
    );
  }

  /// `Align the end of the key with the fourth reference line`
  String get fixture_model_1_3_2 {
    return Intl.message(
      'Align the end of the key with the fourth reference line',
      name: 'fixture_model_1_3_2',
      desc: '',
      args: [],
    );
  }

  /// `Flip the key and place it in the C area`
  String get fixture_model_1_4_1 {
    return Intl.message(
      'Flip the key and place it in the C area',
      name: 'fixture_model_1_4_1',
      desc: '',
      args: [],
    );
  }

  /// `Align the end of the key with the fourth reference line`
  String get fixture_model_1_4_2 {
    return Intl.message(
      'Align the end of the key with the fourth reference line',
      name: 'fixture_model_1_4_2',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in the left area`
  String get fixture_model_0_1_1 {
    return Intl.message(
      'Place the key in the left area',
      name: 'fixture_model_0_1_1',
      desc: '',
      args: [],
    );
  }

  /// `Align the end of the key with the 4th groove`
  String get fixture_model_0_1_2 {
    return Intl.message(
      'Align the end of the key with the 4th groove',
      name: 'fixture_model_0_1_2',
      desc: '',
      args: [],
    );
  }

  /// `The flip key is placed in the left area`
  String get fixture_model_0_2_1 {
    return Intl.message(
      'The flip key is placed in the left area',
      name: 'fixture_model_0_2_1',
      desc: '',
      args: [],
    );
  }

  /// `Align the end of the key with the 4th groove`
  String get fixture_model_0_2_2 {
    return Intl.message(
      'Align the end of the key with the 4th groove',
      name: 'fixture_model_0_2_2',
      desc: '',
      args: [],
    );
  }

  /// `Place the key in the lower left area`
  String get fixture_model_0_3_1 {
    return Intl.message(
      'Place the key in the lower left area',
      name: 'fixture_model_0_3_1',
      desc: '',
      args: [],
    );
  }

  /// `Align the end of the key with the 4th groove`
  String get fixture_model_0_3_2 {
    return Intl.message(
      'Align the end of the key with the 4th groove',
      name: 'fixture_model_0_3_2',
      desc: '',
      args: [],
    );
  }

  /// `The flip key is placed in the lower left area`
  String get fixture_model_0_4_1 {
    return Intl.message(
      'The flip key is placed in the lower left area',
      name: 'fixture_model_0_4_1',
      desc: '',
      args: [],
    );
  }

  /// `Align the end of the key with the 4th groove`
  String get fixture_model_0_4_2 {
    return Intl.message(
      'Align the end of the key with the 4th groove',
      name: 'fixture_model_0_4_2',
      desc: '',
      args: [],
    );
  }

  /// `30 cannot be entered`
  String get readtoolsno30 {
    return Intl.message(
      '30 cannot be entered',
      name: 'readtoolsno30',
      desc: '',
      args: [],
    );
  }

  /// `90 cannot be entered`
  String get readtoolsno90 {
    return Intl.message(
      '90 cannot be entered',
      name: 'readtoolsno90',
      desc: '',
      args: [],
    );
  }

  /// `Insert cutter, probe and push to the top`
  String get inxdpz {
    return Intl.message(
      'Insert cutter, probe and push to the top',
      name: 'inxdpz',
      desc: '',
      args: [],
    );
  }

  /// `Lock the cutter and probe in order`
  String get lockxdpz {
    return Intl.message(
      'Lock the cutter and probe in order',
      name: 'lockxdpz',
      desc: '',
      args: [],
    );
  }

  /// `Loosen the fixing screw of the probe and pull the probe down against the fixture platform`
  String get releasepz {
    return Intl.message(
      'Loosen the fixing screw of the probe and pull the probe down against the fixture platform',
      name: 'releasepz',
      desc: '',
      args: [],
    );
  }

  /// `Tighten the fixing screw of the probe to complete the operation of replacing the cutter and the probe`
  String get lockpz {
    return Intl.message(
      'Tighten the fixing screw of the probe to complete the operation of replacing the cutter and the probe',
      name: 'lockpz',
      desc: '',
      args: [],
    );
  }

  /// `Do not remove the key`
  String get dontremovekey {
    return Intl.message(
      'Do not remove the key',
      name: 'dontremovekey',
      desc: '',
      args: [],
    );
  }

  /// `After cleaning the fixture, press OK to continue`
  String get clearnfixture {
    return Intl.message(
      'After cleaning the fixture, press OK to continue',
      name: 'clearnfixture',
      desc: '',
      args: [],
    );
  }

  /// `Current calibration data`
  String get currentdata {
    return Intl.message(
      'Current calibration data',
      name: 'currentdata',
      desc: '',
      args: [],
    );
  }

  /// `Need to download resources first`
  String get needdownloaddata {
    return Intl.message(
      'Need to download resources first',
      name: 'needdownloaddata',
      desc: '',
      args: [],
    );
  }

  /// `Can only be used after login`
  String get needlogin {
    return Intl.message(
      'Can only be used after login',
      name: 'needlogin',
      desc: '',
      args: [],
    );
  }

  /// `other pages`
  String get othermainpage {
    return Intl.message(
      'other pages',
      name: 'othermainpage',
      desc: '',
      args: [],
    );
  }

  /// `News Center`
  String get news {
    return Intl.message(
      'News Center',
      name: 'news',
      desc: '',
      args: [],
    );
  }

  /// `Product Center`
  String get product {
    return Intl.message(
      'Product Center',
      name: 'product',
      desc: '',
      args: [],
    );
  }

  /// `shop`
  String get mall {
    return Intl.message(
      'shop',
      name: 'mall',
      desc: '',
      args: [],
    );
  }

  /// `Technical Support`
  String get tech {
    return Intl.message(
      'Technical Support',
      name: 'tech',
      desc: '',
      args: [],
    );
  }

  /// `video tutorial`
  String get video {
    return Intl.message(
      'video tutorial',
      name: 'video',
      desc: '',
      args: [],
    );
  }

  /// `Technical Documentation`
  String get word {
    return Intl.message(
      'Technical Documentation',
      name: 'word',
      desc: '',
      args: [],
    );
  }

  /// `key information`
  String get keydata {
    return Intl.message(
      'key information',
      name: 'keydata',
      desc: '',
      args: [],
    );
  }

  /// `Apply for development`
  String get development {
    return Intl.message(
      'Apply for development',
      name: 'development',
      desc: '',
      args: [],
    );
  }

  /// `feedback and suggestions`
  String get suggest {
    return Intl.message(
      'feedback and suggestions',
      name: 'suggest',
      desc: '',
      args: [],
    );
  }

  /// `personal center`
  String get usercenter {
    return Intl.message(
      'personal center',
      name: 'usercenter',
      desc: '',
      args: [],
    );
  }

  /// `Points query`
  String get integralquery {
    return Intl.message(
      'Points query',
      name: 'integralquery',
      desc: '',
      args: [],
    );
  }

  /// `online service`
  String get customer {
    return Intl.message(
      'online service',
      name: 'customer',
      desc: '',
      args: [],
    );
  }

  /// `APP settings`
  String get appsetting {
    return Intl.message(
      'APP settings',
      name: 'appsetting',
      desc: '',
      args: [],
    );
  }

  /// `view`
  String get carlistmodel {
    return Intl.message(
      'view',
      name: 'carlistmodel',
      desc: '',
      args: [],
    );
  }

  /// `cuts`
  String get keycuts {
    return Intl.message(
      'cuts',
      name: 'keycuts',
      desc: '',
      args: [],
    );
  }

  /// `Please enter key name`
  String get inputkeyname {
    return Intl.message(
      'Please enter key name',
      name: 'inputkeyname',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a brand name`
  String get intputcarname {
    return Intl.message(
      'Please enter a brand name',
      name: 'intputcarname',
      desc: '',
      args: [],
    );
  }

  /// `all keys`
  String get allkeydata {
    return Intl.message(
      'all keys',
      name: 'allkeydata',
      desc: '',
      args: [],
    );
  }

  /// `Please wait for the machine to stop, use the metal to touch the cutter and fixture at the same time to test the conductivity of the cutter, or touch the probe and the fixture at the same time to test the conductivity of the probe.`
  String get xdpzchecktip {
    return Intl.message(
      'Please wait for the machine to stop, use the metal to touch the cutter and fixture at the same time to test the conductivity of the cutter, or touch the probe and the fixture at the same time to test the conductivity of the probe.',
      name: 'xdpzchecktip',
      desc: '',
      args: [],
    );
  }

  /// `password`
  String get pw {
    return Intl.message(
      'password',
      name: 'pw',
      desc: '',
      args: [],
    );
  }

  /// `register`
  String get register {
    return Intl.message(
      'register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Registration failed, account already exists`
  String get registererror {
    return Intl.message(
      'Registration failed, account already exists',
      name: 'registererror',
      desc: '',
      args: [],
    );
  }

  /// `automatic log-in`
  String get autologin {
    return Intl.message(
      'automatic log-in',
      name: 'autologin',
      desc: '',
      args: [],
    );
  }

  /// `Please tick to agree to the service agreement`
  String get needagreed {
    return Intl.message(
      'Please tick to agree to the service agreement',
      name: 'needagreed',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password`
  String get forgetpw {
    return Intl.message(
      'Forgot password',
      name: 'forgetpw',
      desc: '',
      args: [],
    );
  }

  /// `change Password`
  String get chanagepw {
    return Intl.message(
      'change Password',
      name: 'chanagepw',
      desc: '',
      args: [],
    );
  }

  /// `The two entered passwords do not match`
  String get pwnotmatch {
    return Intl.message(
      'The two entered passwords do not match',
      name: 'pwnotmatch',
      desc: '',
      args: [],
    );
  }

  /// `user`
  String get user {
    return Intl.message(
      'user',
      name: 'user',
      desc: '',
      args: [],
    );
  }

  /// `my account`
  String get myaccount {
    return Intl.message(
      'my account',
      name: 'myaccount',
      desc: '',
      args: [],
    );
  }

  /// `Nickname`
  String get username {
    return Intl.message(
      'Nickname',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `points`
  String get token {
    return Intl.message(
      'points',
      name: 'token',
      desc: '',
      args: [],
    );
  }

  /// `sign out`
  String get outlogin {
    return Intl.message(
      'sign out',
      name: 'outlogin',
      desc: '',
      args: [],
    );
  }

  /// `Whether to log out of this account`
  String get outlogintip {
    return Intl.message(
      'Whether to log out of this account',
      name: 'outlogintip',
      desc: '',
      args: [],
    );
  }

  /// `logging in..`
  String get logining {
    return Intl.message(
      'logging in..',
      name: 'logining',
      desc: '',
      args: [],
    );
  }

  /// `Personal information`
  String get userinfo {
    return Intl.message(
      'Personal information',
      name: 'userinfo',
      desc: '',
      args: [],
    );
  }

  /// `Login failed`
  String get loginerror {
    return Intl.message(
      'Login failed',
      name: 'loginerror',
      desc: '',
      args: [],
    );
  }

  /// `version number`
  String get ver {
    return Intl.message(
      'version number',
      name: 'ver',
      desc: '',
      args: [],
    );
  }

  /// `I have agreed`
  String get agreed {
    return Intl.message(
      'I have agreed',
      name: 'agreed',
      desc: '',
      args: [],
    );
  }

  /// `Please enter account`
  String get inputuser {
    return Intl.message(
      'Please enter account',
      name: 'inputuser',
      desc: '',
      args: [],
    );
  }

  /// `Please enter password`
  String get inputpw {
    return Intl.message(
      'Please enter password',
      name: 'inputpw',
      desc: '',
      args: [],
    );
  }

  /// `show password`
  String get showpw {
    return Intl.message(
      'show password',
      name: 'showpw',
      desc: '',
      args: [],
    );
  }

  /// `Please enter password`
  String get inputpwagain {
    return Intl.message(
      'Please enter password',
      name: 'inputpwagain',
      desc: '',
      args: [],
    );
  }

  /// `Account length must be greater than 5 digits, password length must be greater than 3 digits`
  String get logintip {
    return Intl.message(
      'Account length must be greater than 5 digits, password length must be greater than 3 digits',
      name: 'logintip',
      desc: '',
      args: [],
    );
  }

  /// `Imprint`
  String get direction {
    return Intl.message(
      'Imprint',
      name: 'direction',
      desc: '',
      args: [],
    );
  }

  /// `whether to upgrade to:`
  String get askupgrade {
    return Intl.message(
      'whether to upgrade to:',
      name: 'askupgrade',
      desc: '',
      args: [],
    );
  }

  /// `during upgrade. .`
  String get upgrading {
    return Intl.message(
      'during upgrade. .',
      name: 'upgrading',
      desc: '',
      args: [],
    );
  }

  /// `update succeeded`
  String get upgradeok {
    return Intl.message(
      'update succeeded',
      name: 'upgradeok',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade failed, please check and try again`
  String get upgradeerror {
    return Intl.message(
      'Upgrade failed, please check and try again',
      name: 'upgradeerror',
      desc: '',
      args: [],
    );
  }

  /// `downloading`
  String get downing {
    return Intl.message(
      'downloading',
      name: 'downing',
      desc: '',
      args: [],
    );
  }

  /// `Unzip`
  String get unzip {
    return Intl.message(
      'Unzip',
      name: 'unzip',
      desc: '',
      args: [],
    );
  }

  /// `Unzip Finish`
  String get unzipok {
    return Intl.message(
      'Unzip Finish',
      name: 'unzipok',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message(
      'Type',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `local version`
  String get locatver {
    return Intl.message(
      'local version',
      name: 'locatver',
      desc: '',
      args: [],
    );
  }

  /// `server version`
  String get netver {
    return Intl.message(
      'server version',
      name: 'netver',
      desc: '',
      args: [],
    );
  }

  /// `App is already the latest version`
  String get appnotup {
    return Intl.message(
      'App is already the latest version',
      name: 'appnotup',
      desc: '',
      args: [],
    );
  }

  /// `APP version`
  String get appver {
    return Intl.message(
      'APP version',
      name: 'appver',
      desc: '',
      args: [],
    );
  }

  /// `New APP detected, version number:`
  String get checkapptip {
    return Intl.message(
      'New APP detected, version number:',
      name: 'checkapptip',
      desc: '',
      args: [],
    );
  }

  /// `New data detected, version number:`
  String get checkdatatip {
    return Intl.message(
      'New data detected, version number:',
      name: 'checkdatatip',
      desc: '',
      args: [],
    );
  }

  /// `New firmware detected, version number:`
  String get checkfirmwaretip {
    return Intl.message(
      'New firmware detected, version number:',
      name: 'checkfirmwaretip',
      desc: '',
      args: [],
    );
  }

  /// `update content:`
  String get checktip {
    return Intl.message(
      'update content:',
      name: 'checktip',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a new nickname`
  String get inputnewusername {
    return Intl.message(
      'Please enter a new nickname',
      name: 'inputnewusername',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a new email`
  String get inputnewemail {
    return Intl.message(
      'Please enter a new email',
      name: 'inputnewemail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a new address`
  String get inputnewadress {
    return Intl.message(
      'Please enter a new address',
      name: 'inputnewadress',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a new QQ number`
  String get newqqnumber {
    return Intl.message(
      'Please enter a new QQ number',
      name: 'newqqnumber',
      desc: '',
      args: [],
    );
  }

  /// `update immediately`
  String get updatanow {
    return Intl.message(
      'update immediately',
      name: 'updatanow',
      desc: '',
      args: [],
    );
  }

  /// `The machine is initializing`
  String get errcode1 {
    return Intl.message(
      'The machine is initializing',
      name: 'errcode1',
      desc: '',
      args: [],
    );
  }

  /// `machine reading process`
  String get errcode2 {
    return Intl.message(
      'machine reading process',
      name: 'errcode2',
      desc: '',
      args: [],
    );
  }

  /// `Machines interpret data`
  String get errcode3 {
    return Intl.message(
      'Machines interpret data',
      name: 'errcode3',
      desc: '',
      args: [],
    );
  }

  /// `machine cutting process`
  String get errcode4 {
    return Intl.message(
      'machine cutting process',
      name: 'errcode4',
      desc: '',
      args: [],
    );
  }

  /// `Machine stops operating`
  String get errcode5 {
    return Intl.message(
      'Machine stops operating',
      name: 'errcode5',
      desc: '',
      args: [],
    );
  }

  /// `machine correction`
  String get errcode6 {
    return Intl.message(
      'machine correction',
      name: 'errcode6',
      desc: '',
      args: [],
    );
  }

  /// `Cutter and probe conductivity detection`
  String get errcode7 {
    return Intl.message(
      'Cutter and probe conductivity detection',
      name: 'errcode7',
      desc: '',
      args: [],
    );
  }

  /// `Stepper motor moves freely`
  String get errcode8 {
    return Intl.message(
      'Stepper motor moves freely',
      name: 'errcode8',
      desc: '',
      args: [],
    );
  }

  /// `Change the cutter or probe`
  String get errcode9 {
    return Intl.message(
      'Change the cutter or probe',
      name: 'errcode9',
      desc: '',
      args: [],
    );
  }

  /// `Fixture parameter measurement`
  String get errcode10 {
    return Intl.message(
      'Fixture parameter measurement',
      name: 'errcode10',
      desc: '',
      args: [],
    );
  }

  /// `Stepper Motor Movement Accuracy Measurement`
  String get errcode11 {
    return Intl.message(
      'Stepper Motor Movement Accuracy Measurement',
      name: 'errcode11',
      desc: '',
      args: [],
    );
  }

  /// `Machine cutting accuracy measurement`
  String get errcode12 {
    return Intl.message(
      'Machine cutting accuracy measurement',
      name: 'errcode12',
      desc: '',
      args: [],
    );
  }

  /// `Confirming fixture...`
  String get errcode13 {
    return Intl.message(
      'Confirming fixture...',
      name: 'errcode13',
      desc: '',
      args: [],
    );
  }

  /// `reading...`
  String get errcode14 {
    return Intl.message(
      'reading...',
      name: 'errcode14',
      desc: '',
      args: [],
    );
  }

  /// `cutting...`
  String get errcode15 {
    return Intl.message(
      'cutting...',
      name: 'errcode15',
      desc: '',
      args: [],
    );
  }

  /// `X axis is running`
  String get errcode16 {
    return Intl.message(
      'X axis is running',
      name: 'errcode16',
      desc: '',
      args: [],
    );
  }

  /// `Y axis is running`
  String get errcode17 {
    return Intl.message(
      'Y axis is running',
      name: 'errcode17',
      desc: '',
      args: [],
    );
  }

  /// `Z axis is running`
  String get errcode18 {
    return Intl.message(
      'Z axis is running',
      name: 'errcode18',
      desc: '',
      args: [],
    );
  }

  /// `W axis is running`
  String get errcode19 {
    return Intl.message(
      'W axis is running',
      name: 'errcode19',
      desc: '',
      args: [],
    );
  }

  /// `Probe abnormal Contact`
  String get errcode20 {
    return Intl.message(
      'Probe abnormal Contact',
      name: 'errcode20',
      desc: '',
      args: [],
    );
  }

  /// `Cutter abnormal Contact`
  String get errcode21 {
    return Intl.message(
      'Cutter abnormal Contact',
      name: 'errcode21',
      desc: '',
      args: [],
    );
  }

  /// `probe not conducting`
  String get errcode22 {
    return Intl.message(
      'probe not conducting',
      name: 'errcode22',
      desc: '',
      args: [],
    );
  }

  /// `Cutter not conducting`
  String get errcode23 {
    return Intl.message(
      'Cutter not conducting',
      name: 'errcode23',
      desc: '',
      args: [],
    );
  }

  /// `Photoelectric abnormal contact`
  String get errcode24 {
    return Intl.message(
      'Photoelectric abnormal contact',
      name: 'errcode24',
      desc: '',
      args: [],
    );
  }

  /// `X Photoelectric abnormal contact`
  String get errcode25 {
    return Intl.message(
      'X Photoelectric abnormal contact',
      name: 'errcode25',
      desc: '',
      args: [],
    );
  }

  /// `X Photoelectric not conducting`
  String get errcode26 {
    return Intl.message(
      'X Photoelectric not conducting',
      name: 'errcode26',
      desc: '',
      args: [],
    );
  }

  /// `Y Photoelectric abnormal contact`
  String get errcode27 {
    return Intl.message(
      'Y Photoelectric abnormal contact',
      name: 'errcode27',
      desc: '',
      args: [],
    );
  }

  /// `Y Photoelectric not conducting`
  String get errcode28 {
    return Intl.message(
      'Y Photoelectric not conducting',
      name: 'errcode28',
      desc: '',
      args: [],
    );
  }

  /// `Z Photoelectric abnormal contact`
  String get errcode29 {
    return Intl.message(
      'Z Photoelectric abnormal contact',
      name: 'errcode29',
      desc: '',
      args: [],
    );
  }

  /// `Z Photoelectric not conducting`
  String get errcode30 {
    return Intl.message(
      'Z Photoelectric not conducting',
      name: 'errcode30',
      desc: '',
      args: [],
    );
  }

  /// `Not calibrated`
  String get errcode31 {
    return Intl.message(
      'Not calibrated',
      name: 'errcode31',
      desc: '',
      args: [],
    );
  }

  /// `Bluetooth disconnects abnormally`
  String get errcode32 {
    return Intl.message(
      'Bluetooth disconnects abnormally',
      name: 'errcode32',
      desc: '',
      args: [],
    );
  }

  /// `pulse too high`
  String get errcode33 {
    return Intl.message(
      'pulse too high',
      name: 'errcode33',
      desc: '',
      args: [],
    );
  }

  /// `pulse too low`
  String get errcode34 {
    return Intl.message(
      'pulse too low',
      name: 'errcode34',
      desc: '',
      args: [],
    );
  }

  /// `Cutting may cut to the top of the fixture`
  String get errcode35 {
    return Intl.message(
      'Cutting may cut to the top of the fixture',
      name: 'errcode35',
      desc: '',
      args: [],
    );
  }

  /// `Cutting may cut to the side of the fixture`
  String get errcode36 {
    return Intl.message(
      'Cutting may cut to the side of the fixture',
      name: 'errcode36',
      desc: '',
      args: [],
    );
  }

  /// `probe is not installed correctly`
  String get errcode37 {
    return Intl.message(
      'probe is not installed correctly',
      name: 'errcode37',
      desc: '',
      args: [],
    );
  }

  /// `cutter is not installed correctly`
  String get errcode38 {
    return Intl.message(
      'cutter is not installed correctly',
      name: 'errcode38',
      desc: '',
      args: [],
    );
  }

  /// `probe gets data error`
  String get errcode39 {
    return Intl.message(
      'probe gets data error',
      name: 'errcode39',
      desc: '',
      args: [],
    );
  }

  /// `Brushless motor does not start normally`
  String get errcode40 {
    return Intl.message(
      'Brushless motor does not start normally',
      name: 'errcode40',
      desc: '',
      args: [],
    );
  }

  /// `XY read data error`
  String get errcode41 {
    return Intl.message(
      'XY read data error',
      name: 'errcode41',
      desc: '',
      args: [],
    );
  }

  /// `Y read data error`
  String get errcode42 {
    return Intl.message(
      'Y read data error',
      name: 'errcode42',
      desc: '',
      args: [],
    );
  }

  /// `over time`
  String get errcode43 {
    return Intl.message(
      'over time',
      name: 'errcode43',
      desc: '',
      args: [],
    );
  }

  /// `Battery voltage is too low`
  String get errcode44 {
    return Intl.message(
      'Battery voltage is too low',
      name: 'errcode44',
      desc: '',
      args: [],
    );
  }

  /// `The current key can no longer be calibrated`
  String get errcode45 {
    return Intl.message(
      'The current key can no longer be calibrated',
      name: 'errcode45',
      desc: '',
      args: [],
    );
  }

  /// `The key is not placed in the correct position`
  String get errcode46 {
    return Intl.message(
      'The key is not placed in the correct position',
      name: 'errcode46',
      desc: '',
      args: [],
    );
  }

  /// `The calibrated fixture does not match the selected fixture`
  String get errcode47 {
    return Intl.message(
      'The calibrated fixture does not match the selected fixture',
      name: 'errcode47',
      desc: '',
      args: [],
    );
  }

  /// `The fixture is not calibrated, please calibrate the fixture first`
  String get errcode48 {
    return Intl.message(
      'The fixture is not calibrated, please calibrate the fixture first',
      name: 'errcode48',
      desc: '',
      args: [],
    );
  }

  /// `Please remove the block`
  String get errcode49 {
    return Intl.message(
      'Please remove the block',
      name: 'errcode49',
      desc: '',
      args: [],
    );
  }

  /// `no key of this type`
  String get notypekey {
    return Intl.message(
      'no key of this type',
      name: 'notypekey',
      desc: '',
      args: [],
    );
  }

  /// `create key`
  String get createkey {
    return Intl.message(
      'create key',
      name: 'createkey',
      desc: '',
      args: [],
    );
  }

  /// `Measurement Creation Key`
  String get measurekey {
    return Intl.message(
      'Measurement Creation Key',
      name: 'measurekey',
      desc: '',
      args: [],
    );
  }

  /// `intelligent create key`
  String get smartcreatekey {
    return Intl.message(
      'intelligent create key',
      name: 'smartcreatekey',
      desc: '',
      args: [],
    );
  }

  /// `Shared success`
  String get shareok {
    return Intl.message(
      'Shared success',
      name: 'shareok',
      desc: '',
      args: [],
    );
  }

  /// `Share failed`
  String get shareerror {
    return Intl.message(
      'Share failed',
      name: 'shareerror',
      desc: '',
      args: [],
    );
  }

  /// `Turn off Share`
  String get shareclose {
    return Intl.message(
      'Turn off Share',
      name: 'shareclose',
      desc: '',
      args: [],
    );
  }

  /// `Whether to cancel Share`
  String get shareclosetip {
    return Intl.message(
      'Whether to cancel Share',
      name: 'shareclosetip',
      desc: '',
      args: [],
    );
  }

  /// `Whether to share data`
  String get sharetip {
    return Intl.message(
      'Whether to share data',
      name: 'sharetip',
      desc: '',
      args: [],
    );
  }

  /// `Please use it once before share`
  String get sharetip2 {
    return Intl.message(
      'Please use it once before share',
      name: 'sharetip2',
      desc: '',
      args: [],
    );
  }

  /// `already share`
  String get sharestate1 {
    return Intl.message(
      'already share',
      name: 'sharestate1',
      desc: '',
      args: [],
    );
  }

  /// `share`
  String get sharestate2 {
    return Intl.message(
      'share',
      name: 'sharestate2',
      desc: '',
      args: [],
    );
  }

  /// `key name`
  String get keyname {
    return Intl.message(
      'key name',
      name: 'keyname',
      desc: '',
      args: [],
    );
  }

  /// `This resource already exists, no need to download`
  String get havedata {
    return Intl.message(
      'This resource already exists, no need to download',
      name: 'havedata',
      desc: '',
      args: [],
    );
  }

  /// `Whether to download this resource, this resource needs to consume credits:`
  String get askdowndata {
    return Intl.message(
      'Whether to download this resource, this resource needs to consume credits:',
      name: 'askdowndata',
      desc: '',
      args: [],
    );
  }

  /// `Failed to close share`
  String get sharecloseerror {
    return Intl.message(
      'Failed to close share',
      name: 'sharecloseerror',
      desc: '',
      args: [],
    );
  }

  /// `Choose how many points can be downloaded`
  String get plaseseletoken {
    return Intl.message(
      'Choose how many points can be downloaded',
      name: 'plaseseletoken',
      desc: '',
      args: [],
    );
  }

  /// `shared market`
  String get sharesmart {
    return Intl.message(
      'shared market',
      name: 'sharesmart',
      desc: '',
      args: [],
    );
  }

  /// `Not enough points`
  String get tokenno {
    return Intl.message(
      'Not enough points',
      name: 'tokenno',
      desc: '',
      args: [],
    );
  }

  /// `The depth of cut needs to be less than the key thickness`
  String get diykeytip1 {
    return Intl.message(
      'The depth of cut needs to be less than the key thickness',
      name: 'diykeytip1',
      desc: '',
      args: [],
    );
  }

  /// `The inner groove width needs to be smaller than the key width`
  String get diykeytip2 {
    return Intl.message(
      'The inner groove width needs to be smaller than the key width',
      name: 'diykeytip2',
      desc: '',
      args: [],
    );
  }

  /// `position must be arranged from largest to smallest`
  String get diykeytip3 {
    return Intl.message(
      'position must be arranged from largest to smallest',
      name: 'diykeytip3',
      desc: '',
      args: [],
    );
  }

  /// `position must be greater than 0`
  String get diykeytip4 {
    return Intl.message(
      'position must be greater than 0',
      name: 'diykeytip4',
      desc: '',
      args: [],
    );
  }

  /// `B position must be arranged from largest to smallest`
  String get diykeytip5 {
    return Intl.message(
      'B position must be arranged from largest to smallest',
      name: 'diykeytip5',
      desc: '',
      args: [],
    );
  }

  /// `position must be arranged from small to large`
  String get diykeytip6 {
    return Intl.message(
      'position must be arranged from small to large',
      name: 'diykeytip6',
      desc: '',
      args: [],
    );
  }

  /// `B position must be arranged from small to large`
  String get diykeytip7 {
    return Intl.message(
      'B position must be arranged from small to large',
      name: 'diykeytip7',
      desc: '',
      args: [],
    );
  }

  /// `depth must be sorted from largest to smallest`
  String get diykeytip8 {
    return Intl.message(
      'depth must be sorted from largest to smallest',
      name: 'diykeytip8',
      desc: '',
      args: [],
    );
  }

  /// `depth must be greater than 0`
  String get diykeytip9 {
    return Intl.message(
      'depth must be greater than 0',
      name: 'diykeytip9',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the corresponding parameters (unit: 0.01mm)`
  String get diykeytip10 {
    return Intl.message(
      'Please enter the corresponding parameters (unit: 0.01mm)',
      name: 'diykeytip10',
      desc: '',
      args: [],
    );
  }

  /// `Key width range 400-1100`
  String get diykeytip11 {
    return Intl.message(
      'Key width range 400-1100',
      name: 'diykeytip11',
      desc: '',
      args: [],
    );
  }

  /// `Key thickness range 180-500`
  String get diykeytip12 {
    return Intl.message(
      'Key thickness range 180-500',
      name: 'diykeytip12',
      desc: '',
      args: [],
    );
  }

  /// `Cutting depth range 180-500`
  String get diykeytip13 {
    return Intl.message(
      'Cutting depth range 180-500',
      name: 'diykeytip13',
      desc: '',
      args: [],
    );
  }

  /// `Automatic calculation`
  String get autoinput {
    return Intl.message(
      'Automatic calculation',
      name: 'autoinput',
      desc: '',
      args: [],
    );
  }

  /// `Database version`
  String get databasever {
    return Intl.message(
      'Database version',
      name: 'databasever',
      desc: '',
      args: [],
    );
  }

  /// `Firmware version`
  String get firmwarever {
    return Intl.message(
      'Firmware version',
      name: 'firmwarever',
      desc: '',
      args: [],
    );
  }

  /// `select device`
  String get selebt {
    return Intl.message(
      'select device',
      name: 'selebt',
      desc: '',
      args: [],
    );
  }

  /// `Choose a language`
  String get selelanuage {
    return Intl.message(
      'Choose a language',
      name: 'selelanuage',
      desc: '',
      args: [],
    );
  }

  /// `about us`
  String get aboutus {
    return Intl.message(
      'about us',
      name: 'aboutus',
      desc: '',
      args: [],
    );
  }

  /// `Privacy service`
  String get privacy {
    return Intl.message(
      'Privacy service',
      name: 'privacy',
      desc: '',
      args: [],
    );
  }

  /// `welcome:`
  String get welcome {
    return Intl.message(
      'welcome:',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get login {
    return Intl.message(
      'Log in',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Not logged in will not save history`
  String get nologinhistorytip {
    return Intl.message(
      'Not logged in will not save history',
      name: 'nologinhistorytip',
      desc: '',
      args: [],
    );
  }

  /// `Connecting to the copier..`
  String get connetctmc {
    return Intl.message(
      'Connecting to the copier..',
      name: 'connetctmc',
      desc: '',
      args: [],
    );
  }

  /// `connect remote control Downloader...`
  String get connetctms {
    return Intl.message(
      'connect remote control Downloader...',
      name: 'connetctms',
      desc: '',
      args: [],
    );
  }

  /// `Connecting to TANK..`
  String get connetctcnc {
    return Intl.message(
      'Connecting to TANK..',
      name: 'connetctcnc',
      desc: '',
      args: [],
    );
  }

  /// `Double click to exit to exit the program`
  String get exitapptip {
    return Intl.message(
      'Double click to exit to exit the program',
      name: 'exitapptip',
      desc: '',
      args: [],
    );
  }

  /// `Connecting the device needs to enable location services, whether to enable location services?`
  String get needlocat {
    return Intl.message(
      'Connecting the device needs to enable location services, whether to enable location services?',
      name: 'needlocat',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Magic Star`
  String get welcomemagicstar {
    return Intl.message(
      'Welcome to Magic Star',
      name: 'welcomemagicstar',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to E-clone`
  String get welcomemcclone {
    return Intl.message(
      'Welcome to E-clone',
      name: 'welcomemcclone',
      desc: '',
      args: [],
    );
  }

  /// `there is at least 1`
  String get lestone {
    return Intl.message(
      'there is at least 1',
      name: 'lestone',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to magic TANK`
  String get welcomemctank {
    return Intl.message(
      'Welcome to magic TANK',
      name: 'welcomemctank',
      desc: '',
      args: [],
    );
  }

  /// `Find a new APP version, please update it in the update center..`
  String get newapp {
    return Intl.message(
      'Find a new APP version, please update it in the update center..',
      name: 'newapp',
      desc: '',
      args: [],
    );
  }

  /// `Found a new data version, please update it in the update center..`
  String get newdata {
    return Intl.message(
      'Found a new data version, please update it in the update center..',
      name: 'newdata',
      desc: '',
      args: [],
    );
  }

  /// `Found a new firmware version, please update it in the update center..`
  String get newfirm {
    return Intl.message(
      'Found a new firmware version, please update it in the update center..',
      name: 'newfirm',
      desc: '',
      args: [],
    );
  }

  /// `solution`
  String get errorsolution {
    return Intl.message(
      'solution',
      name: 'errorsolution',
      desc: '',
      args: [],
    );
  }

  /// `E-clone language file`
  String get mcclonelanguage {
    return Intl.message(
      'E-clone language file',
      name: 'mcclonelanguage',
      desc: '',
      args: [],
    );
  }

  /// `transponder duplicator`
  String get mcclonename {
    return Intl.message(
      'transponder duplicator',
      name: 'mcclonename',
      desc: '',
      args: [],
    );
  }

  /// `Please put the transponder into the groove of the device for transponder identification.`
  String get chipdiscerntip {
    return Intl.message(
      'Please put the transponder into the groove of the device for transponder identification.',
      name: 'chipdiscerntip',
      desc: '',
      args: [],
    );
  }

  /// `Recognition failed, please check and try again.`
  String get chipdiscernerrortip {
    return Intl.message(
      'Recognition failed, please check and try again.',
      name: 'chipdiscernerrortip',
      desc: '',
      args: [],
    );
  }

  /// `Recognizing, please wait..`
  String get discerning {
    return Intl.message(
      'Recognizing, please wait..',
      name: 'discerning',
      desc: '',
      args: [],
    );
  }

  /// `Recognition timed out, please try again later!`
  String get discerntimeout {
    return Intl.message(
      'Recognition timed out, please try again later!',
      name: 'discerntimeout',
      desc: '',
      args: [],
    );
  }

  /// `copy`
  String get copybt {
    return Intl.message(
      'copy',
      name: 'copybt',
      desc: '',
      args: [],
    );
  }

  /// `Anti-theft type`
  String get copytype {
    return Intl.message(
      'Anti-theft type',
      name: 'copytype',
      desc: '',
      args: [],
    );
  }

  /// `Please identify first`
  String get needdiscern {
    return Intl.message(
      'Please identify first',
      name: 'needdiscern',
      desc: '',
      args: [],
    );
  }

  /// `transponder identification`
  String get chipdiscern {
    return Intl.message(
      'transponder identification',
      name: 'chipdiscern',
      desc: '',
      args: [],
    );
  }

  /// `transponder identification...`
  String get chipdiscerning {
    return Intl.message(
      'transponder identification...',
      name: 'chipdiscerning',
      desc: '',
      args: [],
    );
  }

  /// `copy transponder `
  String get chipcopy {
    return Intl.message(
      'copy transponder ',
      name: 'chipcopy',
      desc: '',
      args: [],
    );
  }

  /// `generate transponder`
  String get chipcreat {
    return Intl.message(
      'generate transponder',
      name: 'chipcreat',
      desc: '',
      args: [],
    );
  }

  /// `fast copy`
  String get chipquickcopy {
    return Intl.message(
      'fast copy',
      name: 'chipquickcopy',
      desc: '',
      args: [],
    );
  }

  /// `transponder simulation`
  String get chipsimulation {
    return Intl.message(
      'transponder simulation',
      name: 'chipsimulation',
      desc: '',
      args: [],
    );
  }

  /// `IC card cloud decoding`
  String get iccardcloud {
    return Intl.message(
      'IC card cloud decoding',
      name: 'iccardcloud',
      desc: '',
      args: [],
    );
  }

  /// `Access card copy`
  String get doorcopy {
    return Intl.message(
      'Access card copy',
      name: 'doorcopy',
      desc: '',
      args: [],
    );
  }

  /// `芯片转接`
  String get chipswitch {
    return Intl.message(
      '芯片转接',
      name: 'chipswitch',
      desc: '',
      args: [],
    );
  }

  /// `password calculation`
  String get pwcalculation {
    return Intl.message(
      'password calculation',
      name: 'pwcalculation',
      desc: '',
      args: [],
    );
  }

  /// `Connecting the device automatically..`
  String get autoconnectbting {
    return Intl.message(
      'Connecting the device automatically..',
      name: 'autoconnectbting',
      desc: '',
      args: [],
    );
  }

  /// `auto connect`
  String get autoconnectbt {
    return Intl.message(
      'auto connect',
      name: 'autoconnectbt',
      desc: '',
      args: [],
    );
  }

  /// `bluetooth switch`
  String get btswicth {
    return Intl.message(
      'bluetooth switch',
      name: 'btswicth',
      desc: '',
      args: [],
    );
  }

  /// `Pull down to refresh`
  String get btrefresh {
    return Intl.message(
      'Pull down to refresh',
      name: 'btrefresh',
      desc: '',
      args: [],
    );
  }

  /// `connecting...`
  String get btconnecting {
    return Intl.message(
      'connecting...',
      name: 'btconnecting',
      desc: '',
      args: [],
    );
  }

  /// `Turn on bluetooth`
  String get needbtopen {
    return Intl.message(
      'Turn on bluetooth',
      name: 'needbtopen',
      desc: '',
      args: [],
    );
  }

  /// `Connection failed`
  String get btconnetcerror {
    return Intl.message(
      'Connection failed',
      name: 'btconnetcerror',
      desc: '',
      args: [],
    );
  }

  /// `Collecting..`
  String get chipcollection {
    return Intl.message(
      'Collecting..',
      name: 'chipcollection',
      desc: '',
      args: [],
    );
  }

  /// `Confirmation of collection results...`
  String get chipcollectionok {
    return Intl.message(
      'Confirmation of collection results...',
      name: 'chipcollectionok',
      desc: '',
      args: [],
    );
  }

  /// `Please insert the original key....`
  String get inorignelkey {
    return Intl.message(
      'Please insert the original key....',
      name: 'inorignelkey',
      desc: '',
      args: [],
    );
  }

  /// `The original key was confirmed successfully`
  String get inorignelkeyok {
    return Intl.message(
      'The original key was confirmed successfully',
      name: 'inorignelkeyok',
      desc: '',
      args: [],
    );
  }

  /// `Connecting to the server...`
  String get connectnetserver {
    return Intl.message(
      'Connecting to the server...',
      name: 'connectnetserver',
      desc: '',
      args: [],
    );
  }

  /// `Failed to connect to server! Please try again later.`
  String get connectnetservererror {
    return Intl.message(
      'Failed to connect to server! Please try again later.',
      name: 'connectnetservererror',
      desc: '',
      args: [],
    );
  }

  /// `The network connection timed out, please try again later!`
  String get connectnetservertimerout {
    return Intl.message(
      'The network connection timed out, please try again later!',
      name: 'connectnetservertimerout',
      desc: '',
      args: [],
    );
  }

  /// `uploading. . .`
  String get updata {
    return Intl.message(
      'uploading. . .',
      name: 'updata',
      desc: '',
      args: [],
    );
  }

  /// `Please put the original key into the E-clone, ready to decode...`
  String get readyencode {
    return Intl.message(
      'Please put the original key into the E-clone, ready to decode...',
      name: 'readyencode',
      desc: '',
      args: [],
    );
  }

  /// `decoding`
  String get encodeing {
    return Intl.message(
      'decoding',
      name: 'encodeing',
      desc: '',
      args: [],
    );
  }

  /// `Whether to copy after decoding`
  String get encodeok {
    return Intl.message(
      'Whether to copy after decoding',
      name: 'encodeok',
      desc: '',
      args: [],
    );
  }

  /// `Copy failed, please try again!`
  String get copychiperror {
    return Intl.message(
      'Copy failed, please try again!',
      name: 'copychiperror',
      desc: '',
      args: [],
    );
  }

  /// `copy successfully`
  String get copychipok {
    return Intl.message(
      'copy successfully',
      name: 'copychipok',
      desc: '',
      args: [],
    );
  }

  /// `Copying, please wait`
  String get copychiping {
    return Intl.message(
      'Copying, please wait',
      name: 'copychiping',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred, please try again`
  String get haveerror {
    return Intl.message(
      'An error occurred, please try again',
      name: 'haveerror',
      desc: '',
      args: [],
    );
  }

  /// `whether to leave`
  String get outtip {
    return Intl.message(
      'whether to leave',
      name: 'outtip',
      desc: '',
      args: [],
    );
  }

  /// `return`
  String get returnbt {
    return Intl.message(
      'return',
      name: 'returnbt',
      desc: '',
      args: [],
    );
  }

  /// `read successfully`
  String get chipreadok {
    return Intl.message(
      'read successfully',
      name: 'chipreadok',
      desc: '',
      args: [],
    );
  }

  /// `write success`
  String get chipwriteok {
    return Intl.message(
      'write success',
      name: 'chipwriteok',
      desc: '',
      args: [],
    );
  }

  /// `write`
  String get chipwrite {
    return Intl.message(
      'write',
      name: 'chipwrite',
      desc: '',
      args: [],
    );
  }

  /// `Write timed out..`
  String get chipwritetimerout {
    return Intl.message(
      'Write timed out..',
      name: 'chipwritetimerout',
      desc: '',
      args: [],
    );
  }

  /// `read time out..`
  String get chipreadtimerout {
    return Intl.message(
      'read time out..',
      name: 'chipreadtimerout',
      desc: '',
      args: [],
    );
  }

  /// `Lock timed out. .`
  String get chiplocktimerout {
    return Intl.message(
      'Lock timed out. .',
      name: 'chiplocktimerout',
      desc: '',
      args: [],
    );
  }

  /// `Locked successfully`
  String get chiplockok {
    return Intl.message(
      'Locked successfully',
      name: 'chiplockok',
      desc: '',
      args: [],
    );
  }

  /// `Locking...`
  String get chiplocking {
    return Intl.message(
      'Locking...',
      name: 'chiplocking',
      desc: '',
      args: [],
    );
  }

  /// `Unlocked successfully`
  String get chipunlockok {
    return Intl.message(
      'Unlocked successfully',
      name: 'chipunlockok',
      desc: '',
      args: [],
    );
  }

  /// `unlock`
  String get chipunlock {
    return Intl.message(
      'unlock',
      name: 'chipunlock',
      desc: '',
      args: [],
    );
  }

  /// `Unlocking...`
  String get chipunlocking {
    return Intl.message(
      'Unlocking...',
      name: 'chipunlocking',
      desc: '',
      args: [],
    );
  }

  /// `plaintext mode`
  String get chip46model1 {
    return Intl.message(
      'plaintext mode',
      name: 'chip46model1',
      desc: '',
      args: [],
    );
  }

  /// `encryption mode`
  String get chip46model2 {
    return Intl.message(
      'encryption mode',
      name: 'chip46model2',
      desc: '',
      args: [],
    );
  }

  /// `Enter the transponder name`
  String get inchipname {
    return Intl.message(
      'Enter the transponder name',
      name: 'inchipname',
      desc: '',
      args: [],
    );
  }

  /// `Enter car name`
  String get incarname {
    return Intl.message(
      'Enter car name',
      name: 'incarname',
      desc: '',
      args: [],
    );
  }

  /// `car model search`
  String get carlist {
    return Intl.message(
      'car model search',
      name: 'carlist',
      desc: '',
      args: [],
    );
  }

  /// `transponder search`
  String get chiplist {
    return Intl.message(
      'transponder search',
      name: 'chiplist',
      desc: '',
      args: [],
    );
  }

  /// `generate`
  String get chipcreatbt {
    return Intl.message(
      'generate',
      name: 'chipcreatbt',
      desc: '',
      args: [],
    );
  }

  /// `generating...`
  String get chipcreating {
    return Intl.message(
      'generating...',
      name: 'chipcreating',
      desc: '',
      args: [],
    );
  }

  /// `Generated successfully`
  String get chipcreatok {
    return Intl.message(
      'Generated successfully',
      name: 'chipcreatok',
      desc: '',
      args: [],
    );
  }

  /// `Generated successfully,Whether to continue?`
  String get chipcreatokagain {
    return Intl.message(
      'Generated successfully,Whether to continue?',
      name: 'chipcreatokagain',
      desc: '',
      args: [],
    );
  }

  /// `Generated failed！Please check and try again`
  String get chipcreaterror {
    return Intl.message(
      'Generated failed！Please check and try again',
      name: 'chipcreaterror',
      desc: '',
      args: [],
    );
  }

  /// `available transponders`
  String get supootchip {
    return Intl.message(
      'available transponders',
      name: 'supootchip',
      desc: '',
      args: [],
    );
  }

  /// `car model`
  String get carmodel {
    return Intl.message(
      'car model',
      name: 'carmodel',
      desc: '',
      args: [],
    );
  }

  /// `master key`
  String get masterkey {
    return Intl.message(
      'master key',
      name: 'masterkey',
      desc: '',
      args: [],
    );
  }

  /// `Deputy key`
  String get secondarykey {
    return Intl.message(
      'Deputy key',
      name: 'secondarykey',
      desc: '',
      args: [],
    );
  }

  /// `Select the key to be created`
  String get selecreatkey {
    return Intl.message(
      'Select the key to be created',
      name: 'selecreatkey',
      desc: '',
      args: [],
    );
  }

  /// `Requires connected device`
  String get needconnectbt {
    return Intl.message(
      'Requires connected device',
      name: 'needconnectbt',
      desc: '',
      args: [],
    );
  }

  /// `Click to collapse`
  String get chickput {
    return Intl.message(
      'Click to collapse',
      name: 'chickput',
      desc: '',
      args: [],
    );
  }

  /// `Ignition coil detection`
  String get firecheck {
    return Intl.message(
      'Ignition coil detection',
      name: 'firecheck',
      desc: '',
      args: [],
    );
  }

  /// `The current ignition coil detections are:`
  String get firecheckok {
    return Intl.message(
      'The current ignition coil detections are:',
      name: 'firecheckok',
      desc: '',
      args: [],
    );
  }

  /// `Please put the acquisition antenna close to the ignition switch, and the coil model is normal when you hear a continuous "beep" sound`
  String get firechecktip {
    return Intl.message(
      'Please put the acquisition antenna close to the ignition switch, and the coil model is normal when you hear a continuous "beep" sound',
      name: 'firechecktip',
      desc: '',
      args: [],
    );
  }

  /// `Downloading file...progress:`
  String get downmc {
    return Intl.message(
      'Downloading file...progress:',
      name: 'downmc',
      desc: '',
      args: [],
    );
  }

  /// `Updating...Progress:`
  String get upmc {
    return Intl.message(
      'Updating...Progress:',
      name: 'upmc',
      desc: '',
      args: [],
    );
  }

  /// `Technical Information`
  String get techinf {
    return Intl.message(
      'Technical Information',
      name: 'techinf',
      desc: '',
      args: [],
    );
  }

  /// `Material accessories`
  String get mcparts {
    return Intl.message(
      'Material accessories',
      name: 'mcparts',
      desc: '',
      args: [],
    );
  }

  /// `Device connection failed, please connect manually`
  String get autoconnectbterror {
    return Intl.message(
      'Device connection failed, please connect manually',
      name: 'autoconnectbterror',
      desc: '',
      args: [],
    );
  }

  /// `请输入验证码`
  String get inputvercode {
    return Intl.message(
      '请输入验证码',
      name: 'inputvercode',
      desc: '',
      args: [],
    );
  }

  /// `请先输入手机号`
  String get inputphonenum {
    return Intl.message(
      '请先输入手机号',
      name: 'inputphonenum',
      desc: '',
      args: [],
    );
  }

  /// `验证码已发送`
  String get vercodesendok {
    return Intl.message(
      '验证码已发送',
      name: 'vercodesendok',
      desc: '',
      args: [],
    );
  }

  /// `获取验证码`
  String get getvercode {
    return Intl.message(
      '获取验证码',
      name: 'getvercode',
      desc: '',
      args: [],
    );
  }

  /// `新用户注册`
  String get newregister {
    return Intl.message(
      '新用户注册',
      name: 'newregister',
      desc: '',
      args: [],
    );
  }

  /// `新用户`
  String get newuser {
    return Intl.message(
      '新用户',
      name: 'newuser',
      desc: '',
      args: [],
    );
  }

  /// `地址`
  String get useraddress {
    return Intl.message(
      '地址',
      name: 'useraddress',
      desc: '',
      args: [],
    );
  }

  /// `修改`
  String get change {
    return Intl.message(
      '修改',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `拆除旧夹具`
  String get changefixture_0_1 {
    return Intl.message(
      '拆除旧夹具',
      name: 'changefixture_0_1',
      desc: '',
      args: [],
    );
  }

  /// `安装新夹具`
  String get changefixture_0_2 {
    return Intl.message(
      '安装新夹具',
      name: 'changefixture_0_2',
      desc: '',
      args: [],
    );
  }

  /// `拆除新夹具`
  String get changefixture_1_1 {
    return Intl.message(
      '拆除新夹具',
      name: 'changefixture_1_1',
      desc: '',
      args: [],
    );
  }

  /// `安装旧夹具`
  String get changefixture_1_2 {
    return Intl.message(
      '安装旧夹具',
      name: 'changefixture_1_2',
      desc: '',
      args: [],
    );
  }

  /// `标准钥匙`
  String get keytype0 {
    return Intl.message(
      '标准钥匙',
      name: 'keytype0',
      desc: '',
      args: [],
    );
  }

  /// `智能卡钥匙`
  String get keytype1 {
    return Intl.message(
      '智能卡钥匙',
      name: 'keytype1',
      desc: '',
      args: [],
    );
  }

  /// `自定义钥匙不保存历史记录以及客户资料`
  String get diykeycuttip {
    return Intl.message(
      '自定义钥匙不保存历史记录以及客户资料',
      name: 'diykeycuttip',
      desc: '',
      args: [],
    );
  }

  /// `实际值切削`
  String get reallycut {
    return Intl.message(
      '实际值切削',
      name: 'reallycut',
      desc: '',
      args: [],
    );
  }

  /// `单齿切削`
  String get onecut {
    return Intl.message(
      '单齿切削',
      name: 'onecut',
      desc: '',
      args: [],
    );
  }

  /// `修改钥匙数据`
  String get changekeydata {
    return Intl.message(
      '修改钥匙数据',
      name: 'changekeydata',
      desc: '',
      args: [],
    );
  }

  /// `修改完成`
  String get changeok {
    return Intl.message(
      '修改完成',
      name: 'changeok',
      desc: '',
      args: [],
    );
  }

  /// `请先输入厚度`
  String get inputkeythicknesstip {
    return Intl.message(
      '请先输入厚度',
      name: 'inputkeythicknesstip',
      desc: '',
      args: [],
    );
  }

  /// `请先输入宽度`
  String get inputkeywidetip {
    return Intl.message(
      '请先输入宽度',
      name: 'inputkeywidetip',
      desc: '',
      args: [],
    );
  }

  /// `必填`
  String get mustinput {
    return Intl.message(
      '必填',
      name: 'mustinput',
      desc: '',
      args: [],
    );
  }

  /// `钥匙胚号`
  String get keynumber {
    return Intl.message(
      '钥匙胚号',
      name: 'keynumber',
      desc: '',
      args: [],
    );
  }

  /// `数据加载中`
  String get loadingdata {
    return Intl.message(
      '数据加载中',
      name: 'loadingdata',
      desc: '',
      args: [],
    );
  }

  /// `查询`
  String get searchbt {
    return Intl.message(
      '查询',
      name: 'searchbt',
      desc: '',
      args: [],
    );
  }

  /// `已更换`
  String get changedxd {
    return Intl.message(
      '已更换',
      name: 'changedxd',
      desc: '',
      args: [],
    );
  }

  /// `更换铣刀`
  String get changexd {
    return Intl.message(
      '更换铣刀',
      name: 'changexd',
      desc: '',
      args: [],
    );
  }

  /// `连接成功`
  String get btconnetok {
    return Intl.message(
      '连接成功',
      name: 'btconnetok',
      desc: '',
      args: [],
    );
  }

  /// `有`
  String get have {
    return Intl.message(
      '有',
      name: 'have',
      desc: '',
      args: [],
    );
  }

  /// `无`
  String get nullnone {
    return Intl.message(
      '无',
      name: 'nullnone',
      desc: '',
      args: [],
    );
  }

  /// `当前类型不支持单齿切削`
  String get nosupportonecut {
    return Intl.message(
      '当前类型不支持单齿切削',
      name: 'nosupportonecut',
      desc: '',
      args: [],
    );
  }

  /// `感谢您下载Magictank APP!使用app连接设备工作时候,仅授权专业人士在法律许可范围内使用.使用本软件时,我们可能需要使用您部分必要的个人信息以及允许部分系统功能授权以提供相关服务,请您认真阅读,魔力星`
  String get privacy1 {
    return Intl.message(
      '感谢您下载Magictank APP!使用app连接设备工作时候,仅授权专业人士在法律许可范围内使用.使用本软件时,我们可能需要使用您部分必要的个人信息以及允许部分系统功能授权以提供相关服务,请您认真阅读,魔力星',
      name: 'privacy1',
      desc: '',
      args: [],
    );
  }

  /// `<<服务协议/隐私政策>>`
  String get privacy2 {
    return Intl.message(
      '<<服务协议/隐私政策>>',
      name: 'privacy2',
      desc: '',
      args: [],
    );
  }

  /// `,如您同意所述政策,请点击"同意并继续"开始使用相关功能及服务.`
  String get privacy3 {
    return Intl.message(
      ',如您同意所述政策,请点击"同意并继续"开始使用相关功能及服务.',
      name: 'privacy3',
      desc: '',
      args: [],
    );
  }

  /// `同意并继续`
  String get privacy4 {
    return Intl.message(
      '同意并继续',
      name: 'privacy4',
      desc: '',
      args: [],
    );
  }

  /// `不同意并关闭APP`
  String get privacy5 {
    return Intl.message(
      '不同意并关闭APP',
      name: 'privacy5',
      desc: '',
      args: [],
    );
  }

  /// `启动APP后自动连接设备`
  String get openappautoconnect {
    return Intl.message(
      '启动APP后自动连接设备',
      name: 'openappautoconnect',
      desc: '',
      args: [],
    );
  }

  /// `发现新的APP版本,`
  String get findnewapp {
    return Intl.message(
      '发现新的APP版本,',
      name: 'findnewapp',
      desc: '',
      args: [],
    );
  }

  /// `发现新的TANK固件,`
  String get findnewcnc {
    return Intl.message(
      '发现新的TANK固件,',
      name: 'findnewcnc',
      desc: '',
      args: [],
    );
  }

  /// `发现新的数据版本,`
  String get findnewkeydata {
    return Intl.message(
      '发现新的数据版本,',
      name: 'findnewkeydata',
      desc: '',
      args: [],
    );
  }

  /// `发现新的ECLONE固件`
  String get findnewmc {
    return Intl.message(
      '发现新的ECLONE固件',
      name: 'findnewmc',
      desc: '',
      args: [],
    );
  }

  /// `发现新的MAGIC固件`
  String get findnewms {
    return Intl.message(
      '发现新的MAGIC固件',
      name: 'findnewms',
      desc: '',
      args: [],
    );
  }

  /// `检测到未下载完成的钥匙数据 是否继续下载文件?`
  String get continuedown {
    return Intl.message(
      '检测到未下载完成的钥匙数据 是否继续下载文件?',
      name: 'continuedown',
      desc: '',
      args: [],
    );
  }

  /// `获取电池电量`
  String get getpower {
    return Intl.message(
      '获取电池电量',
      name: 'getpower',
      desc: '',
      args: [],
    );
  }

  /// `即将开放!敬请期待!`
  String get comingsoon {
    return Intl.message(
      '即将开放!敬请期待!',
      name: 'comingsoon',
      desc: '',
      args: [],
    );
  }

  /// `按品牌/车型/年份选择钥匙胚进行切割。`
  String get cncguide1 {
    return Intl.message(
      '按品牌/车型/年份选择钥匙胚进行切割。',
      name: 'cncguide1',
      desc: '',
      args: [],
    );
  }

  /// `按钥匙的名称来搜索加工钥匙。`
  String get cncguide2 {
    return Intl.message(
      '按钥匙的名称来搜索加工钥匙。',
      name: 'cncguide2',
      desc: '',
      args: [],
    );
  }

  /// `按品牌及编码在线查询对应齿号进行钥匙切割。`
  String get cncguide3 {
    return Intl.message(
      '按品牌及编码在线查询对应齿号进行钥匙切割。',
      name: 'cncguide3',
      desc: '',
      args: [],
    );
  }

  /// `按钥匙胚齿形进行学习切割，复制钥匙。`
  String get cncguide4 {
    return Intl.message(
      '按钥匙胚齿形进行学习切割，复制钥匙。',
      name: 'cncguide4',
      desc: '',
      args: [],
    );
  }

  /// `根据提供的超模胚制作一把钥匙模型。`
  String get cncguide5 {
    return Intl.message(
      '根据提供的超模胚制作一把钥匙模型。',
      name: 'cncguide5',
      desc: '',
      args: [],
    );
  }

  /// `加工设置、机器校准、机器检测。`
  String get cncguide6 {
    return Intl.message(
      '加工设置、机器校准、机器检测。',
      name: 'cncguide6',
      desc: '',
      args: [],
    );
  }

  /// `首次使用或更换铣刀、导针之后需依次进行\r\n“夹具校准”、“切割校准”。`
  String get cncguide7 {
    return Intl.message(
      '首次使用或更换铣刀、导针之后需依次进行\r\n“夹具校准”、“切割校准”。',
      name: 'cncguide7',
      desc: '',
      args: [],
    );
  }

  /// `当前钥匙宽度,与数据宽度不符合,是否继续?`
  String get keywideerror {
    return Intl.message(
      '当前钥匙宽度,与数据宽度不符合,是否继续?',
      name: 'keywideerror',
      desc: '',
      args: [],
    );
  }

  /// `圆棍钥匙`
  String get keyclass8 {
    return Intl.message(
      '圆棍钥匙',
      name: 'keyclass8',
      desc: '',
      args: [],
    );
  }

  /// `选择装夹方式`
  String get seleclamp {
    return Intl.message(
      '选择装夹方式',
      name: 'seleclamp',
      desc: '',
      args: [],
    );
  }

  /// `装夹方式1`
  String get clamptype1 {
    return Intl.message(
      '装夹方式1',
      name: 'clamptype1',
      desc: '',
      args: [],
    );
  }

  /// `装夹方式2`
  String get clamptype2 {
    return Intl.message(
      '装夹方式2',
      name: 'clamptype2',
      desc: '',
      args: [],
    );
  }

  /// `保存成功`
  String get saveok {
    return Intl.message(
      '保存成功',
      name: 'saveok',
      desc: '',
      args: [],
    );
  }

  /// `断开连接`
  String get disconnect {
    return Intl.message(
      '断开连接',
      name: 'disconnect',
      desc: '',
      args: [],
    );
  }

  /// `搜索到的设备`
  String get canuse {
    return Intl.message(
      '搜索到的设备',
      name: 'canuse',
      desc: '',
      args: [],
    );
  }

  /// `连接`
  String get connect {
    return Intl.message(
      '连接',
      name: 'connect',
      desc: '',
      args: [],
    );
  }

  /// `重新搜索`
  String get searchbtagain {
    return Intl.message(
      '重新搜索',
      name: 'searchbtagain',
      desc: '',
      args: [],
    );
  }

  /// `主轴转速`
  String get bldcspeed {
    return Intl.message(
      '主轴转速',
      name: 'bldcspeed',
      desc: '',
      args: [],
    );
  }

  /// `进给速度`
  String get cuttingspeed {
    return Intl.message(
      '进给速度',
      name: 'cuttingspeed',
      desc: '',
      args: [],
    );
  }

  /// `高速`
  String get highspeed {
    return Intl.message(
      '高速',
      name: 'highspeed',
      desc: '',
      args: [],
    );
  }

  /// `中速`
  String get mediumspeed {
    return Intl.message(
      '中速',
      name: 'mediumspeed',
      desc: '',
      args: [],
    );
  }

  /// `低速`
  String get lowspeed {
    return Intl.message(
      '低速',
      name: 'lowspeed',
      desc: '',
      args: [],
    );
  }

  /// `蜂鸣器`
  String get buzz {
    return Intl.message(
      '蜂鸣器',
      name: 'buzz',
      desc: '',
      args: [],
    );
  }

  /// `机器忙,请稍后再试`
  String get isworking {
    return Intl.message(
      '机器忙,请稍后再试',
      name: 'isworking',
      desc: '',
      args: [],
    );
  }

  /// `钥匙材质偏软或者偏硬`
  String get specialkey {
    return Intl.message(
      '钥匙材质偏软或者偏硬',
      name: 'specialkey',
      desc: '',
      args: [],
    );
  }

  /// `上齿`
  String get keyside7 {
    return Intl.message(
      '上齿',
      name: 'keyside7',
      desc: '',
      args: [],
    );
  }

  /// `下齿`
  String get keyside8 {
    return Intl.message(
      '下齿',
      name: 'keyside8',
      desc: '',
      args: [],
    );
  }

  /// `上下齿`
  String get keyside9 {
    return Intl.message(
      '上下齿',
      name: 'keyside9',
      desc: '',
      args: [],
    );
  }

  /// `齿位A:`
  String get keytoothnumA {
    return Intl.message(
      '齿位A:',
      name: 'keytoothnumA',
      desc: '',
      args: [],
    );
  }

  /// `齿位B:`
  String get keytoothnumB {
    return Intl.message(
      '齿位B:',
      name: 'keytoothnumB',
      desc: '',
      args: [],
    );
  }

  /// `齿宽A:`
  String get keytoothwideA {
    return Intl.message(
      '齿宽A:',
      name: 'keytoothwideA',
      desc: '',
      args: [],
    );
  }

  /// `齿宽B:`
  String get keytoothwideB {
    return Intl.message(
      '齿宽B:',
      name: 'keytoothwideB',
      desc: '',
      args: [],
    );
  }

  /// `齿宽必须大于0`
  String get diykeytip14 {
    return Intl.message(
      '齿宽必须大于0',
      name: 'diykeytip14',
      desc: '',
      args: [],
    );
  }

  /// `刀路直径(0.01mm)`
  String get keygroove {
    return Intl.message(
      '刀路直径(0.01mm)',
      name: 'keygroove',
      desc: '',
      args: [],
    );
  }

  /// `切削深度(0.01mm)`
  String get keydepth {
    return Intl.message(
      '切削深度(0.01mm)',
      name: 'keydepth',
      desc: '',
      args: [],
    );
  }

  /// `修改A边的齿数`
  String get changeatooth {
    return Intl.message(
      '修改A边的齿数',
      name: 'changeatooth',
      desc: '',
      args: [],
    );
  }

  /// `修改B边的齿数`
  String get changebtooth {
    return Intl.message(
      '修改B边的齿数',
      name: 'changebtooth',
      desc: '',
      args: [],
    );
  }

  /// `修改齿深数`
  String get changetoothnum {
    return Intl.message(
      '修改齿深数',
      name: 'changetoothnum',
      desc: '',
      args: [],
    );
  }

  /// `开口数据A`
  String get opendataa {
    return Intl.message(
      '开口数据A',
      name: 'opendataa',
      desc: '',
      args: [],
    );
  }

  /// `头部处理`
  String get opendata {
    return Intl.message(
      '头部处理',
      name: 'opendata',
      desc: '',
      args: [],
    );
  }

  /// `开口数据B`
  String get opendatab {
    return Intl.message(
      '开口数据B',
      name: 'opendatab',
      desc: '',
      args: [],
    );
  }

  /// `夹具类型`
  String get keyfixture {
    return Intl.message(
      '夹具类型',
      name: 'keyfixture',
      desc: '',
      args: [],
    );
  }

  /// `钥匙轮廓`
  String get keyoutline {
    return Intl.message(
      '钥匙轮廓',
      name: 'keyoutline',
      desc: '',
      args: [],
    );
  }

  /// `请设置积分(最大1000)`
  String get settoken {
    return Intl.message(
      '请设置积分(最大1000)',
      name: 'settoken',
      desc: '',
      args: [],
    );
  }

  /// `请按照要求设置积分`
  String get tokenerror {
    return Intl.message(
      '请按照要求设置积分',
      name: 'tokenerror',
      desc: '',
      args: [],
    );
  }

  /// `齿宽`
  String get keytoothwide {
    return Intl.message(
      '齿宽',
      name: 'keytoothwide',
      desc: '',
      args: [],
    );
  }

  /// `当前数据已共享,请先关闭共享后再进行编辑操作!`
  String get needcloseshare {
    return Intl.message(
      '当前数据已共享,请先关闭共享后再进行编辑操作!',
      name: 'needcloseshare',
      desc: '',
      args: [],
    );
  }

  /// `测夹`
  String get keyfixture1 {
    return Intl.message(
      '测夹',
      name: 'keyfixture1',
      desc: '',
      args: [],
    );
  }

  /// `验证码错误`
  String get vercodeerror {
    return Intl.message(
      '验证码错误',
      name: 'vercodeerror',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
