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

struct AdminEditBlogSettingsDefaultInteractor:
    AdminEditBlogSettingsInteractor
{
    let repository: any AdminEditBlogSettingsRepository

    func loadSettings() async throws -> AdminEditBlogSettingsModel {
        try await repository.loadSettings()
    }

    func saveSettings(
        input: AdminEditBlogSettingsFormInput
    ) async throws {
        try await repository.saveSettings(input: input)
    }
}
