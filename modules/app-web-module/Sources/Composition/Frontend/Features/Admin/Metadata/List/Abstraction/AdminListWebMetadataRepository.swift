import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListWebMetadataRepository: Sendable {

    func listMetadataEntries(
        page: Int,
        search: String?,
        referenceType: String?
    ) async throws -> AdminListWebMetadataModel
}
