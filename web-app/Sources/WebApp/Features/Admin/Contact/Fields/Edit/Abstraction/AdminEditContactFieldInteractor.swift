protocol AdminEditContactFieldInteractor: Sendable {
    func get(id: String) async throws -> AdminContactFieldRow
    func update(id: String, form: ContactFieldFormInput)
        async throws
}
