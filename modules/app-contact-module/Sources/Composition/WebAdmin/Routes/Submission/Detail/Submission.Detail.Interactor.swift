import ContactApplication
import ContactModule

extension Submission.Detail {
    enum Interactor {}
}

extension Submission.Detail.Interactor {
    protocol Interface: Sendable {
        func get(formId: String, id: String) async throws
            -> Submission.Item
    }
}
