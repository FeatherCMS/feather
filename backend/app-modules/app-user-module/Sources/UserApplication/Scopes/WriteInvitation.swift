//
//  WriteInvitation.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import UserDomain

public struct WriteInvitation: Scope {
    public let invitation: any InvitationRepository

    public init(invitation: any InvitationRepository) {
        self.invitation = invitation
    }
}
