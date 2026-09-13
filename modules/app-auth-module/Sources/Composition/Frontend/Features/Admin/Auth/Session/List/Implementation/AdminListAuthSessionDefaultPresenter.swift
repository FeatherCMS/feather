import AuthContracts
import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AdminListAuthSessionDefaultPresenter: AdminListAuthSessionPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func render(
        model: AdminListAuthSessionModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Sessions",
            content: AdminListAuthSessionView(
                state: .init(
                    identityID: model.identityID,
                    items: model.items,
                    canRemove: permissions.contains(
                        AuthPermissions.Sessions.delete.rawValue
                    )
                )
            )
        )
    }

    func renderError(
        error: OpenAPIRepositoryError,
        identityID: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: error.errorTitle,
            content: NewAdminStatusView(
                state: .init(
                    title: error.errorTitle,
                    message: error.errorDescription
                ),
                icon: FeatherIcons.alertCircle()
            )
        )
    }
}
