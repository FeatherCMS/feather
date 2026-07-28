protocol AdminListContactFormsInteractor: Sendable {
    func list() async throws -> [AdminContactFormDetailsItem]
}
