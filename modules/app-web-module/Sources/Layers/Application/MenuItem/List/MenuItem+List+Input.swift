public import FeatherApplication
public import WebModule

extension MenuItem.List {
    public struct Input: DTO {
        public let menuId: String

        public init(menuId: String) {
            self.menuId = menuId
        }
    }
}
