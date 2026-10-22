import FeatherWebAdmin
import Hummingbird

extension Overview.Presenter {
    protocol Interface: Sendable {
        func renderPage(model: Overview.Model) async throws
            -> HTMLResponse
    }
}
