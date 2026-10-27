public import FeatherApplication
public import NewsletterModule

extension Issue.Send {
    public enum Error: UseCaseError {
        case newsletterNotFound
        case issueNotFound
    }
}
