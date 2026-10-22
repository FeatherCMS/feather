import FeatherWebAdmin
import FeatherWebShared
import FeatherModuleKit
import Hummingbird

extension Dashboard {
    struct Router {
        let controller: any Controller.Interface
        let path: WebRoute

        init(
            renderingEngine: any RenderingEngine,
            events: any EventPublisher,
            path: WebRoute
        ) {
            self.path = path
            self.controller = Controller.Default(
                buildRuntime: { request, context in
                    (
                        interactor: Interactor.Default(events: events),
                        presenter: Presenter.Default(
                            request: request,
                            context: context,
                            renderingEngine: renderingEngine,
                        )
                    )
                }
            )
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.get(
                path.routerPath,
                use: controller.getHome
            )
        }
    }
}
