protocol AdminAuthAccountProfileRepository: Sendable {
    func get() async throws -> AdminAuthAccountProfileModel

    func update(
        profile: AdminAuthAccountProfileModel
    ) async throws
}
