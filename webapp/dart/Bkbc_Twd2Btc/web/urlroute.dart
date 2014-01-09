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
import 'package:route_hierarchical/client.dart';

/**
 * A Polymer UrlRoute element.
 */
@CustomTag('url-route')
class UrlRoute extends PolymerElement {

  bool get applyAuthorStyles => true;

  UrlRoute.created() : super.created() {
    
    var router = new Router(useFragment: true);
    router.root
      ..addRoute(name: 'btc', path: '/btc/:amount/:btcaddrId/:btcRisk', enter: showBtc)
      ..addRoute(name: 'twd', path: '/twd/:amount/:btcaddrId/:btcRisk', enter: showTwd)
        ..addRoute(name: 'home', defaultRoute: true, path: '/', enter: showHome);
    router.listen();
  }

  void showHome(RouteEvent e) {
    // nothing to parse from path, since there are no groups
    print("home");
  }

  void showBtc(RouteEvent e) {
    var btcaddrId = e.parameters['btcaddrId'];
    var amount = e.parameters['amount'];
    var btcrisk = e.parameters['btcRisk'];
    print(e.parameters);
  }
  
  void showTwd(RouteEvent e) {
    print(e.parameters);
  }
}




