import ContactApplication
import ContactModule

extension Submission.Detail.Interactor {
    struct Default: Interface {
        let repository: any Submission.Detail.Repository.Interface

        func get(formId: String, id: String) async throws
            -> Submission.Item
        {
            try await repository.get(formId: formId, id: id)
        }
    }
}
