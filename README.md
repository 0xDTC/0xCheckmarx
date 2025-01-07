<a href="https://www.buymeacoffee.com/0xDTC"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a knowledge&emoji=📖&slug=0xDTC&button_colour=FF5F5F&font_colour=ffffff&font_family=Comic&outline_colour=000000&coffee_colour=FFDD00" /></a>

# 0xCheckmarx

**0xCheckmarx** is a collection of shell scripts designed to interact with Checkmarx's security platform, automating various tasks such as scanning repositories and retrieving scan results. This repository aims to simplify the integration of Checkmarx into your CI/CD workflows.

---

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
  - [Run Repository Scan](#run-repository-scan)
  - [Fetch Scan Results](#fetch-scan-results)
- [Environment Variables](#environment-variables)
- [Contributing](#contributing)
- [License](#license)

---

## Features

- Automates repository scans using Checkmarx.
- Retrieves scan results in JSON format for further processing.
- Easily integrates with CI/CD pipelines for automated security checks.

---

## Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/0xDTC/0xCheckmarx.git
   cd 0xCheckmarx
   ```

2. **Ensure the scripts have execute permissions**:
   ```bash
   chmod +x CheckmarxRepoScan.sh
   chmod +x CheckmarxScanResults.sh
   ```

3. **Install required dependencies**:

   Ensure you have `curl` and `jq` installed:
   - **For Debian/Ubuntu**:
     ```bash
     sudo apt-get install curl jq
     ```
   - **For CentOS/RHEL**:
     ```bash
     sudo yum install curl jq
     ```
   - **For macOS**:
     ```bash
     brew install curl jq
     ```

---

## Usage

### Environment Variables

Before using the scripts, export the necessary environment variables for Checkmarx API credentials:
```bash
export CX_USERNAME=your_username
export CX_PASSWORD=your_password
export CX_SERVER_URL=https://your-checkmarx-server-url
```

### Run Repository Scan

The `CheckmarxRepoScan.sh` script triggers a scan on the specified repository.
```bash
./CheckmarxRepoScan.sh <REPOSITORY_URL> <PROJECT_NAME>
```

- **REPOSITORY_URL**: URL of the repository to scan.
- **PROJECT_NAME**: Name of the project in Checkmarx.

**Example**:

```bash
./CheckmarxRepoScan.sh https://github.com/example/repo.git ExampleProject
```

### Fetch Scan Results

The `CheckmarxScanResults.sh` script retrieves the scan results for a given project.
```bash
./CheckmarxScanResults.sh <PROJECT_NAME>
```

- **PROJECT_NAME**: Name of the project in Checkmarx.

**Example**:
```bash
./CheckmarxScanResults.sh ExampleProject
```

---

## Contributing

Contributions are welcome! Follow these steps to contribute:

1. **Fork the repository.**
2. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature
   ```
3. **Commit your changes**:
   ```bash
   git commit -m "Add your feature"
   ```
4. **Push to your branch**:
   ```bash
   git push origin feature/your-feature
   ```
5. **Create a pull request.**

---

## Disclaimer

**0xCheckmarx** is intended for educational and authorized use only. Ensure you have the necessary permissions to run scans on any repository. The authors are not responsible for any misuse of this tool.

---

## Contact

For any questions or feedback, feel free to open an [issue](https://github.com/0xDTC/0xCheckmarx/issues) or contact the repository owner.
