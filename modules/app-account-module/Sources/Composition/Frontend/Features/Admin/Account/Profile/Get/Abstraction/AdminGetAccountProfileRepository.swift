protocol AdminGetAccountProfileRepository: Sendable {
    func get() async throws -> AdminAccountProfileModel
}
