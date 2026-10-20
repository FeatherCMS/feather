import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Permission {
    enum Edit {}
}

extension WebAdmin.System.Permission.Edit {
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
                    (
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(
                                api: apiBuilder.makeSystemAdmin(context)
                            )
                        ),
                        presenter: Presenter.Default(
                            request: request,
                            context: context,
                            renderingEngine: renderingEngine,
                            routes: routes
                        )
                    )
                }
            )
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.get(
                routes.edit.routerPath,
                use: controller.getEditSystemPermission
            )
            router.post(
                routes.edit.routerPath,
                use: controller.postEditSystemPermission
            )
        }
    }
}
