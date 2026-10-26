import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Submission {
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
            Detail.Router(
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
            Search.Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
            Remove.Router(
                environment: environment,
                routes: routes
            )
            .route(on: router)
        }

        struct Routes: Sendable {
            private let root: WebRoute
            let breadcrumb: [AdminBreadcrumb.Link]
            let formRoutes: Form.Router.Routes

            init(
                root: WebRoute,
                breadcrumb: [AdminBreadcrumb.Link],
                formRoutes: Form.Router.Routes
            ) {
                self.root = root
                self.breadcrumb = breadcrumb
                self.formRoutes = formRoutes
            }

            var submissions: WebRoute {
                root.appending(pathComponent: "submissions")
            }

            var submissionsRemove: WebRoute {
                submissions.appending(pathComponent: "remove")
            }

            var formSubmissions: WebRoute {
                root.appending(pathComponent: "forms")
                    .appending(parameter: "formKey")
                    .appending(pathComponent: "submissions")
            }

            var formSubmissionDetail: WebRoute {
                formSubmissions.appending(parameter: "submissionId")
            }

            var formSubmissionEdit: WebRoute {
                formSubmissionDetail.appending(pathComponent: "edit")
            }

            var formSubmissionRemoveSelected: WebRoute {
                formSubmissions.appending(pathComponent: "remove")
            }

            func formSubmissionDetailPath(
                formKey: String,
                submissionId: String
            ) -> String {
                try! formSubmissionDetail.path(
                    parameters: [
                        "formKey": formKey,
                        "submissionId": submissionId,
                    ]
                )
            }

            func formSubmissionEditPath(
                formKey: String,
                submissionId: String
            ) -> String {
                try! formSubmissionEdit.path(
                    parameters: [
                        "formKey": formKey,
                        "submissionId": submissionId,
                    ]
                )
            }

            func formSubmissionRemoveSelectedPath(
                _ formKey: String
            ) -> String {
                formSubmissionRemoveSelected.path(
                    parameter: "formKey",
                    value: formKey
                )
            }

            func formSubmissionsBreadcrumb(
                _: String
            ) -> [AdminBreadcrumb.Link] {
                formRoutes.formBreadcrumb
            }
        }
    }
}
