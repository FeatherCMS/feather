import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebBuilders
import WebComponents

struct AdminViewAuthEmailDefaultPresenter: AdminViewAuthEmailPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func breadcrumb(
        id: String
    ) -> [NewAdminBreadcrumb.Link] {
        [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Auth", link: "/admin/auth/"),
            .init(label: "Emails", link: "/admin/auth/emails/"),
        ]
    }

    func renderPage(
        link: AuthEmailDetailsModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "User email details",
            content: AuthEmailDetails(
                state: .init(
                    link: link,
                    permissions: permissions,
                    breadcrumb: breadcrumb(id: link.id)
                )
            )
        )
    }

    func renderError(
        id: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "User email details",
            content: AuthEmailError(
                state: .init(
                    info: error.errorTitle,
                    message: error.errorDescription,
                    breadcrumb: breadcrumb(id: id)
                )
            )
        )
    }
}
