public import FeatherModuleKit
public import RedirectDomain
public import RedirectModule

extension Rule.Add {
    public struct Scope: FeatherModuleKit.Scope {
        public let repository: any Rule.Repository.Interface

        public init(repository: any Rule.Repository.Interface) {
            self.repository = repository
        }
    }
}
