import Hummingbird

protocol AdminListWebMetadataRepository: Sendable {

    func listMetadataEntries(
        page: Int,
        search: String?
    ) async throws -> AdminListWebMetadataModel
}
