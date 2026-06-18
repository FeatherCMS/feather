import Hummingbird

protocol AdminListWebMetadataInteractor: Sendable {

    func listMetadataEntries(
        page: Int,
        search: String?
    ) async throws -> AdminListWebMetadataModel
}
