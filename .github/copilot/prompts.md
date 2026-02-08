# GitHub Copilot Prompts for BC Development

This file contains useful prompts for GitHub Copilot to assist with Business Central development.

## AL Code Generation Prompts

### Create a Table
```
Create an AL table named [TableName] with table ID [ID] that includes:
- Primary key field [KeyFieldName]
- Fields for [field descriptions]
- Follow BC naming conventions
- Add appropriate field captions
```

### Create a Page
```
Create an AL page of type [Card/List/Document] with page ID [ID] that:
- Uses table [TableName] as source
- Includes fields: [field list]
- Has actions for [action descriptions]
- Follow BC UX guidelines
```

### Create a Codeunit
```
Create an AL codeunit with ID [ID] that:
- Handles [functionality description]
- Includes error handling
- Follows BC coding standards
- Has XML documentation comments
```

## Code Improvement Prompts

### Refactor Code
```
Refactor this AL code to:
- Improve performance
- Follow BC best practices
- Add error handling
- Improve readability
```

### Add Error Handling
```
Add comprehensive error handling to this AL code including:
- Try-catch blocks where appropriate
- Error messages with proper formatting
- Logging of errors
- User-friendly error notifications
```

### Optimize Performance
```
Optimize this AL code for better performance:
- Review SETRANGE vs SETFILTER usage
- Optimize database operations
- Reduce redundant calculations
- Improve loop efficiency
```

## Testing Prompts

### Create Test Codeunit
```
Create a test codeunit for [CodeunitName] that:
- Tests all public functions
- Includes positive and negative test cases
- Uses proper test isolation
- Follows BC test automation standards
```

### Create Test Data
```
Generate test data setup code that:
- Creates [entity] records
- Sets up relationships
- Handles cleanup
- Is reusable across tests
```

## Documentation Prompts

### Add XML Comments
```
Add comprehensive XML documentation comments to this AL code including:
- Summary of functionality
- Parameter descriptions
- Return value description
- Usage examples
```

### Create README
```
Create a README.md for this BC extension that includes:
- Overview of functionality
- Installation instructions
- Configuration steps
- Usage examples
- Dependencies
```

## API Integration Prompts

### Create API Page
```
Create an API page for [EntityName] that:
- Exposes necessary fields
- Uses proper OData annotations
- Includes proper filtering
- Follows BC API best practices
```

### Create Integration Code
```
Create integration code to:
- Connect to [external system]
- Handle authentication
- Process data exchange
- Include error handling and logging
```

## Best Practices Reminders

When generating AL code, always:
1. Use meaningful, descriptive names
2. Follow BC naming conventions (PascalCase for most identifiers)
3. Add XML documentation for public methods
4. Include error handling
5. Consider performance implications
6. Follow the single responsibility principle
7. Use proper indentation and formatting
8. Add comments for complex logic
9. Consider upgrade/compatibility implications
10. Follow security best practices

## Specific BC Patterns

### Confirm Dialog Pattern
```
Create a confirm dialog that:
- Asks user for confirmation before [action]
- Handles Yes/No response
- Provides clear message
```

### Progress Dialog Pattern
```
Create a progress dialog for [long-running operation] that:
- Shows progress percentage
- Allows cancellation
- Provides status updates
```

### Extension Pattern
```
Create a table extension for [base table] that:
- Adds custom fields
- Follows naming convention
- Includes proper data types
- Has appropriate captions
```
