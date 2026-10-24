public import FeatherApplication
public import NewsletterModule

extension Issue.List {
    public enum Error: UseCaseError {
        case campaignNotFound
    }
}
