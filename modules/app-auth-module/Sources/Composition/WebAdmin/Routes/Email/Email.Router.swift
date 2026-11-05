import AuthModule
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import Hummingbird

extension Email {
    struct Router {
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

            View.Router(
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
        }

        struct Routes {
            let list: WebRoute
            let add: WebRoute
            let details: WebRoute
            let edit: WebRoute
            let remove: WebRoute
            let listBreadcrumb: [AdminBreadcrumb.Link]
            let breadcrumb: [AdminBreadcrumb.Link]

            init(root: WebRoute, breadcrumb: [AdminBreadcrumb.Link]) {
                let root = root.appending(pathComponent: "emails")
                self.list = root
                self.add = root.appending(pathComponent: "add")
                self.remove = root.appending(pathComponent: "remove")
                self.details = root.appending(parameter: "id")
                self.edit = details.appending(pathComponent: "edit")
                self.listBreadcrumb = breadcrumb
                self.breadcrumb =
                    breadcrumb + [
                        .init(label: "Emails", link: root.path)
                    ]
            }

            func detailsPath(_ id: String) -> String {
                details.path(parameter: "id", value: id)
            }

            func editPath(_ id: String) -> String {
                edit.path(parameter: "id", value: id)
            }

            func removePath(_ id: String) -> String {
                var components = URLComponents()
                components.path = remove.path
                components.queryItems = [URLQueryItem(name: "id", value: id)]
                return components.string ?? remove.path
            }

        }
    }
}
