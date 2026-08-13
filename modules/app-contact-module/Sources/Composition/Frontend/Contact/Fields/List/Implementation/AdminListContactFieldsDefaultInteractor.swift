import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminListContactFieldsDefaultInteractor:
    AdminListContactFieldsInteractor
{
    let repository: AdminListContactFieldsOpenAPIRepository
    func list() async throws -> [AdminContactFieldRow] {
        try await repository.list()
    }
}
