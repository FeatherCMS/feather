import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import WebDomain
import WebModule

extension MenuItem {
    struct Router {
        let environment: AppEnvironment
        let renderingEngine: any RenderingEngine
        let routes: Menu.Router.Routes

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            let list = AdminListMenuItem(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .controller
            router.get(
                routes.items.routerPath,
                use: list.getMenuItems
            )
            router.post(
                routes.itemMove.routerPath,
                use: list.postMenuItemMove
            )

            let view = AdminViewMenuItem(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .controller
            router.get(
                routes.itemDetails.routerPath,
                use: view.getMenuItem
            )

            let add = AdminAddMenuItem(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .controller
            router.get(
                routes.itemsAdd.routerPath,
                use: add.getAddMenuItem
            )
            router.post(
                routes.itemsAdd.routerPath,
                use: add.postAddMenuItem
            )

            let edit = AdminEditMenuItem(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .controller
            router.get(
                routes.itemEdit.routerPath,
                use: edit.getEditMenuItem
            )
            router.post(
                routes.itemEdit.routerPath,
                use: edit.postEditMenuItem
            )

            let remove = AdminRemoveMenuItem(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .controller
            router.post(
                routes.itemsRemove.routerPath,
                use: remove.postRemoveMenuItem
            )
        }
    }
}
