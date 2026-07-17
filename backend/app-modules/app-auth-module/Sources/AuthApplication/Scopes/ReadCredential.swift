import AuthDomain
import Application

public struct ReadCredentialLink: Scope {
    public let credential: any CredentialQueries

    public init(
        credential: any CredentialQueries
    ) {
        self.credential = credential
    }
}
