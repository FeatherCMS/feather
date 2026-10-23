import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension Settings.Edit {
    enum Interactor {}
}

extension Settings.Edit.Interactor {
    protocol Interface: Sendable {
        func loadSettings() async throws -> Settings.Edit.Model

        func saveSettings(
            input: Settings.Edit.FormInput
        ) async throws
    }
}
