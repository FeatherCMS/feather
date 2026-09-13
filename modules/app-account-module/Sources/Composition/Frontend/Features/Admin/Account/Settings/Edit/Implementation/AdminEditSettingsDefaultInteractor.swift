import FeatherAdmin

struct AdminEditSettingsDefaultInteractor:
    AdminEditSettingsInteractor
{

    let repository: any AdminEditSettingsRepository

    func loadSettings() async throws -> AdminEditSettingsModel {
        try await repository.loadSettings()
    }

    func saveSettings(
        input: AdminEditSettingsFormInput
    ) async throws {
        try await repository.saveSettings(input: input)
    }
}
