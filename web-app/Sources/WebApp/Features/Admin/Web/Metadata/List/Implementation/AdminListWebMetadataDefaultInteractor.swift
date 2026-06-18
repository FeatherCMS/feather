import Hummingbird

struct AdminListWebMetadataDefaultInteractor:
    AdminListWebMetadataInteractor
{
    let repository: any AdminListWebMetadataRepository

    func listMetadataEntries(
        page: Int,
        search: String?
    ) async throws -> AdminListWebMetadataModel {
        try await repository.listMetadataEntries(page: page, search: search)
    }
}
