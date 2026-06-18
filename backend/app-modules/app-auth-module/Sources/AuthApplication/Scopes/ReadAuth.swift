import AuthDomain
import Application
import UserApplication

public struct ReadAuth: Scope {
    public let account: any AccountQueries
    public let session: any SessionQueries

    public init(
        account: any AccountQueries,
        session: any SessionQueries
    ) {
        self.account = account
        self.session = session
    }
}
