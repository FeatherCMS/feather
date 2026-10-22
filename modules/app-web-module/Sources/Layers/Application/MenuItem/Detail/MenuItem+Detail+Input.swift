public import FeatherApplication
public import WebModule

extension MenuItem.Detail {
    public struct Input: DTO {
        public let id: String
        public let menuId: String

        public init(id: String, menuId: String) {
            self.id = id
            self.menuId = menuId
        }
    }
}
