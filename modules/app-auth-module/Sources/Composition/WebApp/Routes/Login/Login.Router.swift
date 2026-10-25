import FeatherWebApp
import FeatherWebShared
import Hummingbird

extension Login {
    struct Router {
        struct Routes {
            let login: WebRoute

            init(root: WebRoute = .root) {
                login = root.appending(pathComponent: "login")
            }
        }

        let routes: Routes
        let controller: any Controller.Interface

        init(
            repository: any Repository.Interface,
            templateRenderer: any TemplateRenderer,
            usesSecureCookies: Bool,
            turnstileVerifier: (any AuthTurnstileVerifier)? = nil,
            routes: Routes = .init()
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                usesSecureCookies: usesSecureCookies,
                turnstileVerifier: turnstileVerifier,
                buildRuntime: { _, _ in
                    WebAppRuntime(
                        interactor: Interactor.Default(
                            repository: repository
                        ),
                        presenter: Presenter.Default(
                            templateRenderer: templateRenderer,
                            routes: routes
                        )
                    )
                }
            )
        }

        func route(on router: any RouterMethods<DefaultRequestContext>) {
            router.get(routes.login.routerPath, use: controller.getLogin)
            router.post(routes.login.routerPath, use: controller.postLogin)
        }
    }
}
