import ContactApplication
import ContactModule

extension Submission.Remove {
    enum Repository {}
}

extension Submission.Remove.Repository {
    protocol Interface: Sendable {
        func remove(ids: [String]) async throws
        func remove(formId: String, ids: [String]) async throws
    }
}
