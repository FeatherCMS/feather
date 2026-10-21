public import HTML
public import Hummingbird
import WebBuilders
public import WebComponents

public protocol RenderingEngine: Sendable {

    func renderPublicPage<T: FlowContent>(
        request: Request,
        title: String,
        description: String,
        imagePath: String,
        content: T
    ) -> HTMLResponse

    func renderPublicPage<T: Component>(
        request: Request,
        title: String,
        description: String,
        imagePath: String,
        content: T
    ) -> HTMLResponse where T.HTML: FlowContent

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
}
