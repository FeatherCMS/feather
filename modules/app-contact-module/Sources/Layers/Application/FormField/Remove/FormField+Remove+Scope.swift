public import ContactDomain
public import ContactModule
public import FeatherModuleKit

extension FormField.Remove {
    public struct Scope: FeatherModuleKit.Scope {
        public let field: any FormField.Repository.Interface

        public init(field: any FormField.Repository.Interface) {
            self.field = field
        }
    }
}
