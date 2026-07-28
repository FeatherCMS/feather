import Foundation

protocol AdminEditAccountSettingsInteractor: Sendable {

    func loadSettings() async throws -> AdminEditAccountSettingsModel

    func saveSettings(
        input: AdminEditAccountSettingsFormInput
    ) async throws
}
