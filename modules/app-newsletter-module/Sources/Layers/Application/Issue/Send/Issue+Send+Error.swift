import FeatherApplication
import NewsletterModule

extension Issue.Send {
    public enum Error: UseCaseError {
        case newsletterNotFound
    }
}
