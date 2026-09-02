import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveContactFieldDefaultInteractor:
    AdminRemoveContactFieldInteractor
{
    let repository: AdminRemoveContactFieldOpenAPIRepository
    func get(id: String) async throws -> AdminContactFieldRow {
        try await repository.get(id: id)
    }
    func remove(id: String) async throws {
        try await repository.remove(id: id)
    }
    func remove(ids: [String]) async throws {
        try await repository.remove(ids: ids)
    }
}
