import FeatherAdmin
import Hummingbird
import SystemAdminAPI
import WebComponents

struct AdminAddSystemVariableDefaultPresenter:
    AdminAddSystemVariablePresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderAddPage(
        state: SystemVariableAddForm.State
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderPage(
            content: SystemVariableAddPage(
                form: SystemVariableAddForm(
                    state: state,
                    action: SystemVariableRoutes.add.description,
                    nonceToken: nonceToken
                )
            )
        )
    }

    private func renderPage<T: Component>(content: T) async throws
        -> HTMLResponse
    {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage system variables",
            content: content
        )
    }

}
