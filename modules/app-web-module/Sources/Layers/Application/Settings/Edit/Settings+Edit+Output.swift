public import FeatherApplication
public import WebDomain

extension Settings.Edit {
    public struct Output: DTO {
        public let settings: SettingsDetail

        package init(settings: SettingsDetail) {
            self.settings = settings
        }
    }
}
