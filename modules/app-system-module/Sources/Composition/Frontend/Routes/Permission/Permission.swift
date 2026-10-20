import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System {
    enum Permission {}
}

extension WebAdmin.System.Permission {
    struct Router {
        struct Routes {
            let list: WebRoute
            let add: WebRoute
            let remove: WebRoute
            let details: WebRoute
            let edit: WebRoute
            let listBreadcrumb: [AdminBreadcrumb.Link]
            let breadcrumb: [AdminBreadcrumb.Link]

            init(root: WebRoute, breadcrumb: [AdminBreadcrumb.Link]) {
                let root = root.appending(pathComponent: "permissions")
                self.list = root
                self.add = root.appending(pathComponent: "add")
                self.remove = root.appending(pathComponent: "remove")
                self.details = root.appending(parameter: "key")
                self.edit = self.details.appending(pathComponent: "edit")
                self.listBreadcrumb = breadcrumb
                self.breadcrumb =
                    breadcrumb + [
                        .init(label: "Permissions", link: root.path)
                    ]
            }

            func detailsPath(_ key: String) -> String {
                details.path(parameter: "key", value: key)
            }

            func editPath(_ key: String) -> String {
                edit.path(parameter: "key", value: key)
            }
        }

        let routes: Routes
        private let apiBuilder: SystemAPIBuilder
        private let renderingEngine: any RenderingEngine

        init(
            apiBuilder: SystemAPIBuilder,
            renderingEngine: any RenderingEngine,
            routes: Routes
        ) {
            self.apiBuilder = apiBuilder
            self.renderingEngine = renderingEngine
            self.routes = routes
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            List.Router(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)

            View.Router(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)

            Add.Router(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)

            Edit.Router(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)

            Remove.Router(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
        }
    }
}
