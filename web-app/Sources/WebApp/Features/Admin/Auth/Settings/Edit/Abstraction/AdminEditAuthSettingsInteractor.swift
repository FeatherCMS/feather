import Foundation

protocol AdminEditAuthSettingsInteractor: Sendable {

    func loadSettings() async throws -> AdminEditAuthSettingsModel
}
