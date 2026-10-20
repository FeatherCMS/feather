import FeatherWebAdmin
import Hummingbird
import SystemModule

enum Variable {
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
                let root = root.appending(pathComponent: "variables")
                self.list = root
                self.add = root.appending(pathComponent: "add")
                self.remove = root.appending(pathComponent: "remove")
                self.details = root.appending(parameter: "key")
                self.edit = self.details.appending(pathComponent: "edit")
                self.listBreadcrumb = breadcrumb
                self.breadcrumb =
                    breadcrumb + [
                        .init(label: "Variables", link: root.path)
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
            List.Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)

            Add.Router(
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

            Remove.Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)

            View.Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
        }
    }
}
