import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import Hummingbird

extension Settings {
    struct Router {
        struct Routes: Sendable {
            let settings: WebRoute
            let userSettingsPattern: WebRoute
            let settingsBreadcrumb: [AdminBreadcrumb.Link]
            private let account: WebRoute
            private let userIdentityRoot: WebRoute
            private let authMagicLinksRoot: WebRoute

            init(
                root: WebRoute,
                userIdentityRoot: WebRoute,
                authMagicLinksRoot: WebRoute
            ) {
                let account = root.appending(pathComponent: "account")
                let settings = account.appending(pathComponent: "settings")
                self.account = account
                self.userIdentityRoot = userIdentityRoot
                self.authMagicLinksRoot = authMagicLinksRoot
                self.settings = settings
                self.userSettingsPattern =
                    account
                    .appending(pathComponent: "users")
                    .appending(parameter: "userId")
                    .appending(pathComponent: "settings")
                self.settingsBreadcrumb = [
                    .init(label: "Admin", link: root.path),
                    .init(label: "Account", link: account.path),
                    .init(label: "Settings", link: settings.path),
                ]
            }

            func userSettingsPath(_ id: String) -> String {
                userSettingsPattern.path(
                    parameter: "userId",
                    value: id
                )
            }

            func userIdentityPath(_ id: String) -> String {
                userIdentityRoot
                    .appending(parameter: "userId")
                    .path(parameter: "userId", value: id)
            }

            func userSessionsPath(_ id: String) -> String {
                userIdentityRoot
                    .appending(parameter: "userId")
                    .appending(pathComponent: "sessions")
                    .path(parameter: "userId", value: id)
            }

            func magicLinksPath(_ userID: String) -> String {
                var components = URLComponents()
                components.path = authMagicLinksRoot.path
                components.queryItems = [
                    URLQueryItem(name: "userId", value: userID)
                ]
                return components.string ?? components.path
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
