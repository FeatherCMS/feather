import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Post.Status {
    struct Router {
        let controller: any Controller.Interface
        let routes: BlogWebAdmin.Router.Routes

        init(
            environment: AppEnvironment,
            routes: BlogWebAdmin.Router.Routes = .standard
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                environment: environment,
                routes: routes
            )
        }

        func route(
            on router: any RouterMethods<AuthenticatedRequestContext>
        ) {
            router.post(
                routes.posts
                    .appending(parameter: "id")
                    .appending(pathComponent: "status")
                    .routerPath,
                use: controller.post
            )
        }
    }
}
