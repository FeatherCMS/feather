import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import WebDomain
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
            let items: WebRoute
            let itemsAdd: WebRoute
            let itemsRemove: WebRoute
            let itemDetails: WebRoute
            let itemEdit: WebRoute
            let itemMove: WebRoute
            let itemRemove: WebRoute
            let listBreadcrumb: [AdminBreadcrumb.Link]
            let breadcrumb: [AdminBreadcrumb.Link]

            enum RemoveOrigin: String {
                case list
                case edit
                case view
            }

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
                self.items = details.appending(pathComponent: "items")
                self.itemsAdd = items.appending(pathComponent: "add")
                self.itemsRemove = items.appending(pathComponent: "remove")
                self.itemDetails = items.appending(parameter: "itemId")
                self.itemEdit = itemDetails.appending(pathComponent: "edit")
                self.itemMove = itemDetails.appending(pathComponent: "move")
                self.itemRemove = itemDetails.appending(pathComponent: "remove")
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

            func itemsPath(_ menuID: String) -> String {
                items.path(parameter: "id", value: menuID)
            }

            func itemsAddPath(_ menuID: String) -> String {
                itemsAdd.path(parameter: "id", value: menuID)
            }

            func itemsRemovePath(_ menuID: String) -> String {
                itemsRemove.path(parameter: "id", value: menuID)
            }

            func itemDetailsPath(menuID: String, itemID: String) -> String {
                itemPath(itemDetails, menuID: menuID, itemID: itemID)
            }

            func itemEditPath(menuID: String, itemID: String) -> String {
                itemPath(itemEdit, menuID: menuID, itemID: itemID)
            }

            func itemMovePath(menuID: String, itemID: String) -> String {
                itemPath(itemMove, menuID: menuID, itemID: itemID)
            }

            func itemPath(_ route: WebRoute, menuID: String, itemID: String)
                -> String
            {
                try! route.path(
                    parameters: ["id": menuID, "itemId": itemID]
                )
            }

            func itemRemovePath(
                menuID: String,
                itemID: String,
                origin: RemoveOrigin
            ) -> String {
                AdminLocation.url(
                    path: itemPath(itemRemove, menuID: menuID, itemID: itemID),
                    queryItems: [("origin", origin.rawValue)]
                )
            }

            func removeOrigin(_ value: String?) -> RemoveOrigin {
                RemoveOrigin(rawValue: value ?? "") ?? .list
            }

            func menuBreadcrumb(_ menuID: String) -> [AdminBreadcrumb.Link] {
                listBreadcrumb + [
                    .init(label: "Menus", link: list.path),
                    .init(label: "Menu", link: detailsPath(menuID)),
                ]
            }

            func itemBreadcrumb(_ menuID: String) -> [AdminBreadcrumb.Link] {
                menuBreadcrumb(menuID) + [
                    .init(label: "Items", link: itemsPath(menuID))
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
        }
    }
}

extension WebModule.Menu.View {
    struct Router {
        let controller: any Controller.Interface
        let routes: WebModule.Menu.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: WebModule.Menu.Router.Routes
        ) {
            self.routes = routes
            controller = Controller.Default(
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(
                                api: API.Client(
                                    environment: environment,
                                    requestContext: context
                                )
                            )
                        ),
                        presenter: Presenter.Default(
                            request: request,
                            context: context,
                            renderingEngine: renderingEngine,
                            routes: routes
                        )
                    )
                }
            )
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.get(routes.details.routerPath, use: controller.getMenu)
        }
    }
}

extension WebModule.Menu.Add {
    struct Router {
        let controller: any Controller.Interface
        let routes: WebModule.Menu.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: WebModule.Menu.Router.Routes
        ) {
            self.routes = routes
            controller = Controller.Default(
                routes: routes,
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(
                                api: API.Client(
                                    environment: environment,
                                    requestContext: context
                                )
                            )
                        ),
                        presenter: Presenter.Default(
                            request: request,
                            context: context,
                            renderingEngine: renderingEngine,
                            routes: routes
                        )
                    )
                }
            )
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.get(
                routes.add.routerPath,
                use: controller.getAddMenu
            )
            router.post(
                routes.add.routerPath,
                use: controller.postAddMenu
            )
        }
    }
}

extension WebModule.Menu.Edit {
    struct Router {
        let controller: any Controller.Interface
        let routes: WebModule.Menu.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: WebModule.Menu.Router.Routes
        ) {
            self.routes = routes
            controller = Controller.Default(
                routes: routes,
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(
                                api: API.Client(
                                    environment: environment,
                                    requestContext: context
                                )
                            )
                        ),
                        presenter: Presenter.Default(
                            request: request,
                            context: context,
                            renderingEngine: renderingEngine,
                            routes: routes
                        )
                    )
                }
            )
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.get(
                routes.edit.routerPath,
                use: controller.getEditMenu
            )
            router.post(
                routes.edit.routerPath,
                use: controller.postEditMenu
            )
        }
    }
}

extension WebModule.Menu.Remove {
    struct Router {
        let controller: any Controller.Interface
        let routes: WebModule.Menu.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: WebModule.Menu.Router.Routes
        ) {
            self.routes = routes
            controller = Controller.Default(
                routes: routes,
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(
                                api: API.Client(
                                    environment: environment,
                                    requestContext: context
                                )
                            )
                        ),
                        presenter: Presenter.Default(
                            request: request,
                            context: context,
                            renderingEngine: renderingEngine,
                            routes: routes
                        )
                    )
                }
            )
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.post(
                routes.remove.routerPath,
                use: controller.postRemoveMenu
            )
        }
    }
}
