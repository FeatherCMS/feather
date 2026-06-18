import Foundation

struct AdminEditAuthSettingsDefaultInteractor: AdminEditAuthSettingsInteractor {

    func loadSettings() async throws -> AdminEditAuthSettingsModel {
        .init(
            language: "en",
            timezone: TimeZone.current.identifier,
            pageSize: 20
        )
    }
}
