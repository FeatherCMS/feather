import ContactApplication
import ContactModule

extension Submission.Search {
    enum Interactor {}
}

extension Submission.Search.Interactor {
    protocol Interface: Sendable {
        func search(page: Int, search: String?) async throws
            -> Submission.Search.Model
    }
}
