import AuthDomain
import Application

public struct WriteCredentialLink: Scope {
    public let credential: any CredentialRepository

    public init(credential: any CredentialRepository) {
        self.credential = credential
    }
}
