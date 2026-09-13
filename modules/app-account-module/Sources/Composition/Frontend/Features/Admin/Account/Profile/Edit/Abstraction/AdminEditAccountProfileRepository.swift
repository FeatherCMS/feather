protocol AdminEditAccountProfileRepository: Sendable {
    func get() async throws -> AdminAccountProfileModel

    func update(
        profile: AdminAccountProfileModel
    ) async throws
}
