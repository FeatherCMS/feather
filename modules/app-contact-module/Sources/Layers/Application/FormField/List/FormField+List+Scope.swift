import ContactDomain
import ContactModule
import FeatherModuleKit

extension FormField.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let form: any Form.Repository.Interface
        public let field: any FormField.Repository.Interface

        public init(
            form: any Form.Repository.Interface,
            field: any FormField.Repository.Interface
        ) {
            self.form = form
            self.field = field
        }
    }
}
