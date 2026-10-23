import ContactModule

extension Submission.Remove {
    enum Interactor {}
}

extension Submission.Remove.Interactor {
    protocol Interface: Sendable {
        func remove(ids: [String]) async throws
    }
}
