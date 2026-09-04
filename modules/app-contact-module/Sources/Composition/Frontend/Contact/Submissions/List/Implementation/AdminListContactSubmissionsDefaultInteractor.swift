import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminListContactSubmissionsDefaultInteractor:
    AdminListContactSubmissionsInteractor
{
    let repository: AdminListContactSubmissionsOpenAPIRepository
    func list() async throws -> [AdminContactSubmissionDirectoryItem] {
        try await repository.list()
    }
}
