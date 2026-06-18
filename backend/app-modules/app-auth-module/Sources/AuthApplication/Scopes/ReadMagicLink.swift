import AuthDomain
import Application

public struct ReadMagicLink: Scope {
    public let magicLink: any MagicLinkQueries

    public init(
        magicLink: any MagicLinkQueries
    ) {
        self.magicLink = magicLink
    }
}
