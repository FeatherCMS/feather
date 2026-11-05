import ContactApplication
import ContactModule

extension Submission.Remove.Interactor {
    struct Default: Interface {
        let repository: any Submission.Remove.Repository.Interface

        func remove(ids: [String]) async throws {
            try await repository.remove(ids: ids)
        }

        func remove(formId: String, ids: [String]) async throws {
            try await repository.remove(formId: formId, ids: ids)
        }
    }
}
