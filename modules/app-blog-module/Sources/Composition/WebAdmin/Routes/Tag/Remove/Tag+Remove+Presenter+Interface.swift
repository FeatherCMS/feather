import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Tag.Remove.Presenter {
    protocol Interface: Sendable {
        func renderError(
            info: String,
            message: String
        ) async throws -> HTMLResponse
    }
}
