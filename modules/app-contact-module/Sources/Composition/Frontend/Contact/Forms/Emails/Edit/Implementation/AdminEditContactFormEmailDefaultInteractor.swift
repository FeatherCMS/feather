import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminEditContactFormEmailDefaultInteractor:
    AdminEditContactFormEmailInteractor
{
    let repository: AdminEditContactFormEmailOpenAPIRepository

    func get(id: String) async throws -> AdminContactFormDetailsItem {
        try await repository.get(id: id)
    }

    func update(id: String, email: AdminContactFormEmail) async throws {
        let current = try await repository.get(id: id)
        guard current.mails.contains(where: { $0.id == email.id }) else {
            throw OpenAPIRepositoryError.notFound(
                message: "This contact form email could not be found."
            )
        }
        _ = try await repository.update(
            id: id,
            name: current.name,
            successMessage: current.successMessage,
            failureMessage: current.failureMessage,
            redirectUrl: current.redirectUrl,
            fieldIDs: current.selectedFieldIDs,
            mails: current.mails.map { $0.id == email.id ? email : $0 }
        )
    }
}
