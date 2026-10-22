import FeatherApplication
import NewsletterModule

extension Issue.Add {
    public enum Error: UseCaseError {
        case campaignNotFound
    }
}
