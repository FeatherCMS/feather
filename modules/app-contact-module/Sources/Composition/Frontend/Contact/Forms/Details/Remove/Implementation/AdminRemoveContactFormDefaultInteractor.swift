import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveContactFormDefaultInteractor: AdminRemoveContactFormInteractor
{
    let repository: AdminRemoveContactFormOpenAPIRepository

    func get(id: String) async throws -> AdminContactFormDetailsItem {
        try await repository.get(id: id)
    }
    func remove(ids: [String]) async throws {
        try await repository.remove(ids: ids)
    }
}
