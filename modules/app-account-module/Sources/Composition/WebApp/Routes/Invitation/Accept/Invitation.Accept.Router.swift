import AccountModule
import FeatherWebApp
import FeatherWebShared
import Hummingbird

extension Invitation.Accept {
    struct Router {
        struct Routes: Sendable {
            let accept: WebRoute
            let login: WebRoute

            init() {
                let root = WebRoute.root
                accept = root
                    .appending(pathComponent: "account")
                    .appending(pathComponent: "invitation")
                    .appending(pathComponent: "accept")
                login = root.appending(pathComponent: "login")
            }
        }

        private let routes: Routes
        private let controller: any Controller.Interface

        init(
            environment: AppEnvironment,
            pageRenderer: any PublicPageRenderer
        ) {
            let routes = Routes()
            self.routes = routes
            self.controller = Controller.Default(
                environment: environment,
                pageRenderer: pageRenderer,
                routes: routes
            )
        }

        func route(
            on router: Hummingbird.Router<DefaultRequestContext>
        ) {
            router.get(routes.accept.routerPath, use: controller.get)
            router.post(routes.accept.routerPath, use: controller.post)
        }
    }
}
