import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import WebDomain

extension Page {
    struct Router {
        struct Routes: Sendable {
            let list: WebRoute
            let add: WebRoute
            let remove: WebRoute
            let details: WebRoute
            let edit: WebRoute
            let metadata: WebRoute
            let status: WebRoute

            init(root: WebRoute) {
                let root = root.appending(pathComponent: "pages")
                self.list = root
                self.add = root.appending(pathComponent: "add")
                self.remove = root.appending(pathComponent: "remove")
                self.details = root.appending(parameter: "id")
                self.edit = details.appending(pathComponent: "edit")
                self.metadata =
                    edit
                    .appending(pathComponent: "metadata")
                    .appending(parameter: "metadataID")
                self.status = details.appending(pathComponent: "status")
            }
        }

        let environment: AppEnvironment
        let renderingEngine: any RenderingEngine
        let events: any EventPublisher
        let root: WebRoute

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            let routes = Routes(root: root)
            let list = AdminListWebPage(
                environment: environment,
                renderingEngine: renderingEngine
            )
            .controller
            router.get(routes.list.routerPath, use: list.getWebPages)
            router.post(routes.status.routerPath, use: list.postWebPageStatus)

            let view = AdminViewWebPage(
                environment: environment,
                renderingEngine: renderingEngine
            )
            .controller
            router.get(routes.details.routerPath, use: view.getWebPage)

            let add = AdminAddWebPage(
                environment: environment,
                renderingEngine: renderingEngine
            )
            .controller
            router.get(routes.add.routerPath, use: add.getAddWebPage)
            router.post(routes.add.routerPath, use: add.postAddWebPage)

            let edit = AdminEditWebPage(
                environment: environment,
                renderingEngine: renderingEngine
            )
            .controller
            router.get(routes.edit.routerPath, use: edit.getEditWebPage)
            router.post(routes.edit.routerPath, use: edit.postEditWebPage)

            let metadata = AdminEditWebPageMetadata(
                environment: environment,
                renderingEngine: renderingEngine,
                events: events
            )
            .controller
            router.get(
                routes.metadata.routerPath,
                use: metadata.getEditWebPageMetadata
            )
            router.post(
                routes.metadata.routerPath,
                use: metadata.postEditWebPageMetadata
            )

            let remove = AdminRemoveWebPage(
                environment: environment,
                renderingEngine: renderingEngine
            )
            .controller
            router.post(routes.remove.routerPath, use: remove.postRemoveWebPage)
        }
    }
}
