import 'package:blog_backend/src/controller.dart';
import 'package:blog_backend/src/routing/route_holder.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  group('getMatchingController', () {
    test(
        'should return the controller '
        'that matches a path if there is one', () {
      const String requestedPath = '/test';
      final MockController controller = MockController();
      final List<MockRoute> routes = <MockRoute>[
        MockRoute(),
        MockRoute(),
        MockRoute()
      ];
      final RouteHolder routeHolder = RouteHolder(routes);
      when(routes[0].matches(requestedPath)).thenReturn(false);
      when(routes[1].matches(requestedPath)).thenReturn(true);
      when(routes[1].controller).thenReturn(controller);
      when(routes[2].matches(requestedPath)).thenReturn(false);
      final Controller matchingController =
          routeHolder.getMatchingController(requestedPath);
      expect(matchingController, equals(controller));
    });
  });
}
