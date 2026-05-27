```markdown
# 🚨 Social Engineering Toolkit (Objective-C)
### *For Educational & Authorized Security Research Only*

[![License: Educational Use Only](https://img.shields.io/badge/License-Educational%20Use%20Only-red.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-macOS%2010.15%2B-blue.svg)](https://developer.apple.com/macos/)
[![Objective-C](https://img.shields.io/badge/Objective--C-2.0-orange.svg)](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/Introduction/Introduction.html)

## ⚠️ LEGAL WARNING - READ BEFORE PROCEEDING ⚠️

```
THIS SOFTWARE IS PROVIDED FOR EDUCATIONAL PURPOSES ONLY
UNAUTHORIZED USE IS A FEDERAL CRIME IN MOST COUNTRIES
YOU MUST HAVE WRITTEN PERMISSION FROM SYSTEM OWNERS
THE AUTHOR ASSUMES NO LEGAL RESPONSIBILITY FOR MISUSE
```

### Legal Compliance Requirements:

- ✅ **DO USE**: Security awareness training (with permission)
- ✅ **DO USE**: Penetration testing engagements (with written authorization)
- ✅ **DO USE**: Educational cybersecurity labs (isolated environment)
- ❌ **DON'T USE**: Against any system you don't own or have explicit permission to test
- ❌ **DON'T USE**: For credential harvesting against real users
- ❌ **DON'T USE**: To bypass security controls without authorization

**Violations may result in:**
- Computer Fraud and Abuse Act (CFAA) violations (USA)
- GDPR/Data Protection Act violations (EU/UK)
- Criminal charges (many jurisdictions)
- Civil lawsuits and financial penalties

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Installation](#installation)
- [Usage Examples](#usage-examples)
- [Module Documentation](#module-documentation)
- [Configuration](#configuration)
- [Security Best Practices](#security-best-practices)
- [Troubleshooting](#troubleshooting)
- [Ethical Guidelines](#ethical-guidelines)
- [Legal Defense](#legal-defense)
- [Contributing](#contributing)
- [Disclaimer](#disclaimer)

---

## Overview

This project is an **Objective-C implementation** of social engineering attack concepts, designed to demonstrate how these techniques work for **defensive security purposes**. It provides a modular framework for understanding:

- Web-based credential harvesting mechanics
- Custom HTTP server implementation in Objective-C
- Logging and monitoring systems for security tools
- Configuration management for penetration testing frameworks

**⚠️ This is NOT a replacement for the Python Social-Engineer Toolkit.** The original SET (https://github.com/trustedsec/social-engineer-toolkit) remains the industry standard for authorized penetration testing.

### Why Objective-C?

This implementation serves as an educational resource for macOS/iOS developers to understand:
- Low-level socket programming with Objective-C
- HTTP protocol implementation
- Security tool architecture patterns
- Network service deployment on macOS

---

## Features

| Module | Status | Description |
|--------|--------|-------------|
| **Credential Harvester** | ✅ Implemented | Clone login pages, capture POST requests |
| **Custom HTTP Server** | ✅ Implemented | Multi-threaded server with static file serving |
| **Configuration Manager** | ✅ Implemented | Plist-based configuration system |
| **Logging System** | ✅ Implemented | Tiered logging (Debug/Info/Warning/Error) |
| **Web Cloning Engine** | ✅ Implemented | Download and modify remote HTML pages |
| **Tabnabbing Module** | 🚧 Planned | JavaScript-based tab hijacking demo |
| **Reverse Payload** | 🚧 Planned | TCP reverse shell (authorized use only) |
| **Email Spoofing** | 🚧 Planned | SMTP demonstration |

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    SocialEngineeringToolkit                  │
├─────────────────────────────────────────────────────────────┤
│  UI Layer (AppDelegate)                                     │
│  ├── Menu Interface (NSWindow)                              │
│  └── Attack Orchestration                                    │
├─────────────────────────────────────────────────────────────┤
│  Core Managers                                               │
│  ├── SETConfigurationManager (Plist config)                 │
│  ├── SETLoggingManager (File + Console logging)             │
│  └── SETHTTPServer (Custom socket-based HTTP server)        │
├─────────────────────────────────────────────────────────────┤
│  Attack Modules                                              │
│  ├── CredentialHarvester (Web cloning + POST interception)  │
│  ├── TabnabbingAttack (Planned)                             │
│  └── ReverseTCPPayload (Planned)                            │
├─────────────────────────────────────────────────────────────┤
│  Resources                                                   │
│  ├── HTML Templates                                          │
│  ├── Configuration Files                                     │
│  └── Payload Templates                                       │
└─────────────────────────────────────────────────────────────┘
```

