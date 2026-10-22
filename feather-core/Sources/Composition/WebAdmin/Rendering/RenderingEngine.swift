public import HTML
public import Hummingbird
import WebBuilders
public import WebComponents

public protocol RenderingEngine: Sendable {
    func renderAdminPage<T: Component>(
        request: Request,
        context: AuthenticatedRequestContext,
        title: String,
        content: T
    ) async throws -> HTMLResponse

    func renderAdminDialog<T: Component>(
        request: Request,
        context: AuthenticatedRequestContext,
        title: String,
        content: T,
        size: AdminDialogSize
    ) async throws -> HTMLResponse

    func renderAdminStandalonePage<T: Component>(
        title: String,
        content: T
    ) -> HTMLResponse where T.HTML: FlowContent
}
