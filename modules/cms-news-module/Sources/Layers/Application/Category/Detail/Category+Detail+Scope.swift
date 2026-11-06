public import FeatherModuleKit
public import NewsModule

extension Category.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let category: any Query.Interface

        public init(category: any Query.Interface) {
            self.category = category
        }
    }
}
