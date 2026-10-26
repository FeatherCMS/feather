import ContactApplication
import ContactModule

extension Submission.Edit.Interactor {
    struct Default: Interface {
        let repository: any Submission.Edit.Repository.Interface

        func update(formId: String, id: String, status: String) async throws {
            try await repository.update(formId: formId, id: id, status: status)
        }
    }
}
