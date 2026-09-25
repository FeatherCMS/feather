import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewContactFormDefaultInteractor: AdminViewContactFormInteractor {
    let repository: AdminViewContactFormOpenAPIRepository

    func get(key: String) async throws -> AdminContactFormDetailsItem {
        try await repository.get(key: key)
    }
}
