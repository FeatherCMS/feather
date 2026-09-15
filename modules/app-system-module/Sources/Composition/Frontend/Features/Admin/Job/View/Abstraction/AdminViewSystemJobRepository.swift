protocol AdminViewSystemJobRepository: Sendable {
    func get(id: String) async throws -> SystemJobDetailsModel
}
