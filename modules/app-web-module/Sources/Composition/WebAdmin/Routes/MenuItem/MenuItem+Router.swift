import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import WebDomain
import WebModule

extension MenuItem {
    struct Router {
        let environment: AppEnvironment
        let renderingEngine: any RenderingEngine
        let root: WebRoute

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            let items =
                root
                .appending(pathComponent: "menus")
                .appending(parameter: "id")
                .appending(pathComponent: "items")
            let listPath = items
            let addPath = items.appending(pathComponent: "add")
            let removePath = items.appending(pathComponent: "remove")
            let detailsPath = items.appending(parameter: "itemId")
            let editPath = detailsPath.appending(pathComponent: "edit")
            let movePath = detailsPath.appending(pathComponent: "move")
            let list = AdminListMenuItem(
                environment: environment,
                renderingEngine: renderingEngine
            )
            .controller
            router.get(
                listPath.routerPath,
                use: list.getMenuItems
            )
            router.post(
                movePath.routerPath,
                use: list.postMenuItemMove
            )

            let view = AdminViewMenuItem(
                environment: environment,
                renderingEngine: renderingEngine
            )
            .controller
            router.get(
                detailsPath.routerPath,
                use: view.getMenuItem
            )

            let add = AdminAddMenuItem(
                environment: environment,
                renderingEngine: renderingEngine
            )
            .controller
            router.get(
                addPath.routerPath,
                use: add.getAddMenuItem
            )
            router.post(
                addPath.routerPath,
                use: add.postAddMenuItem
            )

            let edit = AdminEditMenuItem(
                environment: environment,
                renderingEngine: renderingEngine
            )
            .controller
            router.get(
                editPath.routerPath,
                use: edit.getEditMenuItem
            )
            router.post(
                editPath.routerPath,
                use: edit.postEditMenuItem
            )

            let remove = AdminRemoveMenuItem(
                environment: environment,
                renderingEngine: renderingEngine
            )
            .controller
            router.post(
                removePath.routerPath,
                use: remove.postRemoveMenuItem
            )
        }
    }
}
