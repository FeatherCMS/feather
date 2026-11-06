import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension ContactModule.Form.Edit {
    struct Router {
        let controller: any Controller.Interface
        let routes: Form.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Form.Router.Routes
        ) {
            self.routes = routes
            controller = Controller.Default(
                routes: routes,
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(
                                api: API.Client(
                                    environment: environment,
                                    requestContext: context
                                )
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

        func route(
            on router: any RouterMethods<AuthenticatedRequestContext>
        ) {
            router.get(routes.formEdit.routerPath, use: controller.edit)
            router.post(routes.formEdit.routerPath, use: controller.update)
            router.get(routes.formFields.routerPath, use: controller.fields)
            router.post(
                routes.formFields.routerPath,
                use: controller.updateFields
            )
        }
    }
}
