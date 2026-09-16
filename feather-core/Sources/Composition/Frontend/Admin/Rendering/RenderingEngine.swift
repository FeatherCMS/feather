import HTML
import Hummingbird
import WebBuilders
import WebComponents

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
