import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListContactFormsDefaultInteractor: AdminListContactFormsInteractor {
    let repository: AdminListContactFormsOpenAPIRepository

    func list() async throws -> [AdminContactFormDetailsItem] {
        try await repository.list()
    }
}
