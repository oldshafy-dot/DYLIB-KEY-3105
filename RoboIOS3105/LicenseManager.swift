import Foundation
import SwiftUI

@MainActor
final class LicenseManager: ObservableObject {
    @Published private(set) var isVerified = false
    @Published private(set) var isVerifying = false
    @Published private(set) var errorMessage: String?

    private let baseURL = URL(string: "https://shafaykeyauthadmin.lovable.app")!
    private let productIdentifier = "3105"

    func restoreAndValidate() async {
        guard let savedKey = KeychainStore.read(key: KeychainStore.licenseKey) else {
            return
        }
        await verify(key: savedKey, restoring: true)
    }

    func verify(key rawKey: String, restoring: Bool = false) async {
        let key = rawKey.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !key.isEmpty else {
            errorMessage = "Please enter a license key."
            return
        }

        if isVerifying { return }
        isVerifying = true
        errorMessage = nil

        do {
            let deviceID = try KeychainStore.installationID()
            let endpoint = baseURL.appendingPathComponent("api/public/v1/verify-license")

            var request = URLRequest(url: endpoint)
            request.httpMethod = "POST"
            request.timeoutInterval = 15
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")

            let body = VerifyLicenseRequest(
                key: key,
                device_id: deviceID,
                product_identifier: productIdentifier
            )
            request.httpBody = try JSONEncoder().encode(body)

            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse else {
                throw LicenseError.server("Invalid server response.")
            }

            let decoded = try? JSONDecoder().decode(VerifyLicenseResponse.self, from: data)
            let serverMessage = decoded?.message ?? decoded?.error ?? decoded?.detail

            guard (200...299).contains(http.statusCode) else {
                throw LicenseError.server(serverMessage ?? "License verification failed.")
            }

            guard decoded?.isSuccess == true else {
                throw LicenseError.server(serverMessage ?? "License is invalid or not authorized for this device.")
            }

            KeychainStore.save(key, for: KeychainStore.licenseKey)
            isVerified = true
            errorMessage = nil
        } catch {
            if restoring {
                isVerified = false
            }
            errorMessage = (error as? LicenseError)?.message ?? "Unable to verify license. Check your internet connection and try again."
        }

        isVerifying = false
    }
}

private struct VerifyLicenseRequest: Encodable {
    let key: String
    let device_id: String
    let product_identifier: String
}

private struct VerifyLicenseResponse: Decodable {
    let success: Bool?
    let valid: Bool?
    let message: String?
    let error: String?
    let detail: String?
    let status: String?
    let data: Nested?

    struct Nested: Decodable {
        let success: Bool?
        let valid: Bool?
        let message: String?
        let error: String?
    }

    var isSuccess: Bool {
        if success == true || valid == true { return true }
        if data?.success == true || data?.valid == true { return true }
        if status?.lowercased() == "success" || status?.lowercased() == "valid" { return true }
        return false
    }
}

enum LicenseError: Error {
    case server(String)

    var message: String {
        switch self {
        case .server(let message): return message
        }
    }
}
