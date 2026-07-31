struct AdminEditAccountSettingsDefaultInteractor:
    AdminEditAccountSettingsInteractor
{

    let repository: any AdminEditAccountSettingsRepository

    func loadSettings() async throws -> AdminEditAccountSettingsModel {
        try await repository.loadSettings()
    }

    func saveSettings(
        input: AdminEditAccountSettingsFormInput
    ) async throws {
        try await repository.saveSettings(input: input)
    }
}
