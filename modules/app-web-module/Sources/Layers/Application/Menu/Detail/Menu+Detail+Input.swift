public import FeatherApplication
public import WebModule

extension Menu.Detail {
    public struct Input: DTO {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }
}
