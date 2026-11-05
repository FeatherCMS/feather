import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import WebModule
import WebModuleWebAdmin

extension Post.Status {
    struct Router {
        let controller: any Controller.Interface
        let routes: Post.Router.Routes

        init(
            environment: AppEnvironment,
            routes: Post.Router.Routes
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                routes: routes,
                buildViewRepository: { context in
                    Post.View.Repository.OpenAPI(
                        api: API.Client(
                            environment: environment,
                            requestContext: context
                        )
                    )
                },
                buildStatusRepository: { context in
                    WebModule.Metadata.Status.Repository.OpenAPI(
                        api: WebModuleWebAdmin.API.Client(
                            environment: environment,
                            requestContext: context
                        )
                    )
                }
            )
        }

        func route(
            on router: any RouterMethods<AuthenticatedRequestContext>
        ) {
            router.post(
                routes.postStatusRoute.routerPath,
                use: controller.post
            )
        }
    }
}
