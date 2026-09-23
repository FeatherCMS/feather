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

    func renderNewAdminPage<T: Component>(
        request: Request,
        context: DefaultRequestContext,
        title: String,
        content: T
    ) async throws -> HTMLResponse
}
