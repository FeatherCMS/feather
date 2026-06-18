struct AdminEditWebSettingsDefaultInteractor:
    AdminEditWebSettingsInteractor
{
    let repository: any AdminEditWebSettingsRepository

    func loadSettings() async throws -> AdminEditWebSettingsModel {
        try await repository.loadSettings()
    }

    func saveSettings(
        input: AdminEditWebSettingsFormInput
    ) async throws {
        try await repository.saveSettings(input: input)
    }
}
