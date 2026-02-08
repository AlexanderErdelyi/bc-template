# GitHub Copilot Instructions for BC Development

## Purpose
These instructions guide GitHub Copilot in generating high-quality Business Central AL code that follows best practices and organizational standards.

## General Instructions

### Code Style and Formatting
1. **Indentation**: Use 4 spaces for indentation (consistent with AL Language settings)
2. **Line Length**: Keep lines under 120 characters when possible
3. **Naming Conventions**:
   - PascalCase for object names, procedure names, and most identifiers
   - camelCase for local variables (or PascalCase, be consistent within project)
   - Use meaningful, descriptive names that clearly indicate purpose
   - Avoid abbreviations unless they are widely understood (e.g., No. for Number)

### Code Structure
1. **Organization**: Group related procedures and fields logically
2. **Comments**: Add XML documentation for public procedures
3. **Regions**: Use regions to organize code sections in large objects
4. **Dependencies**: Minimize coupling between objects
5. **Reusability**: Create utility functions for commonly used logic

### AL Language Best Practices

#### Variables
```al
// Good: Clear, descriptive names
local procedure CalculateTotalAmount(SalesLine: Record "Sales Line") TotalAmount: Decimal
var
    TaxCalculator: Codeunit "Tax Calculator";
    TaxAmount: Decimal;
begin
    TaxAmount := TaxCalculator.CalculateTax(SalesLine."Line Amount");
    TotalAmount := SalesLine."Line Amount" + TaxAmount;
end;

// Bad: Unclear abbreviations
local procedure CalcAmt(SL: Record "Sales Line") Amt: Decimal
var
    TC: Codeunit "Tax Calculator";
    T: Decimal;
begin
    T := TC.Calc(SL."Line Amount");
    Amt := SL."Line Amount" + T;
end;
```

#### Error Handling
```al
// Always provide context in error messages
if Customer."Credit Limit (LCY)" < TotalAmount then
    Error('Customer %1 has insufficient credit limit. Limit: %2, Required: %3',
        Customer."No.", Customer."Credit Limit (LCY)", TotalAmount);

// Use Error for critical errors that should stop execution
// Use Message for informational messages
// Use Confirm for user decisions
```

#### Database Operations
```al
// Good: Use SETRANGE for equality comparisons
SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
SalesLine.SetRange("Document No.", DocumentNo);
if SalesLine.FindSet() then
    repeat
        // Process each line
    until SalesLine.Next() = 0;

// Bad: Use SETFILTER only when necessary (patterns, ranges)
SalesLine.SetFilter("Document Type", Format(SalesLine."Document Type"::Order));
```

#### Performance Considerations
```al
// Use temporary tables for intermediate results
local procedure ProcessLargeDataset()
var
    TempResult: Record "Result Buffer" temporary;
begin
    // Process data into temporary table
    // Then bulk insert/update to database
end;

// Use FINDSET for reading multiple records
// Use FINDFIRST when you only need the first record
// Use GET for primary key lookups
```

### Object-Specific Guidelines

#### Tables
```al
table 50100 "Custom Entity"
{
    Caption = 'Custom Entity';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(10; "Created Date"; Date)
        {
            Caption = 'Created Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Description) { }
    }

    trigger OnInsert()
    begin
        if "Created Date" = 0D then
            "Created Date" := Today();
    end;
}
```

#### Pages
```al
page 50100 "Custom Entity Card"
{
    PageType = Card;
    SourceTable = "Custom Entity";
    Caption = 'Custom Entity Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the entity.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the entity.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(DoSomething)
            {
                ApplicationArea = All;
                Caption = 'Do Something';
                ToolTip = 'Performs some action on this entity.';
                Image = Action;

                trigger OnAction()
                begin
                    Message('Action executed');
                end;
            }
        }
    }
}
```

#### Codeunits
```al
codeunit 50100 "Custom Business Logic"
{
    /// <summary>
    /// Calculates the total amount for the given document.
    /// </summary>
    /// <param name="DocumentNo">The document number to calculate.</param>
    /// <returns>The calculated total amount.</returns>
    procedure CalculateDocumentTotal(DocumentNo: Code[20]): Decimal
    var
        SalesLine: Record "Sales Line";
        TotalAmount: Decimal;
    begin
        TotalAmount := 0;
        SalesLine.SetRange("Document No.", DocumentNo);
        if SalesLine.FindSet() then
            repeat
                TotalAmount += SalesLine."Line Amount";
            until SalesLine.Next() = 0;
        exit(TotalAmount);
    end;

    local procedure ValidateInput(InputValue: Text)
    begin
        if InputValue = '' then
            Error('Input value cannot be empty');
    end;
}
```

