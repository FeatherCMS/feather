import AuthModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Credential {

    struct Router {
        struct Routes {
            let list: WebRoute
            let add: WebRoute
            let details: WebRoute
            let edit: WebRoute
            let remove: WebRoute
            let listBreadcrumb: [AdminBreadcrumb.Link]
            let breadcrumb: [AdminBreadcrumb.Link]

            init(root: WebRoute, breadcrumb: [AdminBreadcrumb.Link]) {
                let root = root.appending(pathComponent: "credentials")
                self.list = root
                self.add = root.appending(pathComponent: "add")
                self.details = root.appending(parameter: "id")
                self.edit = details.appending(pathComponent: "edit")
                self.remove = details.appending(pathComponent: "remove")
                self.listBreadcrumb = breadcrumb
                self.breadcrumb =
                    breadcrumb + [
                        .init(label: "Credentials", link: root.path)
                    ]
            }

            func detailsBreadcrumb(_ id: String) -> [AdminBreadcrumb.Link] {
                breadcrumb + [
                    .init(
                        label: "User",
                        link: details.path(parameter: "id", value: id)
                    )
                ]
            }

            func editPath(_ id: String) -> String {
                edit.path(parameter: "id", value: id)
            }

            func removePath(_ id: String) -> String {
                remove.path(parameter: "id", value: id)
            }

            func removeBreadcrumb(_ id: String) -> [AdminBreadcrumb.Link] {
                detailsBreadcrumb(id) + [
                    .init(
                        label: "Remove",
                        link: remove.path(parameter: "id", value: id)
                    )
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

        func route(
            on router: any RouterMethods<AuthenticatedRequestContext>
        ) {
            List
                .Router(
                    environment: environment,
                    renderingEngine: renderingEngine,
                    routes: routes
                )
                .route(on: router)
            Add
                .Router(
                    environment: environment,
                    renderingEngine: renderingEngine,
                    routes: routes
                )
                .route(on: router)
            Edit
                .Router(
                    environment: environment,
                    renderingEngine: renderingEngine,
                    routes: routes
                )
                .route(on: router)
            Remove
                .Router(
                    environment: environment,
                    renderingEngine: renderingEngine,
                    routes: routes
                )
                .route(on: router)
        }
    }
}
