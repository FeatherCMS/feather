import FeatherAdmin
import Foundation

protocol AdminEditSettingsInteractor: Sendable {

    func loadSettings() async throws -> AdminEditSettingsModel

    func saveSettings(
        input: AdminEditSettingsFormInput
    ) async throws
}
