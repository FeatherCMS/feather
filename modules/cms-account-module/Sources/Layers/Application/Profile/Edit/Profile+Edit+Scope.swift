public import AccountDomain
public import AccountModule
public import FeatherModuleKit

extension Profile.Edit {
    public struct Scope: FeatherModuleKit.Scope {
        public let profile: any Profile.Repository.Interface

        public init(profile: any Profile.Repository.Interface) {
            self.profile = profile
        }
    }
}
