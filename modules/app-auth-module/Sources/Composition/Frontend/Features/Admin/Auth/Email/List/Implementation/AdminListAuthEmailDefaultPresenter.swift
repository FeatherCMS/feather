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

struct AdminListAuthEmailDefaultPresenter:
    AdminListAuthEmailPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderPage(
        state: AuthEmailTable.State
    ) async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage user emails",
            content: AuthEmailTable(state: state)
        )
    }

    func renderError(
        error: OpenAPIRepositoryError
    ) async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage user emails",
            content: AuthEmailError(
                state: .init(
                    info: error.errorTitle,
                    message: error.errorDescription,
                    breadcrumb: breadcrumb()
                )
            )
        )
    }

    func renderRemovePage(
        items: [NewAdminRemoveItemContext],
        page: Int,
        search: String?,
        userID: String?
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove selected emails",
            content: NewAdminRemoveConfirmation(
                breadcrumb: breadcrumb(),
                pageHeader: .init(
                    title: "Remove selected emails",
                    description:
                        "Review the selected email addresses before removal."
                ),
                selectedItems: items.map(\.label),
                action: "/admin/auth/emails/remove/",
                cancel: listLocation(
                    page: page,
                    search: search,
                    userID: userID
                ),
                nonceToken: nonceToken,
                hiddenFields: [
                    .init(name: "page", value: "\(page)"),
                    .init(name: "search", value: search ?? ""),
                    .init(name: "userId", value: userID ?? ""),
                ]
                    + items.map {
                        .init(name: "ids", value: $0.id)
                    }
            )
        )
    }

    func renderInvalidNoncePage() async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove selected emails",
            content: NewAdminStatusView(
                state: .init(
                    title: "Form expired",
                    message:
                        "This form is no longer valid. Please reload the page."
                ),
                icon: FeatherIcons.alertCircle()
            )
        )
    }

    private func breadcrumb() -> [NewAdminBreadcrumb.Link] {
        [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Auth", link: "/admin/auth/"),
        ]
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
