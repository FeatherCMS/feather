public import AccountDomain
public import FeatherModuleKit

public struct WriteAccountProfile: Scope {
    public let profile: any AccountProfileRepository

    public init(profile: any AccountProfileRepository) {
        self.profile = profile
    }
}
