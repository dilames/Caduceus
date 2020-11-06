//
//  UserSecret.swift
//  Domain
//
//  Created by Andrew Chersky  on 2/22/18.
//

import Foundation

public struct Secret {
    let passphrase: String

// sourcery:inline:auto:Secret.AutoPublicStruct
// DO NOT EDIT
    public init(
		passphrase: String)
	{
        self.passphrase = passphrase
    }
// sourcery:end
}
