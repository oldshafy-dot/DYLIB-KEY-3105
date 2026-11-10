# ROBO iOS 3105

A standalone SwiftUI iOS 16+ project with a server-backed license gate.

## License API

- Base URL: https://shafaykeyauthadmin.lovable.app
- Verify: POST /api/public/v1/verify-license
- Payload: key, device_id, product_identifier
- Product identifier: 3105

The app creates a stable random installation identifier in the iOS Keychain and sends it with every verification request. The server is responsible for enforcing one-device binding.
