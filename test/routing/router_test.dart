import 'package:blog_backend/src/routing/router.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mocks.dart';


void main() {
  group('routeToPath', () {
    MockRouteHolder routeHolder;
    MockController controller = MockController();
    String requestedPath;
    Router router;
    MockRoutingContext routingContext;
    setUp(() {
      routeHolder = MockRouteHolder();
      controller = MockController();
      requestedPath = '/test';
      when(routeHolder.getMatchingController(requestedPath))
          .thenReturn(controller);
      router = Router(routeHolder);
      routingContext = MockRoutingContext();
    });
    test("should call the controller's get method if path match", () async {
      when(routingContext.method).thenReturn('GET');
      await router.routeToPath('/test', routingContext);
      verify(controller.get(routingContext)).called(1);
      verify(routingContext.closeResponse());
    });
    test("should call the controller's post method if path and method match", () async {
      when(routingContext.method).thenReturn('POST');
      await router.routeToPath('/test', routingContext);
      verify(controller.post(routingContext)).called(1);
      verify(routingContext.closeResponse());
    });
    test("should call the controller's delete method if path and method match", () async {
      when(routingContext.method).thenReturn('DELETE');
      await router.routeToPath('/test', routingContext);
      verify(controller.delete(routingContext)).called(1);
      verify(routingContext.closeResponse());
    });
    test("should call the controller's put method if path and method match", () async {
      when(routingContext.method).thenReturn('PUT');
      await router.routeToPath('/test', routingContext);
      verify(controller.put(routingContext)).called(1);
      verify(routingContext.closeResponse());
    });
  });
}
