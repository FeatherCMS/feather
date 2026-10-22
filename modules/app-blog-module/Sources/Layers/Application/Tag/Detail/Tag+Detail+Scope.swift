public import BlogModule
public import FeatherModuleKit

extension Tag.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let tag: any Tag.Detail.Query.Interface

        public init(tag: any Tag.Detail.Query.Interface) {
            self.tag = tag
        }
    }
}
