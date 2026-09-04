import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminListContactFormEmailsDefaultInteractor:
    AdminListContactFormEmailsInteractor
{
    let repository: AdminListContactFormEmailsOpenAPIRepository
    func get(id: String) async throws -> AdminContactFormDetailsItem {
        try await repository.get(id: id)
    }
}
