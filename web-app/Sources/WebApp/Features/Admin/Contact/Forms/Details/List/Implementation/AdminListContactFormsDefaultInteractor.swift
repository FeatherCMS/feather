struct AdminListContactFormsDefaultInteractor: AdminListContactFormsInteractor {
    let repository: AdminListContactFormsOpenAPIRepository

    func list() async throws -> [AdminContactFormDetailsItem] {
        try await repository.list()
    }
}
