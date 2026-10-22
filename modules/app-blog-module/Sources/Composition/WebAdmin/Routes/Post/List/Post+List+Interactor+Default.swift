import BlogModule

extension Post.List.Interactor {
    struct Default: Interface {
        let repository: any Post.List.Repository.Interface

        func list(page: Int, search: String?) async throws -> Post.List.Model {
            try await repository.list(page: page, search: search)
        }
    }
}
