import Testing

@testable import NewsletterApplication

@Suite
struct NewsletterApplicationTestSuite {

    @Test
    func inputsAreSendableDTOs() {
        #expect(
            CreateCampaign.Input(name: "Updates").name == "Updates"
        )
        #expect(
            CreateIssue.Input(
                newsletterId: "newsletter-1",
                subject: "Subject",
                content: "Content"
            )
            .content == "Content"
        )
        #expect(
            Subscribe.Input(
                newsletterId: "newsletter-1",
                email: "person@example.com"
            )
            .email == "person@example.com"
        )
    }
}
