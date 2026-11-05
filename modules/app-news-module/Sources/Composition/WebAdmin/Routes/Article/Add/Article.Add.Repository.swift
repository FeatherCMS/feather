import NewsApplication
import NewsModule

extension Article.Add {
    enum Repository {}
}

extension Article.Add.Repository {
    protocol Interface: Sendable {
        func categories() async throws -> [Article.Form.CategoryOption]
        func create(input: Article.Form.Input) async throws
    }
}
