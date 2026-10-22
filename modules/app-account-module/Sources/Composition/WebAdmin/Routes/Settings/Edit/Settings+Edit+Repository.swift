import AccountModule

extension Settings.Edit.Repository {

    protocol Interface: Sendable {

        func loadSettings() async throws -> Settings.Edit.Model

        func saveSettings(
            input: Settings.Edit.Form.Input
        ) async throws
    }
}
