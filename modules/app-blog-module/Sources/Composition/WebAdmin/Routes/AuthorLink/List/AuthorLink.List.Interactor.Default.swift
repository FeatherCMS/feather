import BlogModule

extension AuthorLink.List.Interactor {
    struct Default: Interface {
        let repository: any AuthorLink.List.Repository.Interface

        func list(
            authorID: String,
            page: Int,
            search: String?
        ) async throws -> AuthorLink.List.Model {
            try await repository.search(
                authorID: authorID,
                page: page,
                search: search
            )
        }
    }
}
