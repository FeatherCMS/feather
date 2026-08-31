import AccountDomain
import FeatherApplication
import FeatherContracts

public struct WriteAccountProfile: Scope {
    public let profile: any AccountProfileRepository

    public init(profile: any AccountProfileRepository) {
        self.profile = profile
    }
}
