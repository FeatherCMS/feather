public import BlogDomain
public import FeatherContracts

public struct WriteSettings: Scope {
    public let settings: any SettingsRepository

    public init(settings: any SettingsRepository) {
        self.settings = settings
    }
}
