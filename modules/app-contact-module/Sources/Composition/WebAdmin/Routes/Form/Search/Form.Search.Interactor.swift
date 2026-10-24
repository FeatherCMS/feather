import ContactApplication
import ContactModule

extension Form.Search {
    enum Interactor {}
}

extension Form.Search.Interactor {
    protocol Interface: Sendable {
        func search(
            page: Int,
            search: String
        ) async throws -> Form.Search.Model.Result
    }
}
