import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import WebDomain

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
            let list = AdminListWebMenuItem(
                environment: environment,
                renderingEngine: renderingEngine
            )
            .controller
            router.get(
                listPath.routerPath,
                use: list.getWebMenuItems
            )
            router.post(
                movePath.routerPath,
                use: list.postWebMenuItemMove
            )

            let view = AdminViewWebMenuItem(
                environment: environment,
                renderingEngine: renderingEngine
            )
            .controller
            router.get(
                detailsPath.routerPath,
                use: view.getWebMenuItem
            )

            let add = AdminAddWebMenuItem(
                environment: environment,
                renderingEngine: renderingEngine
            )
            .controller
            router.get(
                addPath.routerPath,
                use: add.getAddWebMenuItem
            )
            router.post(
                addPath.routerPath,
                use: add.postAddWebMenuItem
            )

            let edit = AdminEditWebMenuItem(
                environment: environment,
                renderingEngine: renderingEngine
            )
            .controller
            router.get(
                editPath.routerPath,
                use: edit.getEditWebMenuItem
            )
            router.post(
                editPath.routerPath,
                use: edit.postEditWebMenuItem
            )

            let remove = AdminRemoveWebMenuItem(
                environment: environment,
                renderingEngine: renderingEngine
            )
            .controller
            router.post(
                removePath.routerPath,
                use: remove.postRemoveWebMenuItem
            )
        }
    }
}
