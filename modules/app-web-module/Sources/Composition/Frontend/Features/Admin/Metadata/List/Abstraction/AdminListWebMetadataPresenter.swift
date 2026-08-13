import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListWebMetadataPresenter: Sendable {

    func renderListPage(
        model: AdminListWebMetadataModel,
        isEdited: Bool,
        permissions: Set<String>,
        search: String?,
        referenceType: String?,
        error: String?
    ) -> HTMLResponse
}
