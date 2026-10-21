import AuthAdminAPI
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

struct AdminListAuthEmailDefaultPresenter:
    AdminListAuthEmailPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderEngine: any RenderingEngine

    func renderPage(
        state: AuthEmailTable.State
    ) async throws -> HTMLResponse {
        try await renderEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Manage user emails",
            content: AuthEmailTable(state: state)
        )
    }

    func renderError(
        error: OpenAPIRepositoryError
    ) async throws -> HTMLResponse {
        try await renderEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Manage user emails",
            content: AuthEmailError(
                state: .init(
                    info: error.errorTitle,
                    message: error.errorDescription,
                    breadcrumb: AuthEmailRoutes.listBreadcrumb
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
        var components = URLComponents(string: "/admin/auth/emails/")!
        components.queryItems = [
            .init(name: "page", value: "\(page)"),
            .init(name: "search", value: search),
            .init(name: "userId", value: userID),
        ]
        .compactMap { $0.value == nil || $0.value!.isEmpty ? nil : $0 }
        return components.string ?? "/admin/auth/emails/"
    }
}
