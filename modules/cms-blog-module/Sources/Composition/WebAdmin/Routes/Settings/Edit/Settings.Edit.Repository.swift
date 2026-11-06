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

extension Settings.Edit {
    enum Repository {}
}

extension Settings.Edit.Repository {
    protocol Interface: Sendable {
        func loadSettings() async throws -> Settings.Edit.Model
        func saveSettings(
            input: Settings.Edit.Form.Input
        ) async throws
    }
}
