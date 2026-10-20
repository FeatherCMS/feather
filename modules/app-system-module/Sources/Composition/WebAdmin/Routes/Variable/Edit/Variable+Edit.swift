import FeatherAdmin
import Hummingbird
import SystemModule

extension Variable {
    enum Edit {}
}

extension Variable.Edit {
    struct Router {
        let controller: any Controller.Interface
        let routes: Variable.Router.Routes

        init(
            apiBuilder: API.Builder,
            renderingEngine: any RenderingEngine,
            routes: Variable.Router.Routes
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
                use: controller.getEditSystemVariable
            )
            router.post(
                routes.edit.routerPath,
                use: controller.postEditSystemVariable
            )
        }
    }
}
