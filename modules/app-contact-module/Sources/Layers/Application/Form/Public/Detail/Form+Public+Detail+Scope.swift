public import ContactModule
public import FeatherModuleKit

extension Form.Public.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let form: any Query.Interface

        public init(form: any Query.Interface) {
            self.form = form
        }
    }
}
