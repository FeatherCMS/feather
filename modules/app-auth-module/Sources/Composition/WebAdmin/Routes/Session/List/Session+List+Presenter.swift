import AuthModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime

extension Session.List.Presenter {
    protocol Interface: Sendable {
        func render(
            model: Session.List.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderError(
            error: OpenAPIRepositoryError,
            identityID: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
