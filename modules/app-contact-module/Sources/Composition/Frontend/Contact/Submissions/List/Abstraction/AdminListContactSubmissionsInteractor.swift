import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminListContactSubmissionsInteractor: Sendable {
    func list() async throws -> [AdminContactSubmissionDirectoryItem]
}
