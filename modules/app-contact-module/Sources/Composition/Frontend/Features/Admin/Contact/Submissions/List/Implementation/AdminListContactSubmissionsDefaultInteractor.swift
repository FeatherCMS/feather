import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListContactSubmissionsDefaultInteractor:
    AdminListContactSubmissionsInteractor
{
    let repository: AdminListContactSubmissionsOpenAPIRepository
    func list() async throws -> [AdminContactSubmissionDirectoryItem] {
        try await repository.list()
    }
}
