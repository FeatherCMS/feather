import AuthModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime

protocol AdminListAuthSessionPresenter: Sendable {
    func render(
        model: AdminListAuthSessionModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderError(
        error: OpenAPIRepositoryError,
        identityID: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
