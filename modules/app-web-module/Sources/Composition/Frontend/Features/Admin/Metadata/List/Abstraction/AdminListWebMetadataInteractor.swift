import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListWebMetadataInteractor: Sendable {

    func listMetadataEntries(
        page: Int,
        search: String?,
        referenceType: String?
    ) async throws -> AdminListWebMetadataModel
}
