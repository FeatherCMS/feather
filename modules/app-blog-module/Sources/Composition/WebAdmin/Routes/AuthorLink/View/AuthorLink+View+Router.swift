import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension AuthorLink.View {
    struct Router {
        let controller: any Controller.Interface
        let routes: AuthorLink.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: AuthorLink.Router.Routes
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                buildRuntime: { request, context in
                    (
                        interactor: Interactor.Default(
                            repository: AuthorLink.Detail.Repository.OpenAPI(
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
            router.get(
                routes.authors
                    .appending(parameter: "id")
                    .appending(pathComponent: "links")
                    .appending(parameter: "itemId")
                    .routerPath,
                use: controller.get
            )
        }
    }
}
