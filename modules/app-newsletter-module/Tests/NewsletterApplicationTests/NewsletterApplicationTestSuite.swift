import Testing

@testable import NewsletterApplication

@Suite
struct NewsletterApplicationTestSuite {

    @Test
    func inputsAreSendableDTOs() {
        #expect(
            CreateNewsletterCampaign.Input(name: "Updates").name == "Updates"
        )
        #expect(
            CreateNewsletterIssue.Input(
                newsletterId: "newsletter-1",
                subject: "Subject",
                content: "Content"
            )
            .content == "Content"
        )
        #expect(
            SubscribeToNewsletter.Input(
                newsletterId: "newsletter-1",
                email: "person@example.com"
            )
            .email == "person@example.com"
        )
    }
}
