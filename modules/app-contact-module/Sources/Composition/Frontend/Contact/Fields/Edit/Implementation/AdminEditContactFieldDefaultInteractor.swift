import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminEditContactFieldDefaultInteractor:
    AdminEditContactFieldInteractor
{
    let repository: AdminEditContactFieldOpenAPIRepository
    func get(id: String) async throws -> AdminContactFieldRow {
        try await repository.get(id: id)
    }
    func update(id: String, form: ContactFieldFormInput) async throws {
        try await repository.update(id: id, form: form)
    }
}
