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

    /// Synchronous bridge for feature presenters that already receive the
    /// current permission set. This keeps their controller contracts stable
    /// while rendering them with the new admin shell.
    func renderNewAdminPage<T: Component>(
        request: Request,
        title: String,
        permissions: Set<String>,
        content: T
    ) -> HTMLResponse

    func adminSidebarState(
        request: Request,
        permissions: Set<String>
    ) -> AdminSidebar.State
}
