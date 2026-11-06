import BlogModule

extension Author.Edit.Interactor {
    struct Default: Interface {
        let repository: any Author.Edit.Repository.Interface

        func load(id: String) async throws -> Author.View.Model {
            try await repository.load(id: id)
        }

        func update(id: String, input: Author.Form.Input) async throws {
            try await repository.update(id: id, input: input)
        }
    }
}
