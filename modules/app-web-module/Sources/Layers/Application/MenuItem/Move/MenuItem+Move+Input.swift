public import FeatherApplication
public import WebModule

extension MenuItem.Move {
    public struct Input: DTO {
        public let id: String
        public let menuId: String
        public let beforeItemId: String?

        public init(id: String, menuId: String, beforeItemId: String?) {
            self.id = id
            self.menuId = menuId
            self.beforeItemId = beforeItemId
        }
    }
}
