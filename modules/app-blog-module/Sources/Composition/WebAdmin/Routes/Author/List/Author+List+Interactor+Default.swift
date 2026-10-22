import BlogModule

extension Author.List.Interactor {
    struct Default: Interface {
        let repository: any Author.List.Repository.Interface

        func list(page: Int, search: String?) async throws -> Author.List.Model
        {
            try await repository.list(page: page, search: search)
        }
    }
}
