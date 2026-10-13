import FeatherAdmin

protocol AdminAddUserRoleInteractor: Sendable {

    func add(
        input: AdminAddUserRoleFormInput
    ) async throws
}
