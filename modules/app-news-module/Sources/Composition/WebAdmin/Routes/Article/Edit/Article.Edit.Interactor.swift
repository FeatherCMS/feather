import NewsApplication
import NewsModule

extension Article.Edit {
    enum Interactor {}
}

extension Article.Edit.Interactor {
    protocol Interface: Sendable {
        func get(
            id: String
        ) async throws -> Article.Detail.Model
        func categories() async throws -> [Article.Form.CategoryOption]
        func update(
            id: String,
            input: Article.Form.Input
        ) async throws
    }
}
