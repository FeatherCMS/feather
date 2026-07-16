//
//  ReadInvitation.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import UserDomain

public struct ReadInvitation: Scope {
    public let invitation: any InvitationQueries

    public init(
        invitation: any InvitationQueries
    ) {
        self.invitation = invitation
    }
}
