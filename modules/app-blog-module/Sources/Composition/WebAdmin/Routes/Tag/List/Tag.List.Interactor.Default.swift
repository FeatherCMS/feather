import BlogModule

extension Tag.List.Interactor {
    struct Default: Interface {
        let repository: any Tag.List.Repository.Interface

        func execute(page: Int, search: String?) async throws -> Tag.List.Model
        {
            try await repository.search(page: page, search: search)
        }
    }
}
