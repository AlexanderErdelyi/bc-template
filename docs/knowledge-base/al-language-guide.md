# Business Central Knowledge Base

## Table of Contents
1. [AL Language Basics](#al-language-basics)
2. [Object Types](#object-types)
3. [Common Patterns](#common-patterns)
4. [Integration Techniques](#integration-techniques)
5. [Troubleshooting](#troubleshooting)

## AL Language Basics

### Data Types
- **Text**: Variable-length strings (max 2048 characters)
- **Code**: Used for identifiers (faster than Text)
- **Integer**: Whole numbers (-2,147,483,648 to 2,147,483,647)
- **Decimal**: Numeric values with decimals
- **Boolean**: True or False
- **Date**: Date values
- **DateTime**: Date and time values
- **Time**: Time values
- **GUID**: Globally unique identifiers
- **RecordId**: Reference to any record in any table
- **Option**: Enumeration of predefined values (legacy, use Enum instead)
- **Enum**: Modern enumeration type

### System Functions

#### String Manipulation
```al
// String length
len := StrLen(myString);

// Substring
substring := CopyStr(myString, startPos, length);

// Find position
pos := StrPos(myString, searchString);

// Convert to uppercase/lowercase
upperText := UpperCase(myString);
lowerText := LowerCase(myString);

// Replace text
newText := myString.Replace(oldValue, newValue);

// Format strings
formatted := StrSubstNo('Customer %1 has balance %2', custNo, balance);
```

#### Date/Time Functions
```al
// Current date and time
currentDate := Today();
currentDateTime := CurrentDateTime();
currentTime := Time();

// Date calculations
futureDate := CalcDate('<+7D>', Today()); // Add 7 days
pastDate := CalcDate('<-1M>', Today()); // Subtract 1 month

// Date formula
dateFormula := '<+1Y>'; // Add 1 year
```

#### Number Functions
```al
// Rounding
rounded := Round(amount, 0.01); // Round to 2 decimals

// Absolute value
absValue := Abs(number);

// Power
result := Power(base, exponent);
```

### Control Structures

#### If-Then-Else
```al
if condition then
    statement
else
    statement;

// Multiple conditions
if (condition1) and (condition2) then
    statement
else if condition3 then
    statement
else
    statement;
```

#### Case Statement
```al
case Status of
    Status::New:
        HandleNewStatus();
    Status::"In Progress":
        HandleInProgress();
    Status::Completed:
        HandleCompleted();
    else
        HandleUnknownStatus();
end;
```

#### Loops
```al
// For loop
for i := 1 to 10 do
    ProcessItem(i);

// While loop
while condition do
    statement;

// Repeat-Until loop
repeat
    statement;
until condition;

// Record loop
if Customer.FindSet() then
    repeat
        ProcessCustomer(Customer);
    until Customer.Next() = 0;
```

## Object Types

### Tables
Tables store data in BC. They are the foundation of the data model.

**Key Concepts:**
- Fields: Define the structure
- Keys: Define how data is indexed
- Triggers: OnInsert, OnModify, OnDelete, OnRename
- Table Relations: Define relationships between tables
- FlowFields: Calculated fields
- FlowFilters: Filter fields for FlowField calculations

**Example:**
```al
table 50100 "My Table"
{
    fields
    {
        field(1; "Primary Key"; Code[20]) { }
        field(2; Description; Text[100]) { }
        field(10; Amount; Decimal) { }
    }
    
    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}
```

### Pages
Pages define the user interface.

**Page Types:**
- Card: Display single record
- List: Display multiple records
- Document: Header-lines pattern
- ListPlus: List with details
- Worksheet: Data entry grid
- RoleCenter: Home page
- API: RESTful API endpoint

**Example:**
```al
page 50100 "My Card"
{
    PageType = Card;
    SourceTable = "My Table";
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Primary Key"; Rec."Primary Key") { }
                field(Description; Rec.Description) { }
            }
        }
    }
    
    actions
    {
        area(Processing)
        {
            action(DoSomething)
            {
                trigger OnAction()
                begin
                    Message('Action executed');
                end;
            }
        }
    }
}
```

### Codeunits
Codeunits contain business logic.

**Types:**
- Normal: Business logic
- Test: Unit tests
- Install: Installation code
- Upgrade: Upgrade logic

**Example:**
```al
codeunit 50100 "My Business Logic"
{
    procedure DoSomething()
    begin
        // Business logic here
    end;
}
```

### Reports
Reports generate output (RDLC or Word layouts).

**Components:**
- Data items: Define data to retrieve
- Request page: User input
- Layout: RDLC or Word template

### Queries
Queries provide read-only data access with joins and aggregations.

**Example:**
```al
query 50100 "Sales by Customer"
{
    QueryType = Normal;
    
    elements
    {
        dataitem(Customer; Customer)
        {
            column(Customer_No; "No.")
            column(Name; Name)
            
            dataitem(Sales_Line; "Sales Line")
            {
                DataItemLink = "Sell-to Customer No." = Customer."No.";
                column(Sum_Amount; Amount)
                {
                    Method = Sum;
                }
            }
        }
    }
}
```

### XMLports
XMLports handle data import/export.

**Formats:**
- XML
- CSV
- Fixed text

## Common Patterns

### Number Series Pattern
```al
procedure AssignNo()
var
    NoSeriesMgt: Codeunit NoSeriesManagement;
    Setup: Record "My Setup";
begin
    if "No." = '' then begin
        Setup.Get();
        Setup.TestField("No. Series");
        NoSeriesMgt.InitSeries(Setup."No. Series", xRec."No. Series", 0D, "No.", "No. Series");
    end;
end;
```

### Document Header-Lines Pattern
```al
// Header table
table 50100 "My Document Header"
{
    fields
    {
        field(1; "No."; Code[20]) { }
        // Other header fields
    }
}

// Lines table
table 50101 "My Document Line"
{
    fields
    {
        field(1; "Document No."; Code[20])
        {
            TableRelation = "My Document Header";
        }
        field(2; "Line No."; Integer) { }
        // Other line fields
    }
    
    keys
    {
        key(PK; "Document No.", "Line No.") { }
    }
}
```

### Status Flow Pattern
```al
enum 50100 "Document Status"
{
    value(0; Open) { }
    value(1; "Pending Approval") { }
    value(2; Approved) { }
    value(3; Posted) { }
}

procedure Release()
begin
    TestField(Status, Status::Open);
    // Validate document
    Status := Status::"Pending Approval";
    Modify(true);
end;
```

### Event Pattern
```al
// Publisher
codeunit 50100 "Event Publisher"
{
    [IntegrationEvent(false, false)]
    procedure OnBeforePost(var SalesHeader: Record "Sales Header")
    begin
    end;
}

// Subscriber
codeunit 50101 "Event Subscriber"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Event Publisher", 'OnBeforePost', '', false, false)]
    local procedure HandleBeforePost(var SalesHeader: Record "Sales Header")
    begin
        // Custom logic
    end;
}
```

## Integration Techniques

### REST API
```al
procedure CallExternalAPI()
var
    Client: HttpClient;
    Response: HttpResponseMessage;
    Content: HttpContent;
    JsonResponse: JsonObject;
    ResponseText: Text;
begin
    Client.Get('https://api.example.com/data', Response);
    
    if Response.IsSuccessStatusCode() then begin
        Response.Content().ReadAs(ResponseText);
        JsonResponse.ReadFrom(ResponseText);
        // Process JSON
    end else
        Error('API call failed: %1', Response.ReasonPhrase());
end;
```

### JSON Processing
```al
procedure ProcessJson()
var
    JsonObject: JsonObject;
    JsonToken: JsonToken;
    JsonArray: JsonArray;
    TextValue: Text;
begin
    // Read JSON
    JsonObject.ReadFrom('{"name":"John","age":30}');
    
    // Get value
    if JsonObject.Get('name', JsonToken) then
        TextValue := JsonToken.AsValue().AsText();
    
    // Create JSON
    JsonObject := JsonObject.JsonObject();
    JsonObject.Add('name', 'John');
    JsonObject.Add('age', 30);
end;
```

### XML Processing
```al
procedure ProcessXml()
var
    XmlDoc: XmlDocument;
    XmlNode: XmlNode;
    XmlElement: XmlElement;
begin
    // Read XML
    XmlDocument.ReadFrom('<root><item>Value</item></root>', XmlDoc);
    
    // Navigate XML
    if XmlDoc.SelectSingleNode('/root/item', XmlNode) then begin
        XmlElement := XmlNode.AsXmlElement();
        // Process element
    end;
end;
```

## Troubleshooting

### Common Issues

#### Issue: Record not found
```al
// Bad - throws error if not found
Customer.Get(CustomerNo);

// Good - handles case when not found
if Customer.Get(CustomerNo) then
    // Process customer
else
    Error('Customer %1 not found', CustomerNo);
```

#### Issue: Permission errors
- Check permission sets
- Verify object permissions
- Check table data permissions
- Test with actual user roles

#### Issue: Performance problems
- Use SETRANGE instead of SETFILTER
- Avoid unnecessary CALCFIELDS
- Use proper keys
- Minimize database calls
- Use temporary tables

#### Issue: Locking conflicts
- Keep transactions short
- Use proper isolation levels
- Handle lock timeouts
- Consider using job queues

### Debugging Techniques

#### Using Debugger
1. Set breakpoints in code
2. Start debugging session
3. Inspect variables
4. Step through code
5. Watch expressions

#### Logging
```al
procedure LogOperation(Message: Text)
var
    ActivityLog: Record "Activity Log";
begin
    ActivityLog.LogActivity(
        Rec.RecordId(),
        ActivityLog.Status::Success,
        'My Extension',
        Message,
        '');
end;
```

#### Session Telemetry
Use Application Insights for production monitoring.

### Performance Analysis

#### Using Database Statistics
```al
// Enable statistics
Database.EnableStatistics();

// Your code here

// Get statistics
stats := Database.Statistics();
```

#### Query Analysis
- Use SQL Profiler
- Check execution plans
- Identify missing indexes
- Optimize filters

## Additional Resources

### Official Documentation
- [AL Language Reference](https://docs.microsoft.com/dynamics365/business-central/dev-itpro/developer/devenv-reference-overview)
- [AL Development Environment](https://docs.microsoft.com/dynamics365/business-central/dev-itpro/developer/devenv-dev-overview)

### Community Resources
- [BC Tech Community](https://community.dynamics.com/business)
- [GitHub BC Samples](https://github.com/microsoft/BCTech)
- [BC User Group](https://www.bcusergroup.com/)

### Learning Resources
- [Microsoft Learn](https://docs.microsoft.com/learn/dynamics365/business-central)
- [BC Developer Blog](https://cloudblogs.microsoft.com/dynamics365/author/business-central/)