### Testing Guidelines

#### Test Codeunits
```al
codeunit 50101 "Custom Entity Tests"
{
    Subtype = Test;

    [Test]
    procedure TestCreateEntity()
    var
        CustomEntity: Record "Custom Entity";
    begin
        // [GIVEN] A new custom entity
        CustomEntity.Init();
        CustomEntity."No." := 'TEST001';
        CustomEntity.Description := 'Test Entity';

        // [WHEN] The entity is inserted
        CustomEntity.Insert(true);

        // [THEN] The created date should be set
        CustomEntity.TestField("Created Date");
    end;
}
```

### Security Guidelines

1. **Data Classification**: Always specify DataClassification for fields
2. **Permissions**: Design granular permission sets
3. **Input Validation**: Validate all user inputs
4. **Sensitive Data**: Use encryption for passwords and secrets
5. **API Security**: Implement proper authentication for APIs

### Documentation Standards

1. **XML Comments**: Add for all public procedures
2. **ToolTips**: Add for all page fields and actions
3. **Captions**: Provide meaningful captions for all objects and fields
4. **README**: Include setup and usage instructions
5. **Change Log**: Maintain version history

### Integration Patterns

#### API Pages
```al
page 50150 "Custom API"
{
    PageType = API;
    APIPublisher = 'company';
    APIGroup = 'custom';
    APIVersion = 'v1.0';
    EntityName = 'customEntity';
    EntitySetName = 'customEntities';
    SourceTable = "Custom Entity";
    DelayedInsert = true;
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            field(id; Rec.SystemId)
            {
                Caption = 'Id';
                Editable = false;
            }
            field(number; Rec."No.")
            {
                Caption = 'Number';
            }
            field(description; Rec.Description)
            {
                Caption = 'Description';
            }
        }
    }
}
```

### Version Control Best Practices

1. **Commit Messages**: Use clear, descriptive commit messages
2. **Small Changes**: Commit small, logical units of work
3. **Branching**: Use feature branches for development
4. **Pull Requests**: Always use PR reviews before merging
5. **Tags**: Tag releases with version numbers

### Performance Optimization

1. **Minimize Database Calls**: Batch operations when possible
2. **Use Temporary Tables**: For intermediate calculations
3. **Optimize Filters**: Use SETRANGE over SETFILTER
4. **Avoid Loops**: Use bulk operations when available
5. **Profile Code**: Identify and fix bottlenecks

### Common Patterns to Use

#### Singleton Pattern
```al
codeunit 50102 "Configuration Manager"
{
    SingleInstance = true;

    var
        ConfigurationLoaded: Boolean;

    procedure GetConfiguration(): Text
    begin
        if not ConfigurationLoaded then
            LoadConfiguration();
        // Return configuration
    end;

    local procedure LoadConfiguration()
    begin
        // Load configuration once
        ConfigurationLoaded := true;
    end;
}
```

#### Factory Pattern
```al
codeunit 50103 "Document Factory"
{
    procedure CreateDocument(DocumentType: Enum "Document Type"): Interface "IDocument"
    var
        SalesDocument: Codeunit "Sales Document";
        PurchaseDocument: Codeunit "Purchase Document";
    begin
        case DocumentType of
            DocumentType::Sales:
                exit(SalesDocument);
            DocumentType::Purchase:
                exit(PurchaseDocument);
        end;
    end;
}
```

### Anti-Patterns to Avoid

1. **Magic Numbers**: Use constants or enums instead
2. **Deep Nesting**: Keep nesting levels shallow
3. **Global Variables**: Minimize use of global variables
4. **Copy-Paste Code**: Create reusable procedures
5. **Ignoring Errors**: Always handle errors appropriately

## Copilot Usage Tips

### Effective Prompting
- Be specific about requirements
- Mention BC version if relevant
- Specify object types needed
- Include example data if helpful
- Request specific patterns or practices

### Code Review
- Ask Copilot to review for best practices
- Check for performance issues
- Verify error handling
- Validate naming conventions
- Ensure proper documentation

### Refactoring
- Request modernization of legacy code
- Ask for performance optimization
- Request improved error handling
- Ask for better code organization
- Request addition of documentation

## Resources

- [Microsoft BC Documentation](https://docs.microsoft.com/dynamics365/business-central/)
- [AL Language Reference](https://docs.microsoft.com/dynamics365/business-central/dev-itpro/developer/devenv-reference-overview)
- [BC Tech Community](https://community.dynamics.com/business)
- [GitHub BC Samples](https://github.com/microsoft/BCTech)
