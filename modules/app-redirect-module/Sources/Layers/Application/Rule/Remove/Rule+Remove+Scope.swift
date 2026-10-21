public import FeatherModuleKit
public import RedirectDomain
public import RedirectModule

extension RedirectModule.Rule.Remove {
    public struct Scope: FeatherModuleKit.Scope {
        public let repository: any RedirectModule.Rule.Repository.Interface

        public init(repository: any RedirectModule.Rule.Repository.Interface) {
            self.repository = repository
        }
    }
}
