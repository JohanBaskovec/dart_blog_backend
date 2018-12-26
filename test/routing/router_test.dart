import 'package:blog_backend/src/routing/router.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mocks.dart';


void main() {
  group('routeToPath', () {
    MockRouteHolder routeHolder;
    MockController controller = MockController();
    setUp(() {
      routeHolder = MockRouteHolder();
      controller = MockController();
    });
    test("should call the controller's run method if path matches", () async {
      const String requestedPath = '/test';
      when(routeHolder.getMatchingController(requestedPath))
          .thenReturn(controller);
      final Router router = Router(routeHolder);
      final routingContext = MockRoutingContext();
      await router.routeToPath('/test', routingContext);
      verify(controller.run(routingContext)).called(1);
      verify(routingContext.closeResponse());
    });
  });
}
