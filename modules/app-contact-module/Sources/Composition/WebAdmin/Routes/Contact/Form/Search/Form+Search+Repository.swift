import ContactApplication
import ContactModule

extension Form.Search {
    enum Repository {}
}

extension Form.Search.Repository {
    protocol Interface: Sendable {
        func search(
            page: Int,
            search: String
        ) async throws -> Form.Search.Model.Result
    }
}
