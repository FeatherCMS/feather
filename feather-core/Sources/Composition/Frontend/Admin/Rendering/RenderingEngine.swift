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

    @available(*, deprecated, message: "Use the application-specific page rendering infrastructure instead.")
    func renderPage<T: FlowContent>(
        request: Request,
        title: String,
        description: String,
        imagePath: String,
        content: T
    ) -> HTMLResponse

    @available(*, deprecated, message: "Use renderNewAdminPage(request:context:title:content:) instead.")
    func renderAdminPage<T: Component>(
        request: Request,
        title: String,
        description: String,
        imagePath: String,
        sidebarState: AdminSidebar.State,
        content: T
    ) -> HTMLResponse

    func renderNewAdminPage<T: Component>(
        request: Request,
        context: DefaultRequestContext,
        title: String,
        content: T
    ) async throws -> HTMLResponse

    @available(*, deprecated, message: "Use the new admin sidebar infrastructure instead.")
    func adminSidebarState(
        request: Request,
        permissions: Set<String>
    ) -> AdminSidebar.State
}
