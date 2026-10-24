import BlogModule

extension Tag.Remove.Interactor {
    struct Default: Interface {
        let repository: any Tag.Remove.Repository.Interface

        func delete(ids: [String]) async throws {
            try await repository.delete(ids: ids)
        }
    }
}
