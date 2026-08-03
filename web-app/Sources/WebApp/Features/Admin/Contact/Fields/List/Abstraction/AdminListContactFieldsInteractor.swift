protocol AdminListContactFieldsInteractor: Sendable {
    func list() async throws -> [AdminContactFieldRow]
}
