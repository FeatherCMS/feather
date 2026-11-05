import ContactApplication
import ContactModule

extension Submission.Edit {
    enum Interactor {}
}

extension Submission.Edit.Interactor {
    protocol Interface: Sendable {
        func update(formId: String, id: String, status: String) async throws
    }
}
