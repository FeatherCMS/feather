import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import WebModule

extension Menu {
    struct Router {
        struct Routes: Sendable {
            let list: WebRoute
            let add: WebRoute
            let remove: WebRoute
            let details: WebRoute
            let detailsRemove: WebRoute
            let edit: WebRoute
            let listBreadcrumb: [AdminBreadcrumb.Link]
            let breadcrumb: [AdminBreadcrumb.Link]

            init(
                root: WebRoute,
                breadcrumb: [AdminBreadcrumb.Link]
            ) {
                self.list = root
                self.add = root.appending(pathComponent: "add")
                self.remove = root.appending(pathComponent: "remove")
                self.details = root.appending(parameter: "id")
                self.detailsRemove = details.appending(pathComponent: "remove")
                self.edit = details.appending(pathComponent: "edit")
                self.listBreadcrumb = breadcrumb
                self.breadcrumb =
                    breadcrumb + [
                        .init(label: "Menus", link: root.path)
                    ]
            }

            func detailsPath(_ id: String) -> String {
                details.path(parameter: "id", value: id)
            }

            func editPath(_ id: String) -> String {
                edit.path(parameter: "id", value: id)
            }

            func detailsRemovePath(_ id: String) -> String {
                detailsRemove.path(parameter: "id", value: id)
            }

            func menuBreadcrumb(_ menuID: String) -> [AdminBreadcrumb.Link] {
                listBreadcrumb + [
                    .init(label: "Menus", link: list.path),
                    .init(label: "Menu", link: detailsPath(menuID)),
                ]
            }

        }

        let environment: AppEnvironment
        let renderingEngine: any RenderingEngine
        let routes: Routes

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
            MenuItem.Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: MenuItem.Router.Routes(menu: routes)
            )
            .route(on: router)
        }
    }
}
