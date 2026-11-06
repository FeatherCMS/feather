import NewsApplication
import NewsModule

extension Category.Edit.Interactor {
    struct Default: Interface {
        let repository: any Category.Edit.Repository.Interface

        func get(
            id: String
        ) async throws -> Category.Detail.Model {
            try await repository.get(id: id)
        }

        func update(
            id: String,
            input: Category.Form.Input
        ) async throws {
            try await repository.update(id: id, input: input)
        }
    }
}
