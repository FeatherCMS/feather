import FeatherAdmin

protocol AdminAddUserRoleRepository: Sendable {

    func create(
        payload: UserRoleAddFormPayloadModel
    ) async throws
}
