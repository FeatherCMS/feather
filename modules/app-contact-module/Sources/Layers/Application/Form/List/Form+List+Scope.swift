public import ContactModule
public import FeatherModuleKit

extension Form.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let form: any Query.Interface

        public init(form: any Query.Interface) {
            self.form = form
        }
    }
}
