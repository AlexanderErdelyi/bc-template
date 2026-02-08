# GitHub Copilot Skills for BC Development

This document defines skills and capabilities that GitHub Copilot should utilize when working with Business Central AL code.

## Core AL Development Skills

### Language-Specific Knowledge
- **AL Language Syntax**: Understanding of AL language constructs, keywords, and syntax
- **Object Types**: Tables, Pages, Reports, Codeunits, Queries, XMLports, Enums
- **Data Types**: Text, Integer, Decimal, Boolean, Date, DateTime, DateFormula, GUID, etc.
- **System Functions**: Built-in AL functions and their proper usage
- **Triggers**: Understanding of trigger execution order and context

### Business Central Framework
- **Base Application Knowledge**: Understanding of standard BC tables and functionality
- **Extension Development**: Creating extensions that enhance base functionality
- **Events and Subscribers**: Publishing and subscribing to business events
- **Integration**: REST APIs, SOAP web services, OData
- **Page Patterns**: Card, List, Document, Worksheet, RoleCenter patterns
- **Report Design**: RDLC and Word layouts, data items, and requestpage design

### Development Practices
- **Version Control**: Git workflows for AL development
- **Testing**: Test codeunits, test pages, and test automation
- **Debugging**: Using debugger, breakpoints, and watch windows
- **Performance**: Query optimization, avoiding N+1 problems, caching strategies
- **Security**: Permissions, data classification, field-level security

## Code Quality Skills

### Naming Conventions
- Tables: Use clear, singular nouns (Customer, Sales Header)
- Fields: PascalCase with spaces (Customer No., Posting Date)
- Variables: camelCase or PascalCase consistently
- Procedures: Verbs describing actions (CalculateTotal, ValidateAmount)
- Parameters: Descriptive names matching their purpose

### Code Organization
- Logical grouping of related functionality
- Proper use of regions for code sections
- Single Responsibility Principle
- Separation of business logic and UI logic
- Reusable procedures and functions

### Error Handling
- Use of Error() for critical errors
- Message() for informational messages
- Confirm() for user decisions
- Proper error messages with context
- Graceful degradation when possible

### Documentation
- XML documentation for public methods
- Inline comments for complex logic
- README files for extensions
- API documentation for integrations
- Change logs and version notes

## Architectural Patterns

### Extension Patterns
- **Table Extensions**: Adding fields to base tables
- **Page Extensions**: Modifying existing pages
- **Event Subscribers**: Responding to business events
- **Interface Implementations**: Creating pluggable components
- **Codeunit Extensions**: Extending base functionality

### Integration Patterns
- **API Pages**: RESTful API endpoints
- **Web Services**: SOAP and OData services
- **External Connectors**: Integration with third-party systems
- **Batch Processing**: Scheduled tasks and background operations
- **Message Queues**: Asynchronous processing patterns

### Data Management Patterns
- **Master Data**: Customer, Vendor, Item management
- **Document Flow**: Quote → Order → Shipment → Invoice
- **Journal Processing**: General journals, item journals, etc.
- **Posting Routines**: Transaction recording and validation
- **Archive Patterns**: Historical data retention

## Testing Skills

### Unit Testing
- Test isolation and independence
- Mocking external dependencies
- Test data setup and teardown
- Assertion best practices
- Code coverage analysis

### Integration Testing
- End-to-end workflow testing
- Multi-object interaction testing
- API endpoint testing
- Performance testing
- Load testing

### Test Automation
- Automated test execution
- Continuous Integration testing
- Regression test suites
- Test reporting and metrics
- Test maintenance strategies

## Performance Optimization Skills

### Query Optimization
- Proper use of SETRANGE vs SETFILTER
- FINDFIRST vs FINDSET usage
- Avoiding unnecessary CALCFIELDS
- Index awareness and optimization
- Limiting result sets appropriately

### Code Efficiency
- Loop optimization
- Reducing database roundtrips
- Caching frequently accessed data
- Avoiding redundant calculations
- Lazy loading patterns

### Resource Management
- Proper use of temporary tables
- Memory management best practices
- Connection pooling
- Transaction scope optimization
- Background processing for heavy operations

## Security Skills

### Data Protection
- Data Classification awareness
- Field-level security implementation
- Encryption for sensitive data
- Audit trail implementation
- Privacy compliance (GDPR, etc.)

### Access Control
- Permission sets design
- Role-based access control
- Object-level permissions
- Field-level permissions
- Company-specific security

### Secure Coding
- Input validation
- SQL injection prevention
- XSS prevention in web services
- Secure credential management
- Secure API authentication

## Debugging and Troubleshooting Skills

### Diagnostic Techniques
- Effective use of debugger
- Log analysis and interpretation
- Performance profiling
- Memory leak detection
- Deadlock identification

### Problem Resolution
- Root cause analysis
- Systematic debugging approach
- Performance bottleneck identification
- Error pattern recognition
- Fix verification and validation

## DevOps Skills

### CI/CD Practices
- Automated build processes
- Automated testing in pipelines
- Deployment automation
- Environment management
- Release management

### Version Control
- Branching strategies
- Merge conflict resolution
- Code review practices
- Tag and release management
- Change tracking

### Monitoring and Maintenance
- Application telemetry
- Performance monitoring
- Error logging and alerting
- Health checks
- Capacity planning

## Domain Knowledge

### Business Central Modules
- Financial Management
- Sales and Receivables
- Purchase and Payables
- Inventory Management
- Manufacturing
- Service Management
- Project Management
- Warehouse Management

### Business Processes
- Order-to-Cash cycle
- Purchase-to-Pay cycle
- Record-to-Report cycle
- Plan-to-Produce cycle
- Hire-to-Retire cycle

### Industry Verticals
- Retail and e-commerce
- Manufacturing and distribution
- Professional services
- Non-profit organizations
- Healthcare
- Construction

## Tool Proficiency

### Development Tools
- Visual Studio Code with AL extension
- AL Language Extension features
- Debugger functionality
- Code snippets and templates
- IntelliSense and code completion

### Supporting Tools
- Git and GitHub
- Azure DevOps
- Docker for BC containers
- PowerShell for automation
- Postman for API testing

### Analysis Tools
- Performance Profiler
- Application Insights
- Event Log analysis
- Code analysis tools
- Dependency analyzers

## Continuous Learning

### Stay Updated On
- BC release waves and new features
- Deprecated functionality
- API changes and updates
- Best practice evolution
- Community contributions and patterns

### Resources
- Microsoft Learn documentation
- BC Tech community blogs
- GitHub BC samples
- MVPs and community experts
- Official BC forums and support
