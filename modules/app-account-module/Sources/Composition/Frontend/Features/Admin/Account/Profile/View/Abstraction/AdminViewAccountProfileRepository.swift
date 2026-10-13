protocol AdminViewAccountProfileRepository: Sendable {
    func get() async throws -> AdminAccountProfileModel
}
