public import ContactDomain
public import ContactModule
public import FeatherModuleKit

extension Form.Remove {
    public struct Scope: FeatherModuleKit.Scope {
        public let form: any Form.Repository.Interface

        public init(form: any Form.Repository.Interface) {
            self.form = form
        }
    }
}
