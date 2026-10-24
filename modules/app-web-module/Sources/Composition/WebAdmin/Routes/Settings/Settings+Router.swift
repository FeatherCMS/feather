import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import WebDomain
import WebModule

extension Settings {
    struct Router {
        struct Routes: Sendable {
            let edit: WebRoute
            let breadcrumb: [AdminBreadcrumb.Link]

            init(edit: WebRoute, breadcrumb: [AdminBreadcrumb.Link]) {
                self.edit = edit
                self.breadcrumb =
                    breadcrumb + [
                        .init(label: "Settings", link: edit.path)
                    ]
            }
        }

        let environment: AppEnvironment
        let renderingEngine: any RenderingEngine
        let routes: Routes

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            Settings.Edit
                .Router(
                    environment: environment,
                    renderingEngine: renderingEngine,
                    routes: routes
                )
                .route(on: router)
        }
    }
}
