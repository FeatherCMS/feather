import BlogModule

extension Post.Remove.Interactor {
    struct Default: Interface {
        let repository: any Post.Remove.Repository.Interface

        func delete(ids: [String]) async throws {
            try await repository.delete(ids: ids)
        }
    }
}
