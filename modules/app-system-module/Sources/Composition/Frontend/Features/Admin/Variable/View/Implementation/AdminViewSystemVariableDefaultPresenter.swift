import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import SystemContracts
import WebBuilders
import WebComponents

struct AdminViewSystemVariableDefaultPresenter: AdminViewSystemVariablePresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        variable: SystemVariableDetailsModel,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "System variable details",
            content: SystemVariableDetails(
                state: .init(
                    variable: variable,
                    permissions: permissions
                )
            )
        )
    }

    func renderErrorPage(
        error: AdminViewSystemVariableError
    ) async throws -> HTMLResponse {
        let state: NewAdminStatusView.State

        switch error {
        case .notFound:
            state = .init(
                title: "System variable not found",
                message: "This system variable may have been removed."
            )
        case .unauthorized:
            state = .init(
                title: "Session expired",
                message: "Please sign in again to view system variables."
            )
        case .forbidden:
            state = .init(
                title: "Forbidden",
                message: "Your account cannot access system variables."
            )
        case .unavailable:
            state = .init(
                title: "System variable unavailable",
                message: "The request could not be completed. Please try again."
            )
        }

        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "System variable details",
            content: NewAdminStatusView(
                state: state,
                icon: FeatherIcons.alertCircle()
            )
        )
        return HTMLResponse(content: page.content, status: status(for: error))
    }

    private func status(
        for error: AdminViewSystemVariableError
    ) -> HTTPResponse.Status {
        switch error {
        case .notFound:
            .notFound
        case .unauthorized:
            .unauthorized
        case .forbidden:
            .forbidden
        case .unavailable:
            .serviceUnavailable
        }
    }

}
