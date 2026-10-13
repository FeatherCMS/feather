import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

protocol AdminEditBlogSettingsInteractor: Sendable {
    func loadSettings() async throws -> AdminEditBlogSettingsModel
    func saveSettings(
        input: AdminEditBlogSettingsFormInput
    ) async throws
}
