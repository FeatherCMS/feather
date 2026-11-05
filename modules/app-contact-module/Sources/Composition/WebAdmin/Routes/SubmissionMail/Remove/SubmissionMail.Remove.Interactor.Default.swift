import ContactApplication
import ContactModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension SubmissionMail.Remove.Interactor {
    struct Default: Interface {
        let repository: any SubmissionMail.Remove.Repository.Interface

        func get(id: String) async throws -> ContactModule.Form.Details.Item {
            try await repository.get(id: id)
        }

        func remove(id: String, emailIds: [String]) async throws {
            let current = try await repository.get(id: id)
            let selected = Set(emailIds)
            let remaining = current.mails.filter { !selected.contains($0.id) }
            guard remaining.count != current.mails.count else {
                throw OpenAPIRepositoryError.notFound
            }
            _ = try await repository.update(
                id: id,
                name: current.name,
                successMessage: current.successMessage,
                failureMessage: current.failureMessage,
                redirectUrl: current.redirectUrl,
                fieldIDs: current.selectedFieldIDs,
                mails: remaining
            )
        }
    }
}
