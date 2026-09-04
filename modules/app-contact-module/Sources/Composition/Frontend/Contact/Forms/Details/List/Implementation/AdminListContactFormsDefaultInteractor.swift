import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminListContactFormsDefaultInteractor: AdminListContactFormsInteractor {
    let repository: AdminListContactFormsOpenAPIRepository

    func list() async throws -> [AdminContactFormDetailsItem] {
        try await repository.list()
    }
}
