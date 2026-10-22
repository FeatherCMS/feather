import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Profile {
    struct Router {
        struct Routes: Sendable {
            let profile: WebRoute
            let profileEdit: WebRoute
            let profileBreadcrumb: [AdminBreadcrumb.Link]

            init(root: WebRoute) {
                let account = root.appending(pathComponent: "account")
                let profile = account.appending(pathComponent: "profile")
                self.profile = profile
                self.profileEdit = profile.appending(pathComponent: "edit")
                self.profileBreadcrumb = [
                    .init(label: "Admin", link: "/admin/"),
                    .init(label: "Account", link: account.path),
                    .init(label: "Profile", link: profile.path),
                ]
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
            Detail.Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
            Edit.Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
        }
    }
}
