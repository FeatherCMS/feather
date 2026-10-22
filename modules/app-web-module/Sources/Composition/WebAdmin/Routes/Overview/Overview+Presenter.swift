import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Overview {
    enum Presenter {
        protocol Interface: Sendable {
            func renderOverview(
                model: Model,
                permissions: Set<String>
            ) async throws -> HTMLResponse
        }
    }
}
