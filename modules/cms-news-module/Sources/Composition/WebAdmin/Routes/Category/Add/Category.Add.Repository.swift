import NewsApplication
import NewsModule

extension Category.Add {
    enum Repository {}
}

extension Category.Add.Repository {
    protocol Interface: Sendable {
        func create(input: Category.Form.Input) async throws
    }
}
