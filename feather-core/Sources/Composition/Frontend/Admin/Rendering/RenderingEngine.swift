import HTML
import Hummingbird
import WebComponents
import WebBuilders

public protocol RenderingEngine: Sendable {

    func renderPage<T: FlowContent>(
        request: Request,
        title: String,
        description: String,
        imagePath: String,
        content: T
    ) -> HTMLResponse

    func renderAdminPage<T: Leaf>(
        request: Request,
        title: String,
        description: String,
        imagePath: String,
        sidebarState: AdminSidebar.State,
        content: T
    ) -> HTMLResponse

    func adminSidebarState(
        request: Request,
        permissions: Set<String>
    ) -> AdminSidebar.State
}
