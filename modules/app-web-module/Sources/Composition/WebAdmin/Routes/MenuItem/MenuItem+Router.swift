import FeatherWebAdmin
import Hummingbird
import WebDomain

extension MenuItem {
    struct Router {
        let apiBuilder: API.Builder
        let renderingEngine: any RenderingEngine

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            let list = AdminListWebMenuItem(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .controller
            router.get(
                "/admin/web/menus/{id}/items/",
                use: list.getWebMenuItems
            )
            router.post(
                "/admin/web/menus/{id}/items/{itemId}/move/",
                use: list.postWebMenuItemMove
            )

            let view = AdminViewWebMenuItem(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .controller
            router.get(
                "/admin/web/menus/{id}/items/{itemId}/",
                use: view.getWebMenuItem
            )

            let add = AdminAddWebMenuItem(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .controller
            router.get(
                "/admin/web/menus/{id}/items/add/",
                use: add.getAddWebMenuItem
            )
            router.post(
                "/admin/web/menus/{id}/items/add/",
                use: add.postAddWebMenuItem
            )

            let edit = AdminEditWebMenuItem(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .controller
            router.get(
                "/admin/web/menus/{id}/items/{itemId}/edit/",
                use: edit.getEditWebMenuItem
            )
            router.post(
                "/admin/web/menus/{id}/items/{itemId}/edit/",
                use: edit.postEditWebMenuItem
            )

            let remove = AdminRemoveWebMenuItem(
                apiBuilder: apiBuilder,
                renderingEngine: renderingEngine
            )
            .controller
            router.post(
                "/admin/web/menus/{id}/items/remove/",
                use: remove.postRemoveWebMenuItem
            )
        }
    }
}
