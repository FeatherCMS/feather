import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Tag.Edit {
    struct Router {
        let controller: any Controller.Interface
        let routes: Tag.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Tag.Router.Routes
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
            let path = routes.tags.appending(parameter: "id")
                .appending(pathComponent: "edit").routerPath
            router.get(path, use: controller.get)
            router.post(path, use: controller.post)
        }
    }
}
