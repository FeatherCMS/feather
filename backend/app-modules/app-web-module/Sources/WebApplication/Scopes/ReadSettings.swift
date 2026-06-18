import Application
import WebDomain

public struct ReadSettings: Scope {
    public let settings: any SettingsQueries

    public init(settings: any SettingsQueries) {
        self.settings = settings
    }
}
