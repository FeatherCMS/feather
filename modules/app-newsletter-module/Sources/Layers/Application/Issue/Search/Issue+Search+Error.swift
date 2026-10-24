public import FeatherApplication
public import NewsletterModule

extension Issue.Search {
    public enum Error: UseCaseError {
        case campaignNotFound
    }
}
