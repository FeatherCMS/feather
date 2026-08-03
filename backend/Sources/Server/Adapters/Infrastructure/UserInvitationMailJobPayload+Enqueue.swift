import Application
import Environment
import Jobs
import UserApplication

extension JobQueueProtocol {

    func enqueueUserInvitationMail(
        email: String,
        token: String
    ) async throws {
        _ = try await push(
            .init(UserInvitationMailJobPayload.jobName),
            parameters: UserInvitationMailJobPayload(
                email: email,
                token: token
            )
        )
    }
}

struct JobQueueInvitationMailQueue: InvitationMailQueue {
    let queue: any JobQueueProtocol

    func enqueue(
        email: String,
        token: String
    ) async throws {
        try await queue.enqueueUserInvitationMail(
            email: email,
            token: token
        )
    }
}
