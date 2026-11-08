//
//  URLCredential.swift
//  flutter_inappwebview
//
//  Created by Lorenzo Pichilli on 19/02/21.
//

import Foundation

extension URLCredential {
    public func toMap () -> [String:Any?] {
        var x509Certificates: [Data] = []
        for certificate in certificates {
            // A cast to a CoreFoundation type is not checked at runtime, and
            // Swift 6.3 rejects `as?` to one; compare the type ids instead.
            let ref = certificate as CFTypeRef
            guard CFGetTypeID(ref) == SecCertificateGetTypeID() else { continue }
            x509Certificates.append((ref as! SecCertificate).data)
        }
        return [
            "password": password,
            "username": user,
            "certificates": x509Certificates,
            "persistence": persistence.rawValue
        ]
    }
}
