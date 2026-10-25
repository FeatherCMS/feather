import FeatherWebApp
import FeatherWebShared
import Hummingbird

extension Logout {
    struct Router {
        struct Routes {
            let logout: WebRoute

            init(root: WebRoute = .root) {
                logout = root.appending(pathComponent: "logout")
            }
        }

        let routes: Routes
        let controller: any Controller.Interface

        init(
            repository: any Repository.Interface,
            usesSecureCookies: Bool,
            routes: Routes = .init()
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                buildRuntime: { _, _ in
                    WebAppRuntime(
                        interactor: Interactor.Default(
                            repository: repository
                        ),
                        presenter: Presenter.Default(
                            usesSecureCookies: usesSecureCookies
                        )
                    )
                }
            )
        }

        func route(on router: any RouterMethods<DefaultRequestContext>) {
            router.get(routes.logout.routerPath, use: controller.getLogout)
        }
    }
}
