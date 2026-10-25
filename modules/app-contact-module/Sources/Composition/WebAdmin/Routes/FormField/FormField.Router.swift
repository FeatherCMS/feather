import ContactModule
import ContactApplication
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension ContactModule.FormField {
    struct Router {
        let environment: AppEnvironment
        let renderingEngine: any RenderingEngine
        let routes: Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Routes
        ) {
            self.environment = environment
            self.renderingEngine = renderingEngine
            self.routes = routes
        }

        func route(
            on router: any RouterMethods<AuthenticatedRequestContext>
        ) {
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
            Remove.Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
        }

        struct Routes: Sendable {
            private let root: WebRoute
            private let breadcrumb: [AdminBreadcrumb.Link]
            let formRoutes: ContactModule.Form.Router.Routes

            init(
                root: WebRoute,
                breadcrumb: [AdminBreadcrumb.Link],
                formRoutes: ContactModule.Form.Router.Routes
            ) {
                self.root = root
                self.breadcrumb = breadcrumb
                self.formRoutes = formRoutes
            }

            var fields: WebRoute {
                root.appending(pathComponent: "fields")
            }

            var fieldAdd: WebRoute {
                fields.appending(pathComponent: "add")
            }

            var fieldEdit: WebRoute {
                fields.appending(parameter: "fieldId")
                    .appending(pathComponent: "edit")
            }

            var fieldRemove: WebRoute {
                fields.appending(parameter: "fieldId")
                    .appending(pathComponent: "remove")
            }

            var fieldsRemove: WebRoute {
                fields.appending(pathComponent: "remove")
            }

            var formFieldsData: WebRoute {
                root.appending(pathComponent: "forms")
                    .appending(parameter: "formKey")
                    .appending(pathComponent: "fields-data")
            }

            func fieldEditPath(
                _ id: String
            ) -> String {
                fieldEdit.path(parameter: "fieldId", value: id)
            }

            func fieldRemovePath(
                _ id: String
            ) -> String {
                fieldRemove.path(parameter: "fieldId", value: id)
            }

            func formFieldsPath(
                _ key: String
            ) -> String {
                root.appending(pathComponent: "forms")
                    .appending(parameter: "formKey")
                    .appending(pathComponent: "fields")
                    .path(parameter: "formKey", value: key)
            }

            func fieldAddBreadcrumb(
                _ formKey: String?
            ) -> [AdminBreadcrumb.Link] {
                let forms = root.appending(pathComponent: "forms")
                if let formKey {
                    return breadcrumb
                        + [.init(label: "Forms", link: forms.path)]
                        + [
                            .init(
                                label: formKey,
                                link: formFieldsPath(formKey)
                            ),
                            .init(label: "Add field", link: fieldAdd.path),
                        ]
                }
                return fieldsBreadcrumb + [
                    .init(label: "Add field", link: fieldAdd.path)
                ]
            }

            var fieldsBreadcrumb: [AdminBreadcrumb.Link] {
                breadcrumb + [.init(label: "Fields", link: fields.path)]
            }
        }
    }
}
