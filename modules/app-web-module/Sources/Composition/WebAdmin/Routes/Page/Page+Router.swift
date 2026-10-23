import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import WebDomain
import WebModule

extension Page {
    struct Router {
        struct Routes: Sendable {
            let list: WebRoute
            let add: WebRoute
            let remove: WebRoute
            let details: WebRoute
            let detailsRemove: WebRoute
            let edit: WebRoute
            let metadata: WebRoute
            let status: WebRoute
            let listBreadcrumb: [AdminBreadcrumb.Link]
            let breadcrumb: [AdminBreadcrumb.Link]

            init(root: WebRoute, breadcrumb: [AdminBreadcrumb.Link]) {
                self.list = root
                self.add = root.appending(pathComponent: "add")
                self.remove = root.appending(pathComponent: "remove")
                self.details = root.appending(parameter: "id")
                self.detailsRemove = details.appending(pathComponent: "remove")
                self.edit = details.appending(pathComponent: "edit")
                self.metadata =
                    edit
                    .appending(pathComponent: "metadata")
                    .appending(parameter: "metadataID")
                self.status = details.appending(pathComponent: "status")
                self.listBreadcrumb = breadcrumb
                self.breadcrumb =
                    breadcrumb + [
                        .init(label: "Pages", link: root.path)
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

            func metadataPath(pageID: String, metadataID: String) -> String {
                try! metadata.path(
                    parameters: ["id": pageID, "metadataID": metadataID]
                )
            }

            func statusPath(_ id: String) -> String {
                status.path(parameter: "id", value: id)
            }
        }

        let environment: AppEnvironment
        let renderingEngine: any RenderingEngine
        let events: any EventPublisher
        let routes: Routes

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            Page.Search
                .Router(
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

            let metadata = AdminEditPageMetadata(
                environment: environment,
                renderingEngine: renderingEngine,
                events: events,
                routes: routes
            )
            .controller
            router.get(
                routes.metadata.routerPath,
                use: metadata.getEditPageMetadata
            )
            router.post(
                routes.metadata.routerPath,
                use: metadata.postEditPageMetadata
            )

            Remove.Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
        }
    }
}
