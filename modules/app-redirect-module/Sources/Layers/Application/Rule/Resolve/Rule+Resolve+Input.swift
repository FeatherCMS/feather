public import FeatherApplication
public import RedirectModule

extension Rule.Resolve {
    public struct Input: DTO {
        public let source: String

        public init(source: String) {
            self.source = source
        }
    }
}
