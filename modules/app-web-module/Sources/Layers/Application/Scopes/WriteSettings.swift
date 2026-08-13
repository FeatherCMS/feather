import FeatherApplication
import FeatherContracts
import WebDomain

public struct WriteSettings: Scope {
    public let settings: any SettingsRepository

    public init(settings: any SettingsRepository) {
        self.settings = settings
    }
}
