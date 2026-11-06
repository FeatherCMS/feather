import NewsApplication
import NewsModule

extension Category.Add {
    enum Interactor {}
}

extension Category.Add.Interactor {
    protocol Interface: Sendable {
        func create(input: Category.Form.Input) async throws
    }
}
