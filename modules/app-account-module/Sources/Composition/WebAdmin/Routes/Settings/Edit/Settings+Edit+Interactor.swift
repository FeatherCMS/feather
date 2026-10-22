import AccountModule

extension Settings.Edit.Interactor {

    protocol Interface: Sendable {

        func loadSettings() async throws -> Settings.Edit.Model

        func saveSettings(
            input: Settings.Edit.Form.Input
        ) async throws
    }
}
