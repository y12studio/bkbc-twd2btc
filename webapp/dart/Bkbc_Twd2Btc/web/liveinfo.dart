/*
 * Copyright 2013 Y12STUDIO
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import 'package:polymer/polymer.dart';
import 'package:intl/intl.dart';
import 'dart:html';
import 'dart:convert';
import 'dart:async';
import 'package:route_hierarchical/client.dart';
import 'package:crypto/crypto.dart';

/**
 * A Polymer LiveInfo element.
 */
@CustomTag('live-info')
class LiveInfo extends PolymerElement {

  var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
  @observable String twdPerUsd = "0.0";
  @observable String updateTime = "2014-xx";
  @observable String usdPerBtc = "0.0";
  @observable String twdPerBtc = "0.0";
  @observable String twdPerTx = "0.0";
  @observable String s24hrmean = "0";
  @observable String s24hrstd = "0";
  @observable String s24hrmax = "0";
  @observable String s24hrmin = "0";
  @observable String btcPerKtwd = "0.0";
  @observable String inbtc = "0.0";
  @observable String intwd = "0.0";
  @observable String inrisk = "0";
  @observable String calcTwd = "000000.0";
  @observable String calcTwdRaw = "000000.0";
  @observable String calcBtc = "0.00000";
  @observable String calcBtcRaw = "0.00000";
  @observable String amountTwd = "000000.0";
  @observable String amountBtc = "0.00000";
  @observable String btcAddr = "1xxxxxxxxxxxx";
  @observable String qrurl = "bitqr_y12.png";
  @observable String coinUrlPrefix = "/btc/0.00";

  String url = "/json/twdbtc.json";
  String urlTest = "testdata/twdbtc.json";
  
  ImageElement qrimg;
 
  String y12_qrurl = "http://blackbananacoin.org/ext/bitqr.php?bid=14EkXBKNQbXgDTFc23NheH1E2FCR9fUyEJ&amount=0.002&message=support_bkbc";

  LiveInfo.created() : super.created() {
    String host = window.location.hostname;
    String port = window.location.port;    
    // dart dev port
    if(port=="3030"){
      url = urlTest;
    }
    loadData();
    qrimg = this.shadowRoot.querySelector('#qrcodeImg');
  }
  
  String testSha256(String target){
    var sha256 = new SHA256();
    sha256.add(target.codeUnits);
    List<int> digest = sha256.close();
    for(int v in digest){
      print(v);
    }
    var hexString = CryptoUtils.bytesToHex(digest);
    // 'message'
    //print(hexString =='ab530a13e45914982b79f9b7e3fba994cfd1f3fb22f71cea1afbf02b460c6d1d'); //true
    return hexString;
  }
  
  void initRoute(){
    var router = new Router(useFragment: true);
    router.root
      ..addRoute(name: 'btc', path: '/btc/:amount/:btcaddrId/:btcRisk', enter: showBtc)
      ..addRoute(name: 'twd', path: '/twd/:amount/:btcaddrId/:btcRisk', enter: showTwd)
      ..addRoute(name: 'home', defaultRoute: true, path: '/', enter: showHome);
    router.listen(ignoreClick: true);
  }
  
  bool get applyAuthorStyles => true;
  double vBtcTwd;

  loadData() {
    // call the web server asynchronously
    Future request = HttpRequest.getString(url).then(onDataLoaded);
  }
  
  handleBtcChange(Event e, var detail, Node target) {
     updateBtcValueChange();
  }
  
  String getQrUrl() => 'http://blackbananacoin.org/ext/bitqr.php?bid=${btcAddr}&amount=${amountBtc}&message=bkbc_gen';
  
  handleTwdChange(Event e, var detail, Node target) {
     updateTwdValueChange();
  }
  
  updateTwdValueChange(){
    double vtwd = double.parse(intwd);
    double vrisk = double.parse(inrisk);
    double vbtc = vtwd/vBtcTwd;
    double rate = 1+(vrisk/100);
    calcBtc = (vbtc*rate).toStringAsFixed(8);
    calcBtcRaw = vbtc.toStringAsFixed(8);
    calcTwd="0.0";
    calcTwdRaw="0.0";
    amountTwd = vtwd.toStringAsFixed(1);
    amountBtc = (vbtc*rate).toString();
    inbtc = "0.0";
    coinUrlPrefix = "/twd/$amountTwd";
  }
  
  updateBtcValueChange(){
    double vbtc = double.parse(inbtc);
    double vrisk = double.parse(inrisk);
    double vtwd = vbtc*vBtcTwd;
    double rate = 1-(vrisk/100);
    calcTwd = (vtwd*rate).toStringAsFixed(1);
    calcTwdRaw = vtwd.toStringAsFixed(1);
    calcBtc="0.0";
    calcBtcRaw="0.0";
    amountTwd = (vtwd*rate).toStringAsFixed(1);
    amountBtc = vbtc.toString();
    intwd = "0.0";
    coinUrlPrefix = "/btc/$amountBtc";
  }
  
  handleRiskChange(Event e, var detail, Node target) {
    inbtc = "0.0";
    intwd = "0.0";
    calcBtc="0.0";
    calcBtcRaw="0.0";
    calcTwd="0.0";
    calcTwdRaw="0.0";
  }
  
  handleGenQrCode(Event e, var detail, Node target) {
    qrimg.className='hidden';
    qrurl = getQrUrl();
    //print(qrurl);
    var futures = [qrimg.onLoad.first];
    Future.wait(futures).then((_) => qrimg.className='show');
  }
  
  void handleBtcAddrChange(Event e, var detail, Node target) {
    qrimg.className='hidden';
  }
  
  void onDataLoaded(String jsonString) {
    // parse json to map
    Map data = JSON.decode(jsonString); 
    double vtwdPerUsd = data["usdtwd"];
    double vusdPerBtc = data["btcusd"];
    double vTxFeeTwd = data["txfeetwd"];
    double v24hrmean = data["mean24hr"];
    double v24hrmin = data["min24hr"];
    double v24hrmax = data["max24hr"];
    double v24hrstd = data["std24hr"];
    int timems = data["timems"];
    vBtcTwd = data["btctwd"];
    DateTime updateDate = new DateTime.fromMillisecondsSinceEpoch(timems, isUtc: true);
    twdPerUsd = vtwdPerUsd.toStringAsFixed(2);
    usdPerBtc = vusdPerBtc.toStringAsFixed(2);
    twdPerBtc = vBtcTwd.toStringAsFixed(0);
    btcPerKtwd = (1000.0/vBtcTwd).toStringAsFixed(6);
    twdPerTx = vTxFeeTwd.toStringAsFixed(2);
    updateTime = formatter.format(updateDate.toLocal());
    
    s24hrmean = v24hrmean.toStringAsFixed(0);
    s24hrmax = v24hrmax.toStringAsFixed(0);
    s24hrmin = v24hrmin.toStringAsFixed(0);
    s24hrstd = v24hrstd.toStringAsFixed(1);
    
    initRoute();
  }
  
  void showHome(RouteEvent e) {
    // nothing to parse from path, since there are no groups
    // print("home");
  }

  void showBtc(RouteEvent e) {
    btcAddr = e.parameters['btcaddrId'];
    inrisk = e.parameters['btcRisk'];
    inbtc = e.parameters['amount'];
    updateBtcValueChange();
  }
  
  void showTwd(RouteEvent e) {
    btcAddr = e.parameters['btcaddrId'];
    inrisk = e.parameters['btcRisk'];
    intwd = e.parameters['amount'];
    updateTwdValueChange();
  }
}

