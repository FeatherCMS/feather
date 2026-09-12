import HTML
import Hummingbird
import WebBuilders
import WebComponents

public protocol RenderingEngine: Sendable {

    func renderPage<T: FlowContent>(
        request: Request,
        title: String,
        description: String,
        imagePath: String,
        content: T
    ) -> HTMLResponse

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

    func adminSidebarState(
        request: Request,
        permissions: Set<String>
    ) -> AdminSidebar.State
}
