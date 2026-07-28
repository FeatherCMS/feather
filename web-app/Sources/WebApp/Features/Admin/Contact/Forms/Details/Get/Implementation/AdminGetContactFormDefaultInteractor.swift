struct AdminGetContactFormDefaultInteractor: AdminGetContactFormInteractor {
    let repository: AdminGetContactFormOpenAPIRepository

    func get(id: String) async throws -> AdminContactFormDetailsItem {
        try await repository.get(id: id)
    }
}
