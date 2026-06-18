import UserDomain
import Application

public struct ReadAccount: Scope {
    public let account: any AccountQueries

    public init(account: any AccountQueries) {
        self.account = account
    }
}
