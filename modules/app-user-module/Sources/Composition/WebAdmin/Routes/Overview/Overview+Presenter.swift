import FeatherWebAdmin
import Hummingbird

extension Overview {
    enum Presenter {}
}

extension Overview.Presenter {
    protocol Interface: Sendable {
        func renderPage(model: Overview.Model) async throws
            -> HTMLResponse
    }
}
