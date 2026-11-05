import ContactApplication
import ContactModule

extension Submission.Edit {
    enum Repository {}
}

extension Submission.Edit.Repository {
    protocol Interface: Sendable {
        func update(formId: String, id: String, status: String) async throws
    }
}