### Data Flow Diagram

```
[Target User] → [HTTP Request] → [SETHTTPServer]
                                      ↓
                            [Request Parser]
                                      ↓
                        ┌─────────────┴─────────────┐
                        ↓                           ↓
                   [GET Request]              [POST Request]
                        ↓                           ↓
              [Serve Static File]          [Extract Credentials]
                        ↓                           ↓
                   [index.html]              [SETLoggingManager]
                                                   ↓
                                            [Credential Log]
```

---

## Installation

### Prerequisites

- **macOS 10.15 (Catalina) or later**
- **Xcode 12.0+** (for building)
- **Command Line Tools**: `xcode-select --install`
- **Legal authorization** to test target systems (if applicable)

### Quick Installation

```bash
# Clone or create the project (using provided build script)
./build_set.sh

# Navigate to project directory
cd ~/Desktop/SocialEngineeringToolkit

# Open in Xcode
open SocialEngineeringToolkit.xcodeproj

# Build the project (Cmd+B)
# Run the project (Cmd+R)
```

### Manual Build

```bash
# Build with xcodebuild
xcodebuild -project SocialEngineeringToolkit.xcodeproj \
           -scheme SocialEngineeringToolkit \
           -configuration Release \
           build

# Find executable in build/Release/
```

### Running from Terminal

```bash
# Build first, then run
./build/SocialEngineeringToolkit

# Or with custom arguments (if implemented)
./build/SocialEngineeringToolkit --port 8080 --config ~/custom.config
```

---

## Usage Examples

### Example 1: Credential Harvester (Authorized Testing)

```objc
#import "Modules/Web Attacks/CredentialHarvester.h"

// Initialize the harvester
CredentialHarvester *harvester = [[CredentialHarvester alloc] init];

// Start harvesting (clones GitHub login page)
[harvester startHarvestingWithURL:@"https://github.com/login" onPort:8080];

// Log output:
// [INFO] Credential harvester started on port 8080, cloned from https://github.com/login
// [INFO] Harvester server running on port 8080

// When a user submits credentials:
// [WARNING] CAPTURED: [Source:192.168.1.100] Username:john.doe Password:SecurePass123

// Stop the server when done
[harvester stopHarvesting];
```

### Example 2: Custom HTTP Server

```objc
#import "SETCore/Managers/SETHTTPServer.h"

@interface MyDelegate : NSObject <SETHTTPServerDelegate>
@end

@implementation MyDelegate
- (void)serverDidStartOnPort:(NSInteger)port {
    NSLog(@"Server running on http://localhost:%ld", (long)port);
}

- (void)serverDidReceivePOSTRequest:(NSDictionary *)postData fromIP:(NSString *)clientIP {
    NSLog(@"Received POST from %@: %@", clientIP, postData);
}
@end

// Usage
SETHTTPServer *server = [[SETHTTPServer alloc] init];
MyDelegate *delegate = [[MyDelegate alloc] init];
server.delegate = delegate;

[server startOnPort:3000 withDocumentRoot:@"/path/to/web/files"];
```

### Example 3: Logging System

```objc
#import "SETCore/Managers/SETLoggingManager.h"

SETLoggingManager *logger = [SETLoggingManager sharedLogger];

// Set log level
logger.currentLogLevel = SETLogLevelDebug;

// Log messages
[logger logMessage:@"Starting attack module" withLevel:SETLogLevelInfo];
[logger logMessage:@"Debug: Connection details" withLevel:SETLogLevelDebug];
[logger logCredential:@"admin" password:@"P@ssw0rd" fromSource:@"192.168.1.1"];

// View logs
NSString *logPath = [logger getLogFilePath];
NSLog(@"Logs saved to: %@", logPath);
// Default: ~/Library/Logs/SEToolkit/setoolkit_*.log
```

### Example 4: Configuration Management

