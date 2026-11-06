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
    enum Interactor {}
}

extension Settings.Edit.Interactor {
    protocol Interface: Sendable {
        func loadSettings() async throws -> Settings.Edit.Model
        func saveSettings(
            input: Settings.Edit.Form.Input
        ) async throws
    }
}
