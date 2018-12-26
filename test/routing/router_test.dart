import 'package:blog_backend/src/routing/router.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mocks.dart';


void main() {
  group('routeToHash', () {
    MockRouteHolder routeHolder;
    MockController controller = MockController();
    setUp(() {
      routeHolder = MockRouteHolder();
      controller = MockController();
    });
    test("should call the controller's run method if hash matches", () {
      const String requestedPath = '/test';
      when(routeHolder.getMatchingController(requestedPath))
          .thenReturn(controller);
      final Router router = Router(routeHolder);
      router.routeToPath('/test');
      verify(controller.run()).called(1);
    });
  });
}
