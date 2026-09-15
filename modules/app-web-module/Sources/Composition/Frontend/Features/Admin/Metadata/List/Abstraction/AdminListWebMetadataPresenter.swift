import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListWebMetadataPresenter: Sendable {

    func renderListPage(
        model: AdminListWebMetadataModel,
        permissions: Set<String>,
        search: String?,
        referenceType: String?,
        error: String?
    ) async throws -> HTMLResponse
}
