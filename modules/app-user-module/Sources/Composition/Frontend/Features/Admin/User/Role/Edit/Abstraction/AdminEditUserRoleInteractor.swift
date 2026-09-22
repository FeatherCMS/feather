import FeatherAdmin

protocol AdminEditUserRoleInteractor: Sendable {

    func load(
        id: String
    ) async throws -> UserRoleDetailsModel

    func edit(
        id: String,
        input: AdminEditUserRoleFormInput
    ) async throws
}
