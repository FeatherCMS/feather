import AuthAdminAPI
import AuthModule
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

extension Email.List.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderEngine: any RenderingEngine
        let routes: Email.Router.Routes

        func renderPage(
            state: Email.List.Component.State
        ) async throws -> HTMLResponse {
            try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Manage user emails",
                content: Email.List.Component(state: state)
            )
        }

        func renderError(
            error: OpenAPIRepositoryError
        ) async throws -> HTMLResponse {
            try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Manage user emails",
                content: Email.List.Error(
                    state: .init(
                        info: error.errorTitle,
                        message: error.errorDescription,
                        breadcrumb: routes.listBreadcrumb
                    )
                )
            )
        }
        func renderInvalidNoncePage() async throws -> HTMLResponse {
            try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Remove selected emails",
                content: AdminStatusView(
                    state: .init(
                        title: "Form expired",
                        message:
                            "This form is no longer valid. Please reload the page."
                    ),
                    icon: FeatherIcons.alertCircle()
                )
            )
        }

        private func listLocation(page: Int, search: String?, userID: String?)
            -> String
        {
            var components = URLComponents(string: routes.list.path)!
            components.queryItems = [
                .init(name: "page", value: "\(page)"),
                .init(name: "search", value: search),
                .init(name: "userId", value: userID),
            ]
            .compactMap { $0.value == nil || $0.value!.isEmpty ? nil : $0 }
            return components.string ?? routes.list.path
        }
    }
}
