import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebFrontend
import WebStandards

protocol AdminEditBlogSettingsRepository: Sendable {
    func loadSettings() async throws -> AdminEditBlogSettingsModel
    func saveSettings(
        input: AdminEditBlogSettingsFormInput
    ) async throws
}
