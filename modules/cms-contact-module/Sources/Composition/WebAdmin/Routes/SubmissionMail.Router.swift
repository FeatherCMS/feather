import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension SubmissionMail {
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
            let formRoutes: ContactModule.Form.Router.Routes

            init(
                root: WebRoute,
                formRoutes: ContactModule.Form.Router.Routes
            ) {
                self.root = root
                self.formRoutes = formRoutes
            }

            var formEmails: WebRoute {
                root.appending(pathComponent: "forms")
                    .appending(parameter: "formKey")
                    .appending(pathComponent: "emails")
            }

            var formEmailAdd: WebRoute {
                formEmails.appending(pathComponent: "add")
            }

            var formEmailEdit: WebRoute {
                formEmails.appending(parameter: "mailId")
                    .appending(pathComponent: "edit")
            }

            var formEmailRemove: WebRoute {
                formEmails.appending(pathComponent: "remove")
            }

            func formEmailsPath(
                _ key: String
            ) -> String {
                formEmails.path(parameter: "formKey", value: key)
            }

            func formEmailAddPath(
                _ key: String
            ) -> String {
                formEmailAdd.path(parameter: "formKey", value: key)
            }

            func formEmailEditPath(
                formKey: String,
                mailId: String
            ) -> String {
                try! formEmailEdit.path(
                    parameters: [
                        "formKey": formKey,
                        "mailId": mailId,
                    ]
                )
            }

            func formEmailRemovePath(
                _ key: String
            ) -> String {
                formEmailRemove.path(parameter: "formKey", value: key)
            }

            func formEmailsBreadcrumb(
                _: String
            ) -> [AdminBreadcrumb.Link] {
                formRoutes.formBreadcrumb
            }
        }
    }
}
