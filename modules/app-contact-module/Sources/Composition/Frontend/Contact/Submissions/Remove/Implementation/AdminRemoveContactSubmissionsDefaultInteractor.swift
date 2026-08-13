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
    func bulkRemove(ids: [String]) async throws {
        try await repository.bulkRemove(ids: ids)
    }
}
