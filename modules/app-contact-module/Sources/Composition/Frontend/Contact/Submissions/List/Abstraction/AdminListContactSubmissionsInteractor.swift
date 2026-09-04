import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminListContactSubmissionsInteractor: Sendable {
    func list() async throws -> [AdminContactSubmissionDirectoryItem]
}
