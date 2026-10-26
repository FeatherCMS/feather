import NewsApplication
import NewsModule

extension Article.Add {
    enum Interactor {}
}

extension Article.Add.Interactor {
    protocol Interface: Sendable {
        func categories() async throws -> [Article.Form.CategoryOption]
        func create(input: Article.Form.Input) async throws
    }
}
