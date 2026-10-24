import Testing
import NewsletterModule

@testable import NewsletterApplication

@Suite
struct NewsletterApplicationTestSuite {

    @Test
    func inputsAreSendableDTOs() {
        #expect(
            Campaign.Add.Input(key: "updates", name: "Updates").name
                == "Updates"
        )
        #expect(
            Issue.Add.Input(
                campaignKey: "newsletter-1",
                subject: "Subject",
                content: "Content"
            )
            .content == "Content"
        )
        #expect(
            Subscriber.Subscribe.Input(
                campaignKey: "newsletter-1",
                email: "person@example.com"
            )
            .email == "person@example.com"
        )
    }
}
