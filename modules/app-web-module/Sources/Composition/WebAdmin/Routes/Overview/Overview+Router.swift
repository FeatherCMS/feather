import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Overview {
    struct Router {
        let renderingEngine: any RenderingEngine
        let path: WebRoute

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            let controller = Controller.Default(
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Interactor.Default(),
                        presenter: Presenter.Default(
                            request: request,
                            context: context,
                            renderingEngine: renderingEngine
                        )
                    )
                }
            )
            router.get(path.routerPath, use: controller.getOverview)
        }
    }
}
