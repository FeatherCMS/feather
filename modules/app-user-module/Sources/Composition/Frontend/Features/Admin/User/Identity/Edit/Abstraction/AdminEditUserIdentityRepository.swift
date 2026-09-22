protocol AdminEditUserIdentityRepository: Sendable {

    func load(
        id: String
    ) async throws -> AdminEditUserIdentityModel

    func update(
        id: String,
        payload: UserIdentityEditFormPayloadModel
    ) async throws
}
