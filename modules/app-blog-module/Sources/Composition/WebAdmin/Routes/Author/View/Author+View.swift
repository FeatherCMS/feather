import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Author.View {
    struct Router {
        let controller: any Controller.Interface
        let routes: Author.Router.Routes
        let authorLinkRoutes: AuthorLink.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Author.Router.Routes,
            authorLinkRoutes: AuthorLink.Router.Routes
        ) {
            self.routes = routes
            self.authorLinkRoutes = authorLinkRoutes
            self.controller = Controller.Default(
                buildRuntime: { request, context in
                    (
                        interactor: Interactor.Default(
                            repository: Author.Detail.Repository.OpenAPI(
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
                            routes: routes,
                            authorLinkRoutes: authorLinkRoutes
                        )
                    )
                }
            )
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.get(
                routes.authors.appending(parameter: "id").routerPath,
                use: controller.getBlogAuthor
            )
        }
    }
}
