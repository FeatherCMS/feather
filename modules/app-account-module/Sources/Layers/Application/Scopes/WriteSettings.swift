import AccountDomain
import FeatherApplication
import FeatherContracts

public struct WriteSettings: Scope {
    public let settings: any SettingsRepository

    public init(settings: any SettingsRepository) {
        self.settings = settings
    }
}
