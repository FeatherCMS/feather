import FeatherAdmin

protocol AdminEditSettingsRepository: Sendable {

    func loadSettings() async throws -> AdminEditSettingsModel

    func saveSettings(
        input: AdminEditSettingsFormInput
    ) async throws
}
