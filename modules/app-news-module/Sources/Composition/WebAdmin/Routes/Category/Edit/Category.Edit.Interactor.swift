import NewsApplication
import NewsModule

extension Category.Edit {
    enum Interactor {}
}

extension Category.Edit.Interactor {
    protocol Interface: Sendable {
        func get(
            id: String
        ) async throws -> Category.Detail.Model
        func update(
            id: String,
            input: Category.Form.Input
        ) async throws
    }
}
