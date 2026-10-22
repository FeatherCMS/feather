public import FeatherApplication
public import WebDomain

extension Menu.Detail {
    public struct Input: DTO {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }
}
