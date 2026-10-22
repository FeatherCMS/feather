public import FeatherApplication
public import WebDomain

extension MenuItem.Remove {
    public struct Input: DTO {
        public let ids: [String]
        public let menuId: String

        public init(ids: [String], menuId: String) {
            self.ids = ids
            self.menuId = menuId
        }
    }
}
