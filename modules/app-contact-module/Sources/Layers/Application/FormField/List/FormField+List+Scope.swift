public import ContactModule
public import FeatherModuleKit

extension FormField.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let formField: any Query.Interface

        public init(formField: any Query.Interface) {
            self.formField = formField
        }
    }
}
