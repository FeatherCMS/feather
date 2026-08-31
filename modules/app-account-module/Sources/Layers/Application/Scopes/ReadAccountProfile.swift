import AccountDomain
import FeatherApplication
import FeatherContracts

public struct ReadAccountProfile: Scope {
    public let profile: any AccountProfileQueries

    public init(
        profile: any AccountProfileQueries
    ) {
        self.profile = profile
    }
}
