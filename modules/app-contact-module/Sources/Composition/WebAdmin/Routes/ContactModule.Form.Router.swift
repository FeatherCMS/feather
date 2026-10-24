import ContactModule
import ContactApplication
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension ContactModule.Form {
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
            Search.Router(
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
            View.Router(
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

            init(root: WebRoute, breadcrumb: [AdminBreadcrumb.Link]) {
                self.root = root
                self.breadcrumb = breadcrumb
            }

            var forms: WebRoute {
                root.appending(pathComponent: "forms")
            }

            var formAdd: WebRoute {
                forms.appending(pathComponent: "add")
            }

            var formRemove: WebRoute {
                forms.appending(pathComponent: "remove")
            }

            var formDetails: WebRoute {
                forms.appending(parameter: "formKey")
            }

            var formDetailsPage: WebRoute {
                formDetails.appending(pathComponent: "details")
            }

            var formEdit: WebRoute {
                formDetails.appending(pathComponent: "edit")
            }

            var formFields: WebRoute {
                formDetails.appending(pathComponent: "fields")
            }

            var fieldAdd: WebRoute {
                root.appending(pathComponent: "fields")
                    .appending(pathComponent: "add")
            }

            var formEmails: WebRoute {
                formDetails.appending(pathComponent: "emails")
            }

            var formEmailAdd: WebRoute {
                formEmails.appending(pathComponent: "add")
            }

            func formDetailsPath(
                _ key: String
            ) -> String {
                formDetails.path(parameter: "formKey", value: key)
            }

            func formDetailsPagePath(
                _ key: String
            ) -> String {
                formDetailsPage.path(parameter: "formKey", value: key)
            }

            func formEditPath(
                _ key: String
            ) -> String {
                formEdit.path(parameter: "formKey", value: key)
            }

            func formFieldsPath(
                _ key: String
            ) -> String {
                formFields.path(parameter: "formKey", value: key)
            }

            var formsBreadcrumb: [AdminBreadcrumb.Link] {
                breadcrumb + [.init(label: "Forms", link: forms.path)]
            }

            func formDetailsBreadcrumb(_ key: String)
                -> [AdminBreadcrumb.Link]
            {
                formsBreadcrumb + [
                    .init(label: key, link: formDetailsPagePath(key))
                ]
            }

            func formEmailsBreadcrumb(_ key: String)
                -> [AdminBreadcrumb.Link]
            {
                formsBreadcrumb + [
                    .init(label: "Emails", link: formEmailsPath(key))
                ]
            }

            func formEmailsPath(
                _ key: String
            ) -> String {
                formEmails.path(parameter: "formKey", value: key)
            }
        }
    }
}
