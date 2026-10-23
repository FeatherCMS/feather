import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension Settings.Edit {
    enum Repository {}
}

extension Settings.Edit.Repository {
    protocol Interface: Sendable {
        func loadSettings() async throws -> Settings.Edit.Model

        func saveSettings(
            input: Settings.Edit.FormInput
        ) async throws
    }
}
