import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveContactSubmissionsDefaultInteractor:
    AdminRemoveContactSubmissionsInteractor
{
    let repository: AdminRemoveContactSubmissionsOpenAPIRepository
    func remove(ids: [String]) async throws {
        try await repository.remove(ids: ids)
    }
}
