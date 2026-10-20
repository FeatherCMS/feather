import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Permission {
    enum View {}
}

extension WebAdmin.System.Permission.View {
    struct Router {
        let controller: any Controller.Interface
        let routes: WebAdmin.System.Permission.Router.Routes

        init(
            apiBuilder: SystemAPIBuilder,
            renderingEngine: any RenderingEngine,
            routes: WebAdmin.System.Permission.Router.Routes
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                buildRuntime: { request, context in
                    let repository = Repository.OpenAPI(
                        api: apiBuilder.makeSystemAdmin(context)
                    )
                    let interactor = Interactor.Default(repository: repository)
                    let presenter = Presenter.Default(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine,
                        routes: routes
                    )
                    return (
                        interactor: interactor,
                        presenter: presenter
                    )
                }
            )
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.get(
                routes.details.routerPath,
                use: controller.getSystemPermission
            )
        }
    }
}
