public import FeatherApplication
public import NewsletterModule

extension Subscriber.Remove {
    public enum Error: UseCaseError {
        case campaignNotFound
    }
}
