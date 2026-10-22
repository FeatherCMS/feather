import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Settings {
    struct Router {
        struct Routes: Sendable {
            let settings: WebRoute
            let userSettingsPattern: WebRoute
            let settingsBreadcrumb: [AdminBreadcrumb.Link]
            private let account: WebRoute

            init(root: WebRoute) {
                let account = root.appending(pathComponent: "account")
                let settings = account.appending(pathComponent: "settings")
                self.account = account
                self.settings = settings
                self.userSettingsPattern =
                    account
                    .appending(pathComponent: "users")
                    .appending(parameter: "userId")
                    .appending(pathComponent: "settings")
                self.settingsBreadcrumb = [
                    .init(label: "Admin", link: "/admin/"),
                    .init(label: "Account", link: account.path),
                    .init(label: "Settings", link: settings.path),
                ]
            }

            func userSettings(_ id: String) -> String {
                account
                    .appending(pathComponent: "users")
                    .appending(pathComponent: id)
                    .appending(pathComponent: "settings")
                    .path
            }
        }

        let routes: Routes
        private let environment: AppEnvironment
        private let renderingEngine: any RenderingEngine

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Routes
        ) {
            self.environment = environment
            self.renderingEngine = renderingEngine
            self.routes = routes
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            Edit.Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
        }
    }
}