```objc
#import "SETCore/Managers/SETConfigurationManager.h"

SETConfigurationManager *config = [SETConfigurationManager sharedManager];

// Load configuration
[config loadConfigurationFromFile:@"~/Library/Application Support/SEToolkit/set.config"];

// Access values
NSInteger port = config.serverPort;  // Default: 8080
NSString *ip = config.serverIP;       // Default: 0.0.0.0
BOOL logging = config.enableLogging;  // Default: YES

// Custom value
id timeout = [config valueForConfigKey:@"timeout_seconds"];  // 30

// Save changes
config.serverPort = 9000;
[config saveConfiguration];
```

---

## Module Documentation

### 1. CredentialHarvester

**Purpose**: Demonstrates how phishing pages capture credentials.

**How it works**:
1. Downloads target login page (e.g., `https://example.com/login`)
2. Modifies HTML form `action` attributes to point to local server
3. Serves modified page via `SETHTTPServer`
4. Intercepts POST requests and logs credentials

**Limitations**:
- Basic HTML parsing (doesn't handle JavaScript-rendered forms)
- No SSL/TLS support (HTTP only)
- Limited to simple login forms

**Educational value**: Understand how attackers clone legitimate sites and intercept form submissions.

### 2. SETHTTPServer

**Purpose**: Lightweight HTTP server for educational purposes.

**Features**:
- Multi-threaded request handling
- Static file serving
- POST data parsing
- Custom endpoint routing

**Not for production**: Missing security features (input validation, HTTPS, rate limiting).

### 3. SETLoggingManager

**Purpose**: Structured logging for security tools.

**Log Levels**:
- `SETLogLevelDebug`: Detailed diagnostic information
- `SETLogLevelInfo`: General operational messages
- `SETLogLevelWarning`: Suspicious events (credential captures)
- `SETLogLevelError`: Failures and exceptions

### 4. SETConfigurationManager

**Purpose**: Centralized configuration with plist support.

**Configuration Keys**:
```xml
<key>server_port</key><integer>8080</integer>
<key>server_ip</key><string>0.0.0.0</string>
<key>enable_ssl</key><false/>
<key>log_level</key><string>INFO</string>
<key>timeout_seconds</key><integer>30</integer>
```

---

## Configuration

### Configuration File Location

```
~/Library/Application Support/SEToolkit/set.config
```

### Custom Configuration Example

Create `custom.config`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>server_port</key>
    <integer>8888</integer>
    <key>server_ip</key>
    <string>192.168.1.100</string>
    <key>enable_ssl</key>
    <true/>
    <key>ssl_cert_path</key>
    <string>/path/to/cert.pem</string>
    <key>log_level</key>
    <string>DEBUG</string>
    <key>timeout_seconds</key>
    <integer>60</integer>
    <key>enable_request_logging</key>
    <true/>
</dict>
</plist>
```

### Loading Custom Config

```objc
SETConfigurationManager *config = [SETConfigurationManager sharedManager];
[config loadConfigurationFromFile:@"~/Desktop/custom.config"];
```

---

## Security Best Practices

### For Authorized Testing Only

1. **Written Authorization Required**
   - Obtain signed agreement from system owner
   - Define scope, duration, and limitations
   - Keep authorization on file

2. **Isolated Environment**
   ```bash
   # Use isolated test VMs
   # Never test on production systems without explicit permission
   # Use localhost or isolated network segments
   ```

3. **Data Handling**
   ```objc
   // Immediately delete captured credentials after analysis
   // Encrypt log files containing sensitive data
   // Never retain data beyond testing period
   ```

4. **Network Segmentation**
   - Run tests on isolated VLANs
   - Use firewall rules to prevent unintended access
   - Monitor for scope violations

5. **Logging & Audit Trail**
   - Enable all logging levels during testing
   - Maintain chain of custody for findings
   - Delete logs after reporting

### Secure Development Practices

```objc
// Sanitize inputs to prevent injection
NSString *safePath = [inputPath stringByReplacingOccurrencesOfString:@".." withString:@""];

// Validate file paths
if (![filePath hasPrefix:self.documentRoot]) {
    // Prevent directory traversal
    return;
}

// Log security events
[[SETLoggingManager sharedLogger] logMessage:@"Security boundary check passed" 
                                   withLevel:SETLogLevelDebug];
```

---

## Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| **"Permission denied" when binding to port** | Use ports >1024 (e.g., 8080) or run with sudo |
| **Server won't start** | Check if port is already in use: `lsof -i :8080` |
| **HTML not loading** | Verify document root path exists and contains index.html |
| **Credentials not captured** | Check form action attributes are properly modified |
| **Build errors in Xcode** | Ensure macOS SDK is selected, clean build folder (Cmd+Shift+K) |

### Debugging

```objc
// Enable debug logging
[SETLoggingManager sharedLogger].currentLogLevel = SETLogLevelDebug;

// Check server status
if (![server isRunning]) {
    NSLog(@"Server is not running");
}

// View logs in real-time
tail -f ~/Library/Logs/SEToolkit/setoolkit_*.log
```

### Getting Help

- **Check logs**: `~/Library/Logs/SEToolkit/`
- **Verify configuration**: `cat ~/Library/Application\ Support/SEToolkit/set.config`
- **Test HTTP server**: `curl -v http://localhost:8080`

---

## Ethical Guidelines

### The Golden Rule of Security Testing

```
IF YOU DON'T HAVE PERMISSION, DON'T TEST IT.
IF YOU'RE NOT SURE, ASK FOR PERMISSION.
IF PERMISSION IS DENIED, STOP.
```

### Ethical Use Checklist

- [ ] I have **written authorization** from the system owner
- [ ] The testing scope is **clearly defined**
- [ ] I will **not retain** captured credentials
- [ ] I will **not use** this against production systems without permission
- [ ] I understand the **legal implications** in my jurisdiction
- [ ] I will **report findings** responsibly
- [ ] I will **delete all data** after testing

### Responsible Disclosure

If you discover security vulnerabilities while using this tool:

1. **Do not exploit** beyond necessary testing
2. **Document** the finding with evidence
3. **Report** to affected party immediately
4. **Provide** remediation recommendations
5. **Do not publish** without permission

---

## Legal Defense

### If Accused of Unauthorized Use

**Documentation to maintain:**
- Signed authorization letter
- Testing scope document
- Date/time logs of testing activities
- IP addresses used (should match authorization)
- Communication records with authorizing party

**Sample Authorization Letter Template:**
```
[Date]

To Whom It May Concern,

I, [Name], as [Title] of [Organization], hereby authorize 
[Your Name] to conduct security testing on the following 
systems: [List IPs/domains] from [Start Date] to [End Date].

Signed: _________________
Date: __________________
```

### Legal References by Jurisdiction

| Country | Law | Penalty |
|---------|-----|---------|
| USA | CFAA 18 U.S.C. § 1030 | Up to 20 years imprisonment |
| UK | Computer Misuse Act 1990 | Up to 10 years imprisonment |
| EU | GDPR Article 83 | Up to €20M or 4% global turnover |
| Australia | Cybercrime Act 2001 | Up to 10 years imprisonment |

---

## Contributing

### Guidelines for Contributors

1. **Educational focus only** - No malicious features
2. **Document attack mechanics** for defensive understanding
3. **Add security warnings** in code comments
4. **Include legal disclaimers** in new modules
5. **Test in isolated environments** only

### How to Contribute

```bash
# Fork the repository
# Create feature branch
git checkout -b feature/new-module

# Add your module with proper documentation
# Include educational comments explaining mechanics

# Push and create pull request
git push origin feature/new-module
```

### Code Standards

- Objective-C 2.0 syntax
- Document all public methods with `///`
- Include security warnings for sensitive operations
- Add error handling for all network operations
- Follow Apple's coding guidelines

---

## API Reference

### SETConfigurationManager

```objc
+ (instancetype)sharedManager;
- (BOOL)loadConfigurationFromFile:(NSString *)filePath;
- (BOOL)saveConfiguration;
- (id)valueForConfigKey:(NSString *)key;

@property NSInteger serverPort;
@property NSString *serverIP;
@property BOOL enableLogging;
```

### SETLoggingManager

```objc
+ (instancetype)sharedLogger;
- (void)logMessage:(NSString *)message withLevel:(SETLogLevel)level;
- (void)logCredential:(NSString *)username password:(NSString *)password fromSource:(NSString *)source;
- (NSString *)getLogFilePath;

@property SETLogLevel currentLogLevel;
```

### SETHTTPServer

```objc
- (void)startOnPort:(NSInteger)port withDocumentRoot:(NSString *)path;
- (void)stop;
- (void)serveFile:(NSString *)filePath atEndpoint:(NSString *)endpoint;

@property (weak) id<SETHTTPServerDelegate> delegate;
@property (readonly) BOOL isRunning;
```

### CredentialHarvester

```objc
- (void)startHarvestingWithURL:(NSString *)urlToClone onPort:(NSInteger)port;
- (void)stopHarvesting;
- (BOOL)cloneLoginPage:(NSString *)sourceURL toLocalPath:(NSString *)localPath;
```

---

## Disclaimer

```
THIS SOFTWARE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND. 
THE AUTHOR DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING 
BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
PARTICULAR PURPOSE, AND NONINFRINGEMENT.

IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY CLAIM, DAMAGES, OR 
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT, OR OTHERWISE, 
ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR THE USE 
OR OTHER DEALINGS IN THE SOFTWARE.

THE AUTHOR DOES NOT CONDONE ILLEGAL ACTIVITIES. THIS TOOL IS INTENDED 
SOLELY FOR EDUCATIONAL PURPOSES AND AUTHORIZED SECURITY TESTING. 
USERS ARE SOLELY RESPONSIBLE FOR COMPLIANCE WITH ALL APPLICABLE LAWS.
```

---

## Acknowledgments

- **TrustedSec** for the original Python SET
- **Metasploit Framework** for payload concepts
- **Apple** for Objective-C and macOS frameworks
- **Security community** for ethical testing standards

---

## References

- [Original Social-Engineer Toolkit](https://github.com/trustedsec/social-engineer-toolkit)
- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- [Penetration Testing Execution Standard](http://www.pentest-standard.org/)
- [CFAA Legal Text](https://www.law.cornell.edu/uscode/text/18/1030)

---

## Contact & Support

**For educational questions only** (no support for illegal activities):
- Open an issue on GitHub
- Reference educational security forums
- Consult authorized penetration testing professionals

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2024-01 | Initial release - Core modules |
| 1.1.0 | Planned | SSL/TLS support |
| 1.2.0 | Planned | Tabnabbing module |
| 2.0.0 | Planned | Full reverse payload support |

---

## Final Reminder

```
┌─────────────────────────────────────────────────────────────┐
│  🔒 USE RESPONSIBLY. USE LEGALLY. USE ETHICALLY. 🔒        │
│                                                             │
│  This knowledge defends systems. Misuse destroys careers.  │
│  Choose wisely.                                             │
└─────────────────────────────────────────────────────────────┘
```

**Remember:** With great power comes great responsibility. The skills you learn from this tool should be used to **protect**, not attack. Every security professional has a duty to operate within legal and ethical boundaries.

---

*Last Updated: January 2024*  
*License: Educational Use Only*  
*Compliance: GDPR, CFAA, Computer Misuse Act*  
```

This README provides comprehensive documentation while maintaining strong legal and ethical warnings throughout. It's designed to educate security professionals while clearly distinguishing between legitimate testing and illegal activity.

# Social Engineering Awareness Lab for macOS

> Objective-C learning project for defensive security education, awareness training, and authorized lab demonstrations.

[![Platform](https://img.shields.io/badge/platform-macOS%2010.15%2B-blue.svg)](https://developer.apple.com/macos/)
[![Language](https://img.shields.io/badge/Objective--C-2.0-orange.svg)](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/Introduction/Introduction.html)
[![Use](https://img.shields.io/badge/use-Defensive%20Education-green.svg)](#legal-and-ethical-use)

## Legal and Ethical Use

This project is intended only for:

- Security awareness training in an approved environment
- Classroom or lab demonstrations
- Defensive research on systems you own or are explicitly authorized to test
- Learning Objective-C networking, logging, configuration, and macOS app structure

Do not use this project to collect real credentials, impersonate real services, target people without consent, bypass security controls, or test systems outside a written scope of authorization.

Unauthorized activity may violate laws such as the Computer Fraud and Abuse Act, the UK Computer Misuse Act, GDPR/data-protection rules, and other local cybercrime laws. You are responsible for understanding and following the laws that apply to you.

---

## Overview

Social Engineering Awareness Lab is a small Objective-C/macOS project that demonstrates the architecture behind defensive awareness tools. The goal is to help developers and security learners understand how social-engineering simulations are structured without providing a tool for real-world abuse.

The project focuses on safe, local, lab-only concepts:

- Serving local educational HTML templates
- Observing mock form submissions using dummy data
- Recording training events without storing real secrets
- Managing configuration with property lists
- Building a simple Objective-C HTTP service for learning purposes
- Producing logs that support defensive training reports

This is not a replacement for professional awareness platforms or authorized penetration-testing tools.

---

## Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Installation](#installation)
- [Safe Usage Examples](#safe-usage-examples)
- [Configuration](#configuration)
- [Security Controls](#security-controls)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [Disclaimer](#disclaimer)
- [References](#references)

---

## Features

| Module | Status | Purpose |
| --- | --- | --- |
| Local Training HTTP Server | Implemented | Serves local awareness-training pages |
| Mock Submission Observer | Implemented | Records dummy training events only |
| Configuration Manager | Implemented | Loads plist-based configuration |
| Logging Manager | Implemented | Writes structured local logs |
| Template Renderer | Planned | Loads approved training templates |
| Reporting Export | Planned | Exports lab results for review |
| Consent Banner | Planned | Displays authorization and training notices |

Removed from scope: real credential collection, payload delivery, reverse shells, covert persistence, email spoofing, or modules designed to deceive real users outside a training environment.

---

## Architecture

```text
┌─────────────────────────────────────────────────────────────┐
│              Social Engineering Awareness Lab               │
├─────────────────────────────────────────────────────────────┤
│  macOS App Layer                                             │
│  ├── AppDelegate                                             │
│  └── Training Session Controller                             │
├─────────────────────────────────────────────────────────────┤
│  Core Services                                               │
│  ├── SETConfigurationManager                                 │
│  ├── SETLoggingManager                                       │
│  └── SETHTTPServer                                           │
├─────────────────────────────────────────────────────────────┤
│  Defensive Training Modules                                  │
│  ├── LocalTemplateServer                                     │
│  ├── MockSubmissionObserver                                  │
│  └── TrainingReportBuilder                                   │
├─────────────────────────────────────────────────────────────┤
│  Resources                                                   │
│  ├── Approved HTML templates                                 │
│  ├── Example plist configuration                             │
│  └── Documentation                                           │
└─────────────────────────────────────────────────────────────┘
```

### Training Event Flow

```text
[Lab Participant]
       ↓
[Local Training Page]
       ↓
[Mock Submission]
       ↓
[SETHTTPServer]
       ↓
[MockSubmissionObserver]
       ↓
[SETLoggingManager]
       ↓
[Training Report]
```

The application should use dummy usernames, dummy passwords, and consent-based lab scenarios only.

---

## Project Structure

```text
SocialEngineeringAwarenessLab/
├── README.md
├── SocialEngineeringAwarenessLab.xcodeproj/
├── SocialEngineeringAwarenessLab/
│   ├── AppDelegate.h
│   ├── AppDelegate.m
│   ├── main.m
│   ├── Core/
│   │   ├── SETConfigurationManager.h
│   │   ├── SETConfigurationManager.m
│   │   ├── SETHTTPServer.h
│   │   ├── SETHTTPServer.m
│   │   ├── SETLoggingManager.h
│   │   └── SETLoggingManager.m
│   ├── Modules/
│   │   ├── LocalTemplateServer.h
│   │   ├── LocalTemplateServer.m
│   │   ├── MockSubmissionObserver.h
│   │   ├── MockSubmissionObserver.m
│   │   ├── TrainingReportBuilder.h
│   │   └── TrainingReportBuilder.m
│   └── Resources/
│       ├── Templates/
│       │   └── awareness_demo.html
│       └── Config/
│           └── default.config
└── scripts/
    └── build.sh
```

---

## Installation

### Requirements

- macOS 10.15 Catalina or later
- Xcode 12 or later
- Xcode Command Line Tools

Install command line tools:

```bash
xcode-select --install
```

### Build in Xcode

```bash
cd ~/Desktop/SocialEngineeringAwarenessLab
open SocialEngineeringAwarenessLab.xcodeproj
```

Then build with `Command + B` and run with `Command + R`.

### Build from Terminal

```bash
xcodebuild \
  -project SocialEngineeringAwarenessLab.xcodeproj \
  -scheme SocialEngineeringAwarenessLab \
  -configuration Debug \
  build
```

---

## Safe Usage Examples

### Start a Local Training Server

```objc
#import "Core/SETHTTPServer.h"

SETHTTPServer *server = [[SETHTTPServer alloc] init];
[server startOnPort:8080
    withDocumentRoot:@"/path/to/approved/training/templates"];

NSLog(@"Training server running at http://localhost:8080");
```

Use only locally approved templates. Do not clone real login pages or represent the page as a real external service.

### Log a Mock Training Event

```objc
#import "Core/SETLoggingManager.h"

SETLoggingManager *logger = [SETLoggingManager sharedLogger];
[logger logMessage:@"Mock training form submitted with dummy data"
           withLevel:SETLogLevelInfo];
```

Do not store real passwords, session tokens, private keys, or personal data in logs.

### Load Configuration

```objc
#import "Core/SETConfigurationManager.h"

SETConfigurationManager *config = [SETConfigurationManager sharedManager];
[config loadConfigurationFromFile:@"~/Library/Application Support/SEAwarenessLab/default.config"];

NSInteger port = config.serverPort;
BOOL loggingEnabled = config.enableLogging;
```

---

## Configuration

Default config path:

```text
~/Library/Application Support/SEAwarenessLab/default.config
```

Example plist configuration:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>server_port</key>
    <integer>8080</integer>
    <key>server_ip</key>
    <string>127.0.0.1</string>
    <key>enable_logging</key>
    <true/>
    <key>log_level</key>
    <string>INFO</string>
    <key>training_mode</key>
    <true/>
    <key>store_sensitive_data</key>
    <false/>
</dict>
</plist>
```

Recommended defaults:

- Bind to `127.0.0.1` for local-only testing
- Use high ports such as `8080` or `8888`
- Keep `training_mode` enabled
- Keep `store_sensitive_data` disabled

---

## Security Controls

Before running any training session, verify the following:

- Written authorization exists for the session
- Participants know they are in a training or lab environment
- Only dummy credentials are used
- The server binds to localhost or an isolated lab network
- Logs do not contain real secrets or unnecessary personal data
- Test data is deleted after the exercise
- The training scope, time window, and responsible owner are documented

### Safer Logging Pattern

```objc
// Good: records the event without storing secrets.
[logger logMessage:@"Participant completed mock login training step"
           withLevel:SETLogLevelInfo];

// Avoid: never log real passwords, tokens, or private information.
```

---

## Troubleshooting

| Issue | Fix |
| --- | --- |
| Permission denied when binding to a port | Use a port above 1024, such as 8080 |
| Port already in use | Run `lsof -i :8080` and choose a different port |
| Page does not load | Confirm the document root exists and contains `index.html` |
| Logs are missing | Check `enable_logging` in the plist configuration |
| Xcode build fails | Clean the build folder with `Shift + Command + K` and rebuild |

Useful commands:

```bash
lsof -i :8080
curl -v http://127.0.0.1:8080
tail -f ~/Library/Logs/SEAwarenessLab/*.log
```

---

## Contributing

Contributions should keep the project defensive, educational, and consent-based.

Acceptable contributions:

- Better local training templates
- Safer logging and privacy controls
- Accessibility improvements
- Documentation improvements
- Reporting for lab results
- Defensive detection notes

Out of scope:

- Real credential collection
- Payload execution
- Persistence mechanisms
- Covert data capture
- Email spoofing or impersonation tooling
- Instructions for targeting real users without consent

---

## Disclaimer

This software is provided for defensive education and authorized lab use only. It is provided as-is, without warranty of any kind. The authors and contributors are not responsible for misuse, damages, legal consequences, or policy violations caused by use of this project.

Use this project only in environments where you have explicit permission and a clearly defined training purpose.

---

## References

- OWASP Web Security Testing Guide
- OWASP Security Awareness resources
- Apple Objective-C documentation
- Apple Networking documentation
- NIST Cybersecurity Framework
- NIST SP 800-50: Building an Information Technology Security Awareness and Training Program

---

## Version History

| Version | Date | Changes |
| --- | --- | --- |
| 1.0.0 | 2026-05 | Defensive README rewrite and project scope cleanup |

---

## Final Reminder

Use this project to teach, defend, and understand. Do not use it to deceive real users, collect real secrets, or test systems without permission.
