public import FeatherAdmin
import FeatherModuleKit
import Hummingbird
import SystemModule

extension WebAdmin.System {
    public enum Dashboard {}
}

extension WebAdmin.System.Dashboard {
    struct Router {
        let controller: any Controller.Interface
        let path: WebRoute

        init(
            apiBuilder: SystemAPIBuilder,
            renderingEngine: any RenderingEngine,
            events: any EventPublisher,
            path: WebRoute
        ) {
            self.path = path
            self.controller = Controller.Default(
                apiBuilder: apiBuilder,
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
