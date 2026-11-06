public import ContactModule
public import FeatherApplication

extension Form.Submit {
    public struct Output: DTO {
        public let redirectUrl: String?

        package init(redirectUrl: String?) {
            self.redirectUrl = redirectUrl
        }
    }
}
