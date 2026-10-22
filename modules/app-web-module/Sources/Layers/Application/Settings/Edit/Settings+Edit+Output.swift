public import FeatherApplication
public import WebModule

extension Settings.Edit {
    public struct Output: DTO {
        public let settings: Settings.Detail.Output

        package init(settings: Settings.Detail.Output) {
            self.settings = settings
        }
    }
}
