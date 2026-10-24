import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaModule

extension Variant {
    struct Router {
        struct Routes: Sendable {
            let list: WebRoute
            let add: WebRoute
            let remove: WebRoute
            let edit: WebRoute
            let processors: WebRoute
            let processorAdd: WebRoute
            let processorEdit: WebRoute
            let processorRemove: WebRoute
            let breadcrumb: [AdminBreadcrumb.Link]

            init(root: WebRoute, breadcrumb: [AdminBreadcrumb.Link]) {
                self.list = root.appending(pathComponent: "variants")
                self.add = list.appending(pathComponent: "add")
                self.remove = list.appending(pathComponent: "remove")
                let variant = list.appending(parameter: "id")
                self.edit = variant.appending(pathComponent: "edit")
                self.processors = variant.appending(pathComponent: "processors")
                self.processorAdd = processors.appending(pathComponent: "add")
                self.processorEdit =
                    processors
                    .appending(parameter: "id")
                    .appending(parameter: "processorId")
                    .appending(pathComponent: "edit")
                self.processorRemove = processors.appending(
                    pathComponent: "remove"
                )
                self.breadcrumb =
                    breadcrumb + [
                        .init(label: "Variants", link: list.path)
                    ]
            }

            func editPath(_ id: String) -> String {
                edit.path(parameter: "id", value: id)
            }

            func processorPath(_ id: String) -> String {
                processors.path(parameter: "id", value: id)
            }

            func processorAddPath(_ id: String) -> String {
                processorAdd.path(parameter: "id", value: id)
            }

            func processorEditPath(_ id: String, processorId: String) -> String
            {
                guard
                    let path = try? processorEdit.path(parameters: [
                        "id": id,
                        "processorId": processorId,
                    ])
                else {
                    preconditionFailure(
                        "The processor edit route must resolve both parameters."
                    )
                }
                return path
            }

            func processorRemovePath(_ id: String) -> String {
                processorRemove.path(parameter: "id", value: id)
            }
        }

        let routes: Routes
        let environment: AppEnvironment
        let renderingEngine: any RenderingEngine

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            List.Router(
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
            Processor.List
                .Router(
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
