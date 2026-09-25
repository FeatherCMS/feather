import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveContactFormDefaultInteractor: AdminRemoveContactFormInteractor
{
    let repository: AdminRemoveContactFormOpenAPIRepository

    func get(key: String) async throws -> AdminContactFormDetailsItem {
        try await repository.get(key: key)
    }
    func remove(keys: [String]) async throws {
        try await repository.remove(keys: keys)
    }
}
