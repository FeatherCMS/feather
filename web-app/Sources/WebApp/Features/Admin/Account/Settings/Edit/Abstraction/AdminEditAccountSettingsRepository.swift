protocol AdminEditAccountSettingsRepository: Sendable {

    func loadSettings() async throws -> AdminEditAccountSettingsModel

    func saveSettings(
        input: AdminEditAccountSettingsFormInput
    ) async throws
}
