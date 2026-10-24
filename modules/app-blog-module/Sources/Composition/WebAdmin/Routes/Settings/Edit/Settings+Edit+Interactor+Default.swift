import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Settings.Edit.Interactor {
    struct Default: Interface {
        let repository: any Settings.Edit.Repository.Interface

        func loadSettings() async throws -> Settings.Edit.Model {
            try await repository.loadSettings()
        }

        func saveSettings(
            input: Settings.Edit.Form.Input
        ) async throws {
            try await repository.saveSettings(input: input)
        }
    }
}
