import ContactApplication
import ContactModule
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension SubmissionMail.Add.Interactor {
    struct Default: Interface {
        let repository: any SubmissionMail.Add.Repository.Interface

        func get(id: String) async throws -> ContactForm.Details.Item {
            try await repository.get(id: id)
        }

        func add(id: String, email: ContactForm.Email) async throws {
            let current = try await repository.get(id: id)
            _ = try await repository.update(
                id: id,
                name: current.name,
                successMessage: current.successMessage,
                failureMessage: current.failureMessage,
                redirectUrl: current.redirectUrl,
                fieldIDs: current.selectedFieldIDs,
                mails: current.mails + [email]
            )
        }
    }
}
