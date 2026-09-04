import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminAddContactFormEmailDefaultInteractor:
    AdminAddContactFormEmailInteractor
{
    let repository: AdminAddContactFormEmailOpenAPIRepository

    func get(id: String) async throws -> AdminContactFormDetailsItem {
        try await repository.get(id: id)
    }

    func add(id: String, email: AdminContactFormEmail) async throws {
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
