import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminListContactFieldsDefaultInteractor:
    AdminListContactFieldsInteractor
{
    let repository: AdminListContactFieldsOpenAPIRepository
    func list() async throws -> [AdminContactFieldRow] {
        try await repository.list()
    }
}
