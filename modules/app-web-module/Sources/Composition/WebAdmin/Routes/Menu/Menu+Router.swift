import FeatherWebAdmin
import Hummingbird
import WebDomain

extension Menu {
    enum Add {}
    enum Edit {}
    enum Remove {}
    enum View {}

    struct Router {
        let apiBuilder: API.Builder
        let renderingEngine: any RenderingEngine

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            List.Router(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .route(on: router)
            View.Router(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .route(on: router)
            Add.Router(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .route(on: router)
            Edit.Router(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .route(on: router)
            Remove.Router(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .route(on: router)
        }
    }
}

extension Menu.View {
    struct Router {
        let controller: any AdminViewWebMenuController

        init(apiBuilder: API.Builder, renderingEngine: any RenderingEngine) {
            controller =
                AdminViewWebMenu(
                    apiBuilder: apiBuilder,
                    renderingEngine: renderingEngine
                )
                .controller
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.get("/admin/web/menus/{id}/", use: controller.getWebMenu)
        }
    }
}

extension Menu.Add {
    struct Router {
        let controller: any AdminAddWebMenuController

        init(apiBuilder: API.Builder, renderingEngine: any RenderingEngine) {
            controller =
                AdminAddWebMenu(
                    apiBuilder: apiBuilder,
                    renderingEngine: renderingEngine
                )
                .controller
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.get(
                "/admin/web/menus/add/",
                use: controller.getAddWebMenu
            )
            router.post(
                "/admin/web/menus/add/",
                use: controller.postAddWebMenu
            )
        }
    }
}

extension Menu.Edit {
    struct Router {
        let controller: any AdminEditWebMenuController

        init(apiBuilder: API.Builder, renderingEngine: any RenderingEngine) {
            controller =
                AdminEditWebMenu(
                    apiBuilder: apiBuilder,
                    renderingEngine: renderingEngine
                )
                .controller
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.get(
                "/admin/web/menus/{id}/edit/",
                use: controller.getEditWebMenu
            )
            router.post(
                "/admin/web/menus/{id}/edit/",
                use: controller.postEditWebMenu
            )
        }
    }
}

extension Menu.Remove {
    struct Router {
        let controller: any AdminRemoveWebMenuController

        init(apiBuilder: API.Builder, renderingEngine: any RenderingEngine) {
            controller =
                AdminRemoveWebMenu(
                    apiBuilder: apiBuilder,
                    renderingEngine: renderingEngine
                )
                .controller
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.post(
                "/admin/web/menus/remove/",
                use: controller.postRemoveWebMenu
            )
        }
    }
}
