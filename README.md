# Business Central Development Template

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![BC Version](https://img.shields.io/badge/BC-22.0+-blue.svg)](https://docs.microsoft.com/dynamics365/business-central/)

A comprehensive starter template for Dynamics 365 Business Central development in VS Code. This template includes AL project scaffolding, GitHub Copilot integration, code guidelines, knowledge base, helper functions, Azure DevOps MCP integration, and automation scripts to help you quickly spin up consistent, high‑quality BC projects with best practices built in.

## 🚀 Features

- ✅ **Complete AL Project Structure** - Ready-to-use table, page, codeunit, and enum samples
- 🤖 **GitHub Copilot Integration** - Prompts, skills, and instructions for AI-assisted development
- 📚 **Comprehensive Documentation** - Code guidelines, best practices, and knowledge base
- 🔧 **Helper Functions Library** - Reusable utility functions for common tasks
- 🔗 **Azure DevOps MCP** - Integration guide for seamless DevOps workflow
- ⚙️ **VS Code Configuration** - Optimized settings and recommended extensions
- 🐳 **Docker Support** - Scripts for BC container setup and management
- 🧪 **Testing Framework** - Test structure and automation scripts
- 📋 **GitHub Templates** - Issue and PR templates for better collaboration
- 🔄 **CI/CD Workflows** - GitHub Actions for automated build and test

## 📋 Table of Contents

- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Documentation](#documentation)
- [GitHub Copilot Integration](#github-copilot-integration)
- [Scripts](#scripts)
- [Contributing](#contributing)
- [License](#license)

## 🏁 Getting Started

### Prerequisites

Before using this template, ensure you have:

- **Visual Studio Code** with AL Language extension
- **Docker Desktop** (for local BC container development)
- **PowerShell 7+** (for automation scripts)
- **Git** for version control
- **BC Container Helper** PowerShell module (installed via scripts)
- **GitHub Copilot** (optional, but recommended)

### Quick Start

1. **Use this template** - Click "Use this template" button on GitHub
2. **Clone your repository**
   ```bash
   git clone https://github.com/your-username/your-bc-project.git
   cd your-bc-project
   ```

3. **Customize the project**
   - Update `src/app.json` with your extension details
   - Modify the ID ranges to your assigned range
   - Update publisher information

4. **Set up development environment**
   ```powershell
   cd scripts
   .\setup-dev-environment.ps1 -AcceptEula
   ```

5. **Open in VS Code**
   ```bash
   code .
   ```

6. **Start developing** - Press F5 to build and deploy to your BC container

## 📁 Project Structure

```
bc-template/
├── .github/
│   ├── copilot/
│   │   ├── prompts.md           # GitHub Copilot prompts
│   │   ├── skills.md            # Copilot skills definition
│   │   └── instructions.md      # Copilot instructions
│   ├── workflows/
│   │   ├── build.yml            # Build workflow
│   │   └── code-quality.yml     # Code quality checks
│   ├── ISSUE_TEMPLATE/          # Issue templates
│   └── PULL_REQUEST_TEMPLATE/   # PR templates
├── .vscode/
│   ├── extensions.json          # Recommended extensions
│   ├── settings.json            # VS Code settings
│   ├── launch.json              # Debug configurations
│   └── ruleset.json             # AL code analysis rules
├── docs/
│   ├── guidelines/
│   │   ├── code-guidelines.md   # Coding standards
│   │   └── best-practices.md    # BC best practices
│   └── knowledge-base/
│       ├── al-language-guide.md # AL language reference
│       ├── helper-functions.md  # Utility functions
│       ├── azure-devops-mcp.md  # DevOps integration
│       └── useful-links.md      # Resource links
├── scripts/
│   ├── setup-dev-environment.ps1  # Environment setup
│   ├── build-extension.ps1        # Build automation
│   ├── run-tests.ps1              # Test automation
│   └── cleanup.ps1                # Cleanup script
├── src/
│   ├── app.json                 # AL project manifest
│   ├── SampleMaster.Table.al    # Sample table
│   ├── SampleStatus.Enum.al     # Sample enum
│   ├── SampleMasterCard.Page.al # Sample card page
│   ├── SampleMasterList.Page.al # Sample list page
│   └── SampleManagement.Codeunit.al  # Sample codeunit
├── .editorconfig                # Editor configuration
├── .gitignore                   # Git ignore rules
├── CHANGELOG.md                 # Version history
├── CONTRIBUTING.md              # Contribution guidelines
├── LICENSE                      # MIT License
└── README.md                    # This file
```

## 📖 Documentation

### Code Guidelines
Comprehensive coding standards and best practices for BC development:
- [Code Guidelines](docs/guidelines/code-guidelines.md) - Naming conventions, code structure, error handling
- [Best Practices](docs/guidelines/best-practices.md) - Development, data management, integration, security

### Knowledge Base
Essential reference materials for BC developers:
- [AL Language Guide](docs/knowledge-base/al-language-guide.md) - Language basics, object types, common patterns
- [Helper Functions](docs/knowledge-base/helper-functions.md) - Reusable utility functions
- [Azure DevOps MCP](docs/knowledge-base/azure-devops-mcp.md) - DevOps integration setup
- [Useful Links](docs/knowledge-base/useful-links.md) - External resources and documentation

## 🤖 GitHub Copilot Integration

This template includes comprehensive GitHub Copilot integration to accelerate development:

### Prompts Library
Pre-built prompts for common BC development tasks:
- AL code generation (tables, pages, codeunits)
- Code improvement and refactoring
- Testing and documentation
- API integration
- See [.github/copilot/prompts.md](.github/copilot/prompts.md)

### Skills Definition
Copilot skills for BC-specific knowledge:
- AL language expertise
- BC framework understanding
- Code quality and performance
- Testing and debugging
- See [.github/copilot/skills.md](.github/copilot/skills.md)

### Instructions
Coding standards and patterns for Copilot to follow:
- Code style and formatting
- Object-specific guidelines
- Best practices enforcement
- See [.github/copilot/instructions.md](.github/copilot/instructions.md)

### Using Copilot

1. **Code Generation**: Use prompts from the prompts library
2. **Code Review**: Ask Copilot to review your AL code
3. **Refactoring**: Request improvements with context
4. **Documentation**: Generate XML comments and tooltips
5. **Testing**: Create test codeunits with examples

Example prompts:
```
Create an AL table for tracking customer orders with proper validation
Add comprehensive error handling to this sales posting codeunit
Generate unit tests for the customer credit check logic
```

## 🔧 Scripts

### Setup Development Environment
```powershell
.\scripts\setup-dev-environment.ps1 -BCVersion "22.0" -ContainerName "bcserver" -AcceptEula
```
Sets up BC container, installs BC Container Helper, and configures VS Code.

### Build Extension
```powershell
.\scripts\build-extension.ps1 -ProjectPath "..\src" -OutputPath "..\output"
```
Compiles the AL extension and generates .app file.

### Run Tests
```powershell
.\scripts\run-tests.ps1 -ContainerName "bcserver" -TestSuite "DEFAULT"
```
Executes AL test codeunits and generates results.

### Cleanup
```powershell
.\scripts\cleanup.ps1 -ContainerName "bcserver"
```
Removes containers and cleans up build artifacts.

## 🔄 CI/CD Integration

### GitHub Actions
The template includes workflows for:
- **Build**: Compile AL extension on push/PR
- **Code Quality**: Run code analysis and linting
- **Test**: Execute automated tests

### Azure DevOps
See [Azure DevOps MCP Guide](docs/knowledge-base/azure-devops-mcp.md) for:
- Pipeline configuration
- Work item integration
- Release management
- MCP setup for AI-assisted DevOps

## 🧪 Testing

### Test Structure
```al
codeunit 50101 "Sample Tests"
{
    Subtype = Test;

    [Test]
    procedure TestSampleFeature()
    begin
        // [GIVEN] Setup test data
        // [WHEN] Execute action
        // [THEN] Verify results
    end;
}
```

### Running Tests
- **Manually**: Use AL Test Runner extension in VS Code
- **Automated**: Run `.\scripts\run-tests.ps1`
- **CI/CD**: Tests run automatically in workflows

## 🎨 Customization

### Update Project Information
1. Edit `src/app.json`:
   - Change `id`, `name`, `publisher`
   - Update `version` and `description`
   - Set your ID ranges
   
2. Update `README.md` with project details

3. Customize `.github/` templates for your workflow

### Add Your Code
- Tables: `src/YourTable.Table.al`
- Pages: `src/YourPage.Page.al`
- Codeunits: `src/YourCodeunit.Codeunit.al`
- Follow naming conventions from guidelines

## 📝 VS Code Extensions

### Recommended (Auto-suggested)
- AL Language (Microsoft)
- GitHub Copilot
- GitLens
- AL Code Outline
- AL Formatter
- Markdown All in One

### Installation
Open VS Code and install recommended extensions when prompted, or:
```
code --install-extension ms-dynamics-smb.al
code --install-extension github.copilot
```

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for:
- Code of conduct
- How to submit issues
- Pull request process
- Coding standards

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Microsoft Dynamics 365 Business Central team
- BC Container Helper contributors
- GitHub Copilot team
- BC community and MVPs

## 📞 Support

- **Documentation**: Check the [docs/](docs/) folder
- **Issues**: Use GitHub Issues
- **Discussions**: Use GitHub Discussions
- **BC Community**: [Business Central Community](https://community.dynamics.com/business)

## 🗺️ Roadmap

See [CHANGELOG.md](CHANGELOG.md) for version history and planned features.

---

**Happy Coding! 🚀**

Made with ❤️ for the Business Central developer community
