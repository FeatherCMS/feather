import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension AuthorLink.Edit {
    struct Router {
        let controller: any Controller.Interface
        let routes: BlogWebAdmin.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: BlogWebAdmin.Router.Routes = .standard
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                routes: routes,
                buildRuntime: { request, context in
                    (
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
            let route = routes.authors
                .appending(parameter: "authorID")
                .appending(pathComponent: "links")
                .appending(parameter: "itemId")
                .appending(pathComponent: "edit")
                .routerPath
            router.get(route, use: controller.get)
            router.post(route, use: controller.post)
        }
    }
}
