import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaModule

extension Asset {
    struct Router {
        struct Routes: Sendable {
            let file: File.Router.Routes
            let folder: Folder.Router.Routes

            init(root: WebRoute, breadcrumb: [AdminBreadcrumb.Link]) {
                let assetRoot = root.appending(pathComponent: "assets")
                self.file = .init(root: assetRoot, breadcrumb: breadcrumb)
                self.folder = .init(
                    root: root.appending(pathComponent: "folders"),
                    breadcrumb: breadcrumb,
                    assetList: file.list
                )
            }
        }

        let routes: Routes
        let environment: AppEnvironment
        let renderingEngine: any RenderingEngine

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            File.List
                .Router(
                    environment: environment,
                    renderingEngine: renderingEngine,
                    routes: routes
                )
                .route(on: router)
            File.Add
                .Router(
                    environment: environment,
                    renderingEngine: renderingEngine,
                    routes: routes
                )
                .route(on: router)
            Folder.Add
                .Router(
                    environment: environment,
                    renderingEngine: renderingEngine,
                    routes: routes
                )
                .route(on: router)
            File.View
                .Router(
                    environment: environment,
                    renderingEngine: renderingEngine,
                    routes: routes
                )
                .route(on: router)
            File.Edit
                .Router(
                    environment: environment,
                    renderingEngine: renderingEngine,
                    routes: routes
                )
                .route(on: router)
            Folder.Edit
                .Router(
                    environment: environment,
                    renderingEngine: renderingEngine,
                    routes: routes
                )
                .route(on: router)
            File.Remove
                .Router(
                    environment: environment,
                    renderingEngine: renderingEngine,
                    routes: routes
                )
                .route(on: router)
        }
    }
    }

    extension Asset.File {
    struct Router {
        struct Routes: Sendable {
            let list: WebRoute
            let add: WebRoute
            let remove: WebRoute
            let details: WebRoute
            let edit: WebRoute
            let listBreadcrumb: [AdminBreadcrumb.Link]
            let breadcrumb: [AdminBreadcrumb.Link]

            init(root: WebRoute, breadcrumb: [AdminBreadcrumb.Link]) {
                self.list = root
                self.add = root.appending(pathComponent: "add")
                self.remove = root.appending(pathComponent: "remove")
                self.details = root.appending(parameter: "id")
                self.edit = details.appending(pathComponent: "edit")
                self.listBreadcrumb = breadcrumb
                self.breadcrumb =
                    breadcrumb + [
                        .init(label: "Assets", link: root.path)
                    ]
            }

            func detailsPath(_ id: String) -> String {
                details.path(parameter: "id", value: id)
            }

            func editPath(_ id: String) -> String {
                edit.path(parameter: "id", value: id)
            }

            func removePath(_ id: String) -> String {
                details.appending(pathComponent: "remove")
                    .path(
                        parameter: "id",
                        value: id
                    )
            }
        }
    }
    }

    extension Asset.Folder {
    struct Router {
        struct Routes: Sendable {
            let add: WebRoute
            let edit: WebRoute
            let assetList: WebRoute
            let breadcrumb: [AdminBreadcrumb.Link]

            init(
                root: WebRoute,
                breadcrumb: [AdminBreadcrumb.Link],
                assetList: WebRoute
            ) {
                self.add = root.appending(pathComponent: "add")
                self.edit = root.appending(parameter: "id")
                    .appending(pathComponent: "edit")
                self.assetList = assetList
                self.breadcrumb =
                    breadcrumb + [
                        .init(label: "Assets", link: assetList.path)
                    ]
            }

            func editPath(_ id: String) -> String {
                edit.path(parameter: "id", value: id)
            }
        }
    }
}
