public import FeatherApplication
public import NewsletterModule

extension Issue.TestEmail {
    public enum Error: UseCaseError {
        case newsletterNotFound
    }
}
