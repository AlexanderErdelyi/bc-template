# Business Central Code Guidelines

## Table of Contents
1. [Naming Conventions](#naming-conventions)
2. [Code Structure](#code-structure)
3. [Best Practices](#best-practices)
4. [Performance Guidelines](#performance-guidelines)
5. [Security Guidelines](#security-guidelines)
6. [Testing Standards](#testing-standards)

## Naming Conventions

### Objects
- **Tables**: Use singular nouns (e.g., `Customer`, `Sales Header`)
- **Pages**: Include type in name (e.g., `Customer Card`, `Sales Order List`)
- **Codeunits**: Use descriptive names ending with purpose (e.g., `Sales-Post`, `Customer Management`)
- **Reports**: Descriptive names (e.g., `Customer - List`, `Sales Statistics`)
- **Queries**: Descriptive names indicating data retrieved (e.g., `Sales by Customer`)

### Fields and Variables
- **Fields**: PascalCase with spaces (e.g., `Customer No.`, `Posting Date`)
- **Variables**: camelCase or PascalCase (be consistent)
- **Parameters**: Match variable naming convention
- **Constants**: UPPERCASE_WITH_UNDERSCORES or PascalCase

### Examples
```al
// Good naming
table 50100 "Sales Document"
{
    field(1; "Document No."; Code[20]) { }
}

procedure CalculateTotalAmount(SalesLine: Record "Sales Line"): Decimal
var
    totalAmount: Decimal;
    taxCalculator: Codeunit "Tax Calculator";
begin
    // Implementation
end;

// Bad naming
table 50100 "SalesDoc"
{
    field(1; "DocNo"; Code[20]) { }
}

procedure CalcAmt(SL: Record "Sales Line"): Decimal
var
    amt: Decimal;
    tc: Codeunit "Tax Calc";
begin
    // Implementation
end;
```

## Code Structure

### File Organization
Each AL file should contain a single object with proper header documentation:

```al
/// <summary>
/// Manages customer-related business logic.
/// </summary>
codeunit 50100 "Customer Management"
{
    // Public procedures first
    
    /// <summary>
    /// Validates customer credit limit.
    /// </summary>
    /// <param name="Customer">The customer to validate.</param>
    /// <returns>True if within limit, false otherwise.</returns>
    procedure ValidateCreditLimit(Customer: Record Customer): Boolean
    begin
        // Implementation
    end;

    // Local procedures after public
    local procedure CalculateCurrentBalance(CustomerNo: Code[20]): Decimal
    begin
        // Implementation
    end;

    // Variables at the end
    var
        Setup: Record "Sales & Receivables Setup";
}
```

### Procedure Organization
1. Public procedures first
2. Internal procedures
3. Local procedures
4. Event subscribers
5. Variable declarations

### Use of Regions
For large objects, use regions to organize code:

```al
codeunit 50100 "Large Business Logic"
{
    #region Public API
    
    procedure PublicMethod1()
    begin
    end;
    
    #endregion

    #region Internal Methods
    
    internal procedure InternalMethod1()
    begin
    end;
    
    #endregion

    #region Event Subscribers
    
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterCustomerInsert(var Rec: Record Customer)
    begin
    end;
    
    #endregion
}
```

## Best Practices

### 1. Error Handling
Always provide context in error messages:

```al
// Good
if Customer."Credit Limit (LCY)" < RequiredAmount then
    Error('Customer %1 has insufficient credit limit. Available: %2, Required: %3',
        Customer."No.",
        Customer."Credit Limit (LCY)",
        RequiredAmount);

// Bad
if Customer."Credit Limit (LCY)" < RequiredAmount then
    Error('Insufficient credit');
```

### 2. Input Validation
Validate all inputs at the entry point:

```al
procedure ProcessOrder(OrderNo: Code[20])
begin
    if OrderNo = '' then
        Error('Order number cannot be empty');
        
    if not SalesHeader.Get(SalesHeader."Document Type"::Order, OrderNo) then
        Error('Order %1 does not exist', OrderNo);
        
    // Process order
end;
```

### 3. Transaction Management
Keep transactions short and focused:

```al
// Good - Short transaction
procedure PostDocument(DocumentNo: Code[20])
begin
    ValidateDocument(DocumentNo); // Read-only, outside transaction
    
    // Short, focused transaction
    SalesHeader.Get(SalesHeader."Document Type"::Order, DocumentNo);
    SalesHeader.Status := SalesHeader.Status::Posted;
    SalesHeader.Modify(true);
end;

// Bad - Long transaction with multiple operations
procedure PostDocumentBad(DocumentNo: Code[20])
begin
    // Everything in one transaction
    SalesHeader.Get(SalesHeader."Document Type"::Order, DocumentNo);
    ValidateLines(); // This might take time
    CalculateComplexValues(); // This might take time
    SalesHeader.Status := SalesHeader.Status::Posted;
    SalesHeader.Modify(true);
end;
```

### 4. Use of Temporary Tables
Use temporary tables for intermediate processing:

```al
procedure CalculateStatistics()
var
    TempStatistics: Record "Statistics Buffer" temporary;
begin
    // Populate temporary table
    PopulateTempStatistics(TempStatistics);
    
    // Process and analyze
    ProcessStatistics(TempStatistics);
    
    // Update final results in one operation
    UpdateFinalResults(TempStatistics);
end;
```

### 5. Avoid Magic Numbers
Use constants or enums:

```al
// Good
procedure GetDocumentType(): Enum "Document Type"
begin
    exit("Document Type"::Order);
end;

// Bad
procedure GetDocumentType(): Integer
begin
    exit(1); // What does 1 mean?
end;
```

## Performance Guidelines

### 1. Database Operations

#### Use SETRANGE instead of SETFILTER
```al
// Good - Uses index efficiently
SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
SalesLine.SetRange("Document No.", DocumentNo);

// Bad - Cannot use index effectively
SalesLine.SetFilter("Document Type", '%1', SalesLine."Document Type"::Order);
```

#### Choose the Right Find Method
```al
// Use GET for primary key lookup
if Customer.Get(CustomerNo) then
    // Process

// Use FINDFIRST when you need only the first record
Customer.SetRange("Customer Posting Group", PostingGroup);
if Customer.FindFirst() then
    // Process first customer

// Use FINDSET when you need to process multiple records
Customer.SetRange("Customer Posting Group", PostingGroup);
if Customer.FindSet() then
    repeat
        // Process each customer
    until Customer.Next() = 0;
```

#### Limit CALCFIELDS Usage
```al
// Good - Only calculate when needed
Customer.Get(CustomerNo);
if ShowBalance then begin
    Customer.CalcFields("Balance (LCY)");
    DisplayBalance(Customer."Balance (LCY)");
end;

// Bad - Always calculates even if not used
Customer.Get(CustomerNo);
Customer.CalcFields("Balance (LCY)", "Net Change", "Sales (LCY)");
```

### 2. Loop Optimization
```al
// Good - Calculate outside loop
procedure ProcessItems()
var
    Item: Record Item;
    VATPercentage: Decimal;
begin
    VATPercentage := GetVATPercentage(); // Calculate once
    
    if Item.FindSet() then
        repeat
            CalculateItemPrice(Item, VATPercentage);
        until Item.Next() = 0;
end;

// Bad - Calculate inside loop
procedure ProcessItemsBad()
var
    Item: Record Item;
begin
    if Item.FindSet() then
        repeat
            CalculateItemPrice(Item, GetVATPercentage()); // Called repeatedly
        until Item.Next() = 0;
end;
```

### 3. Query Optimization
```al
// Good - Single query with filters
procedure GetFilteredCustomers(): List of [Code[20]]
var
    Customer: Record Customer;
    CustomerList: List of [Code[20]];
begin
    Customer.SetRange(Blocked, Customer.Blocked::" ");
    Customer.SetFilter("Balance (LCY)", '>0');
    if Customer.FindSet() then
        repeat
            CustomerList.Add(Customer."No.");
        until Customer.Next() = 0;
    exit(CustomerList);
end;

// Bad - Multiple queries
procedure GetFilteredCustomersBad(): List of [Code[20]]
var
    Customer: Record Customer;
    CustomerList: List of [Code[20]];
begin
    if Customer.FindSet() then
        repeat
            if (Customer.Blocked = Customer.Blocked::" ") and
               (Customer."Balance (LCY)" > 0) then
                CustomerList.Add(Customer."No.");
        until Customer.Next() = 0;
    exit(CustomerList);
end;
```

## Security Guidelines

### 1. Data Classification
Always specify data classification for fields:

```al
field(1; "Customer No."; Code[20])
{
    DataClassification = CustomerContent;
}

field(2; "Email"; Text[80])
{
    DataClassification = EndUserIdentifiableInformation;
}

field(3; "Credit Card No."; Text[20])
{
    DataClassification = CustomerContent;
    // Consider encryption for sensitive data
}
```

### 2. Permission Checks
```al
procedure DeleteCustomerData(CustomerNo: Code[20])
begin
    // Check permissions before sensitive operations
    if not GuiAllowed() then
        Error('This operation requires user interaction');
        
    if not Confirm('Delete all data for customer %1?', false, CustomerNo) then
        exit;
        
    // Proceed with deletion
end;
```

### 3. Input Validation
Validate and sanitize all inputs:

```al
procedure ProcessExternalData(InputData: Text)
begin
    if InputData = '' then
        Error('Input data cannot be empty');
        
    if StrLen(InputData) > 250 then
        Error('Input data exceeds maximum length');
        
    // Validate format
    if not ValidateFormat(InputData) then
        Error('Input data has invalid format');
        
    // Process validated data
end;
```

## Testing Standards

### 1. Test Structure
```al
codeunit 50101 "Customer Management Tests"
{
    Subtype = Test;

    [Test]
    procedure TestCreditLimitValidation()
    var
        Customer: Record Customer;
        CustomerManagement: Codeunit "Customer Management";
    begin
        // [GIVEN] A customer with specific credit limit
        CreateCustomerWithCreditLimit(Customer, 1000);

        // [WHEN] Validating an amount within limit
        // [THEN] Validation should pass
        Assert.IsTrue(
            CustomerManagement.ValidateCreditLimit(Customer, 900),
            'Should allow amount within credit limit');

        // [WHEN] Validating an amount exceeding limit
        // [THEN] Validation should fail
        Assert.IsFalse(
            CustomerManagement.ValidateCreditLimit(Customer, 1100),
            'Should reject amount exceeding credit limit');
    end;

    local procedure CreateCustomerWithCreditLimit(var Customer: Record Customer; CreditLimit: Decimal)
    begin
        Customer.Init();
        Customer."No." := LibraryUtility.GenerateGUID();
        Customer."Credit Limit (LCY)" := CreditLimit;
        Customer.Insert(true);
    end;
}
```

### 2. Test Isolation
Each test should be independent:

```al
[Test]
procedure TestSalesOrder()
var
    SalesHeader: Record "Sales Header";
begin
    // Create test data
    CreateTestSalesOrder(SalesHeader);
    
    // Test
    ProcessSalesOrder(SalesHeader);
    
    // Verify
    VerifyOrderProcessed(SalesHeader);
    
    // Cleanup happens automatically or explicitly
end;
```

### 3. Use Test Libraries
```al
codeunit 50102 "Test Library - Sales"
{
    procedure CreateSalesOrder(var SalesHeader: Record "Sales Header")
    begin
        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
        SalesHeader."No." := LibraryUtility.GenerateGUID();
        SalesHeader.Insert(true);
    end;

    procedure CreateSalesLine(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    begin
        SalesLine.Init();
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := GetNextLineNo(SalesHeader);
        SalesLine.Insert(true);
    end;
}
```

## Additional Resources

- [Microsoft BC Development Guidelines](https://docs.microsoft.com/dynamics365/business-central/dev-itpro/developer/devenv-dev-overview)
- [AL Language Reference](https://docs.microsoft.com/dynamics365/business-central/dev-itpro/developer/devenv-reference-overview)
- [BC Performance Guidelines](https://docs.microsoft.com/dynamics365/business-central/dev-itpro/performance/performance-overview)
