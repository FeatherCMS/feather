public import ContactModule
public import FeatherModuleKit

extension FormField.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let field: any Query.Interface

        public init(field: any Query.Interface) {
            self.field = field
        }
    }
}
