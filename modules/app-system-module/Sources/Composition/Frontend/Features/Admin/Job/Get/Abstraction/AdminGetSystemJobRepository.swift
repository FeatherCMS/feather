protocol AdminGetSystemJobRepository: Sendable {
    func get(id: String) async throws -> SystemJobDetailsModel
}
