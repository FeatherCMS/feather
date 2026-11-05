import BlogModule

extension Author.Remove.Interactor {
    struct Default: Interface {
        let repository: any Author.Remove.Repository.Interface

        func delete(ids: [String]) async throws {
            try await repository.delete(ids: ids)
        }
    }
}
