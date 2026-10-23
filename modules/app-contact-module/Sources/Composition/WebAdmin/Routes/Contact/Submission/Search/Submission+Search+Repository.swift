import ContactModule

extension Submission.Search {
    enum Repository {}
}

extension Submission.Search.Repository {
    protocol Interface: Sendable {
        func search(page: Int, search: String?) async throws
            -> Submission.Search.Model
    }
}
