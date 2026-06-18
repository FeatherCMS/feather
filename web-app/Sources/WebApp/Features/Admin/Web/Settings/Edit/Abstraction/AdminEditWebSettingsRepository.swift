protocol AdminEditWebSettingsRepository: Sendable {
    func loadSettings() async throws -> AdminEditWebSettingsModel
    func saveSettings(
        input: AdminEditWebSettingsFormInput
    ) async throws
}
