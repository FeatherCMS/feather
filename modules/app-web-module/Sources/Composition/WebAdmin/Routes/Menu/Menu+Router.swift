import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import WebDomain

extension Menu {
    enum Add {}
    enum Edit {}
    enum Remove {}
    enum View {}

    struct Router {
        struct Routes: Sendable {
            let list: WebRoute
            let add: WebRoute
            let remove: WebRoute
            let details: WebRoute
            let edit: WebRoute
            let items: WebRoute

            init(root: WebRoute) {
                let root = root.appending(pathComponent: "menus")
                self.list = root
                self.add = root.appending(pathComponent: "add")
                self.remove = root.appending(pathComponent: "remove")
                self.details = root.appending(parameter: "id")
                self.edit = details.appending(pathComponent: "edit")
                self.items = details.appending(pathComponent: "items")
            }
        }

        let environment: AppEnvironment
        let renderingEngine: any RenderingEngine
        let root: WebRoute

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            let routes = Routes(root: root)
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

extension Menu.View {
    struct Router {
        let controller: any AdminViewWebMenuController
        let routes: Menu.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Menu.Router.Routes
        ) {
            self.routes = routes
            controller =
                AdminViewWebMenu(
                    environment: environment,
                    renderingEngine: renderingEngine
                )
                .controller
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.get(routes.details.routerPath, use: controller.getWebMenu)
        }
    }
}

extension Menu.Add {
    struct Router {
        let controller: any AdminAddWebMenuController
        let routes: Menu.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Menu.Router.Routes
        ) {
            self.routes = routes
            controller =
                AdminAddWebMenu(
                    environment: environment,
                    renderingEngine: renderingEngine
                )
                .controller
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.get(
                routes.add.routerPath,
                use: controller.getAddWebMenu
            )
            router.post(
                routes.add.routerPath,
                use: controller.postAddWebMenu
            )
        }
    }
}

extension Menu.Edit {
    struct Router {
        let controller: any AdminEditWebMenuController
        let routes: Menu.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Menu.Router.Routes
        ) {
            self.routes = routes
            controller =
                AdminEditWebMenu(
                    environment: environment,
                    renderingEngine: renderingEngine
                )
                .controller
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.get(
                routes.edit.routerPath,
                use: controller.getEditWebMenu
            )
            router.post(
                routes.edit.routerPath,
                use: controller.postEditWebMenu
            )
        }
    }
}

extension Menu.Remove {
    struct Router {
        let controller: any AdminRemoveWebMenuController
        let routes: Menu.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Menu.Router.Routes
        ) {
            self.routes = routes
            controller =
                AdminRemoveWebMenu(
                    environment: environment,
                    renderingEngine: renderingEngine
                )
                .controller
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.post(
                routes.remove.routerPath,
                use: controller.postRemoveWebMenu
            )
        }
    }
}
