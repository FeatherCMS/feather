import ContactModule

extension Submission.Remove {
    enum Repository {}
}

extension Submission.Remove.Repository {
    protocol Interface: Sendable {
        func remove(ids: [String]) async throws
    }
}
