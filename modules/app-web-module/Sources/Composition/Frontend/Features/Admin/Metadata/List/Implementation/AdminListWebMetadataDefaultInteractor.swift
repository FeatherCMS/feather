import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminListWebMetadataDefaultInteractor:
    AdminListWebMetadataInteractor
{
    let repository: any AdminListWebMetadataRepository

    func listMetadataEntries(
        page: Int,
        search: String?,
        referenceType: String?
    ) async throws -> AdminListWebMetadataModel {
        try await repository.listMetadataEntries(
            page: page,
            search: search,
            referenceType: referenceType
        )
    }
}
