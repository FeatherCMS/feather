import AuthModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension MagicLink.App {
    struct Router {
        struct Routes {
            let request: WebRoute
            let verify: WebRoute
            let login: WebRoute

            let home: WebRoute

            init(root: WebRoute = .root) {
                request = root.appending(pathComponent: "magic-link")
                verify = request.appending(pathComponent: "verify")
                login = root.appending(pathComponent: "login")
                home = root
            }
        }

        let routes: Routes
        let controller: any Controller.Interface

        init(
            environment: AppEnvironment,
            usesSecureCookies: Bool,
            turnstileVerifier: (any AuthTurnstileVerifier)? = nil,
            routes: Routes = .init()
        ) {
            self.routes = routes
            let repository = Repository.OpenAPI(environment: environment)
            self.controller = Controller.Default(
                usesSecureCookies: usesSecureCookies,
                turnstileVerifier: turnstileVerifier,
                routes: routes,
                buildRuntime: { _, _ in
                    (
                        interactor: Interactor.Default(repository: repository),
                        presenter: Presenter.Default()
                    )
                }
            )
        }

        func route(on router: Hummingbird.Router<DefaultRequestContext>) {
            controller.route(on: router, routes: routes)
        }
    }
}
