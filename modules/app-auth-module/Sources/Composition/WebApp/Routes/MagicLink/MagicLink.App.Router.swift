import AuthModule
import FeatherWebApp
import FeatherWebShared
import Hummingbird

extension MagicLink.App {
    struct Router {
        struct Routes {
            let request: WebRoute
            let verify: WebRoute
            let login: WebRoute

            let home: WebRoute
            let admin: WebRoute

            init(root: WebRoute = .root) {
                request = root.appending(pathComponent: "magic-link")
                verify = request.appending(pathComponent: "verify")
                login = root.appending(pathComponent: "login")
                home = root
                admin = root.appending(pathComponent: "admin")
            }
        }

        let routes: Routes
        let controller: any Controller.Interface

        init(
            environment: AppEnvironment,
            templateRenderer: any TemplateRenderer,
            usesSecureCookies: Bool,
            turnstileVerifier: (any TurnstileVerifier)? = nil,
            routes: Routes = .init()
        ) {
            self.routes = routes
            let repository = Repository.OpenAPI(environment: environment)
            self.controller = Controller.Default(
                usesSecureCookies: usesSecureCookies,
                turnstileVerifier: turnstileVerifier,
                routes: routes,
                buildRuntime: { _, _ in
                    WebAppRuntime(
                        interactor: Interactor.Default(repository: repository),
                        presenter: Presenter.Default(
                            templateRenderer: templateRenderer
                        )
                    )
                }
            )
        }

        func route(on router: Hummingbird.Router<DefaultRequestContext>) {
            router.get(routes.request.routerPath, use: controller.getRequest)
            router.post(routes.request.routerPath, use: controller.postRequest)
            router.get(routes.verify.routerPath, use: controller.verify)
        }
    }
}
