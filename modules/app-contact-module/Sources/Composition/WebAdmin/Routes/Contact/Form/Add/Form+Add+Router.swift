import ContactApplication
import ContactModule
import FeatherWebShared
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Form.Add {
    struct Router {
        let controller: any Controller.Interface
        let routes: Contact.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Contact.Router.Routes
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                routes: routes,
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(
                                api: API.Client(
                                    apiBaseURL: environment.apiBaseURL,
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
            router.get(routes.formAdd.routerPath, use: controller.add)
            router.post(routes.formAdd.routerPath, use: controller.create)
        }
    }
}
