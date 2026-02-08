# Business Central Helper Functions Library

This document contains commonly used helper functions for Business Central development.

## String Utilities

### Text Formatting
```al
/// <summary>
/// Format a currency amount with currency symbol
/// </summary>
procedure FormatCurrency(Amount: Decimal; CurrencyCode: Code[10]): Text
var
    Currency: Record Currency;
    AutoFormat: Codeunit "Auto Format";
begin
    if CurrencyCode = '' then
        exit(Format(Amount));
    
    if Currency.Get(CurrencyCode) then
        exit(Format(Amount, 0, AutoFormat.ResolveAutoFormat(Enum::"Auto Format"::AmountFormat, CurrencyCode)))
    else
        exit(Format(Amount));
end;

/// <summary>
/// Clean text by removing special characters
/// </summary>
procedure CleanText(InputText: Text): Text
var
    CleanedText: Text;
    i: Integer;
    Char: Char;
begin
    CleanedText := '';
    for i := 1 to StrLen(InputText) do begin
        Char := InputText[i];
        if Char in ['A'..'Z', 'a'..'z', '0'..'9', ' '] then
            CleanedText += Format(Char);
    end;
    exit(CleanedText.Trim());
end;

/// <summary>
/// Truncate text to maximum length with ellipsis
/// </summary>
procedure TruncateText(InputText: Text; MaxLength: Integer): Text
begin
    if StrLen(InputText) <= MaxLength then
        exit(InputText);
    
    exit(CopyStr(InputText, 1, MaxLength - 3) + '...');
end;
```

## Date and Time Utilities

```al
/// <summary>
/// Get start of month for a given date
/// </summary>
procedure GetMonthStart(InputDate: Date): Date
begin
    exit(CalcDate('<-CM>', InputDate));
end;

/// <summary>
/// Get end of month for a given date
/// </summary>
procedure GetMonthEnd(InputDate: Date): Date
begin
    exit(CalcDate('<CM>', InputDate));
end;

/// <summary>
/// Calculate business days between two dates (excluding weekends)
/// </summary>
procedure CalculateBusinessDays(StartDate: Date; EndDate: Date): Integer
var
    CurrentDate: Date;
    DayCount: Integer;
begin
    DayCount := 0;
    CurrentDate := StartDate;
    
    while CurrentDate <= EndDate do begin
        if not (Date2DWY(CurrentDate, 1) in [6, 7]) then // Not Saturday or Sunday
            DayCount += 1;
        CurrentDate := CalcDate('<+1D>', CurrentDate);
    end;
    
    exit(DayCount);
end;

/// <summary>
/// Check if date is a weekend
/// </summary>
procedure IsWeekend(CheckDate: Date): Boolean
begin
    exit(Date2DWY(CheckDate, 1) in [6, 7]); // Saturday or Sunday
end;

/// <summary>
/// Get fiscal year for a date
/// </summary>
procedure GetFiscalYear(InputDate: Date): Integer
var
    AccountingPeriod: Record "Accounting Period";
begin
    AccountingPeriod.SetFilter("Starting Date", '<=%1', InputDate);
    AccountingPeriod.SetRange("New Fiscal Year", true);
    if AccountingPeriod.FindLast() then
        exit(Date2DMY(AccountingPeriod."Starting Date", 3));
    
    exit(Date2DMY(InputDate, 3));
end;
```

## Number Utilities

```al
/// <summary>
/// Round to nearest currency amount (typically 0.01)
/// </summary>
procedure RoundCurrency(Amount: Decimal): Decimal
var
    Currency: Record Currency;
    GLSetup: Record "General Ledger Setup";
begin
    GLSetup.Get();
    if Currency.Get(GLSetup."LCY Code") then
        exit(Round(Amount, Currency."Amount Rounding Precision"))
    else
        exit(Round(Amount, 0.01));
end;

/// <summary>
/// Calculate percentage
/// </summary>
procedure CalculatePercentage(Part: Decimal; Total: Decimal): Decimal
begin
    if Total = 0 then
        exit(0);
    
    exit(Round((Part / Total) * 100, 0.01));
end;

/// <summary>
/// Apply percentage to amount
/// </summary>
procedure ApplyPercentage(Amount: Decimal; Percentage: Decimal): Decimal
begin
    exit(Round(Amount * (Percentage / 100), 0.01));
end;

/// <summary>
/// Check if number is within range
/// </summary>
procedure IsInRange(Value: Decimal; MinValue: Decimal; MaxValue: Decimal): Boolean
begin
    exit((Value >= MinValue) and (Value <= MaxValue));
end;
```

## Validation Utilities

```al
/// <summary>
/// Validate email address format
/// </summary>
procedure IsValidEmail(Email: Text): Boolean
var
    AtPos: Integer;
    DotPos: Integer;
begin
    if Email = '' then
        exit(false);
    
    AtPos := StrPos(Email, '@');
    if AtPos <= 1 then
        exit(false);
    
    DotPos := StrPos(CopyStr(Email, AtPos, StrLen(Email) - AtPos + 1), '.');
    if DotPos <= 2 then
        exit(false);
    
    exit(true);
end;

/// <summary>
/// Validate phone number (basic validation)
/// </summary>
procedure IsValidPhoneNumber(PhoneNo: Text): Boolean
var
    CleanNumber: Text;
    i: Integer;
    Char: Char;
begin
    if PhoneNo = '' then
        exit(false);
    
    CleanNumber := '';
    for i := 1 to StrLen(PhoneNo) do begin
        Char := PhoneNo[i];
        if Char in ['0'..'9'] then
            CleanNumber += Format(Char);
    end;
    
    exit(StrLen(CleanNumber) >= 10); // At least 10 digits
end;

/// <summary>
/// Validate that required fields are filled
/// </summary>
procedure ValidateRequiredFields(RecRef: RecordRef; FieldNos: List of [Integer])
var
    FieldRef: FieldRef;
    FieldNo: Integer;
    EmptyValue: Variant;
begin
    foreach FieldNo in FieldNos do begin
        FieldRef := RecRef.Field(FieldNo);
        EmptyValue := FieldRef.Value;
        if Format(EmptyValue) = '' then
            Error('Field %1 must have a value', FieldRef.Caption);
    end;
end;
```

## File and Export Utilities

```al
/// <summary>
/// Export data to CSV
/// </summary>
procedure ExportToCSV(var TempBlob: Codeunit "Temp Blob"; Headers: List of [Text]; Data: List of [List of [Text]])
var
    OutStream: OutStream;
    Header: Text;
    Row: List of [Text];
    Value: Text;
    Line: Text;
begin
    TempBlob.CreateOutStream(OutStream);
    
    // Write headers
    Line := '';
    foreach Header in Headers do begin
        if Line <> '' then
            Line += ',';
        Line += '"' + Header.Replace('"', '""') + '"';
    end;
    OutStream.WriteText(Line);
    OutStream.WriteText();
    
    // Write data rows
    foreach Row in Data do begin
        Line := '';
        foreach Value in Row do begin
            if Line <> '' then
                Line += ',';
            Line += '"' + Value.Replace('"', '""') + '"';
        end;
        OutStream.WriteText(Line);
        OutStream.WriteText();
    end;
end;

/// <summary>
/// Generate unique filename with timestamp
/// </summary>
procedure GenerateFileName(BaseFileName: Text; Extension: Text): Text
var
    Timestamp: Text;
begin
    Timestamp := Format(CurrentDateTime, 0, '<Year4><Month,2><Day,2>_<Hours24><Minutes,2><Seconds,2>');
    exit(StrSubstNo('%1_%2.%3', BaseFileName, Timestamp, Extension));
end;
```

## JSON Utilities

```al
/// <summary>
/// Safe get text value from JSON object
/// </summary>
procedure GetJsonText(JsonObj: JsonObject; PropertyName: Text): Text
var
    JsonToken: JsonToken;
begin
    if JsonObj.Get(PropertyName, JsonToken) then
        if not JsonToken.AsValue().IsNull() then
            exit(JsonToken.AsValue().AsText());
    
    exit('');
end;

/// <summary>
/// Safe get integer value from JSON object
/// </summary>
procedure GetJsonInteger(JsonObj: JsonObject; PropertyName: Text): Integer
var
    JsonToken: JsonToken;
begin
    if JsonObj.Get(PropertyName, JsonToken) then
        if not JsonToken.AsValue().IsNull() then
            exit(JsonToken.AsValue().AsInteger());
    
    exit(0);
end;

/// <summary>
/// Safe get decimal value from JSON object
/// </summary>
procedure GetJsonDecimal(JsonObj: JsonObject; PropertyName: Text): Decimal
var
    JsonToken: JsonToken;
begin
    if JsonObj.Get(PropertyName, JsonToken) then
        if not JsonToken.AsValue().IsNull() then
            exit(JsonToken.AsValue().AsDecimal());
    
    exit(0);
end;

/// <summary>
/// Convert JsonObject to Text
/// </summary>
procedure JsonObjectToText(JsonObj: JsonObject): Text
var
    JsonText: Text;
begin
    JsonObj.WriteTo(JsonText);
    exit(JsonText);
end;
```

## Dialog and User Interaction

```al
/// <summary>
/// Show progress dialog
/// </summary>
procedure ShowProgress(CurrentStep: Integer; TotalSteps: Integer; Message: Text)
var
    ProgressDialog: Dialog;
    ProgressPercent: Integer;
begin
    ProgressPercent := Round((CurrentStep / TotalSteps) * 100, 1);
    
    if not ProgressDialog.Open(StrSubstNo('%1\Progress: @2@@@@@@@', Message)) then
        exit;
    
    ProgressDialog.Update(2, ProgressPercent * 100); // Dialog expects 0-10000
end;

/// <summary>
/// Confirm with default button
/// </summary>
procedure ConfirmWithDefault(Question: Text; DefaultYes: Boolean): Boolean
begin
    exit(Confirm(Question, DefaultYes));
end;

/// <summary>
/// Show warning message
/// </summary>
procedure ShowWarning(WarningText: Text)
begin
    Message('WARNING: %1', WarningText);
end;
```

## Error Handling

```al
/// <summary>
/// Try-catch pattern for error handling
/// </summary>
procedure TryExecute(var ErrorMessage: Text): Boolean
var
    ExecutionSuccessful: Boolean;
begin
    ClearLastError();
    ExecutionSuccessful := false;
    
    if not GuiAllowed then begin
        // Run directly without error suppression
        DoExecute();
        exit(true);
    end;
    
    // Use ASSERTERROR for controlled error handling
    Commit();
    if not Codeunit.Run(Codeunit::"My Processing Codeunit") then begin
        ErrorMessage := GetLastErrorText();
        exit(false);
    end;
    
    exit(true);
end;

/// <summary>
/// Log error with context
/// </summary>
procedure LogError(ErrorMessage: Text; Context: Text)
var
    ActivityLog: Record "Activity Log";
begin
    ActivityLog.LogActivity(
        ActivityLog,
        ActivityLog.Status::Failed,
        'Error Log',
        ErrorMessage,
        Context);
end;
```

## Batch Processing

```al
/// <summary>
/// Process records in batches
/// </summary>
procedure ProcessInBatches(var RecRef: RecordRef; BatchSize: Integer)
var
    Counter: Integer;
begin
    Counter := 0;
    
    if RecRef.FindSet() then
        repeat
            ProcessRecord(RecRef);
            Counter += 1;
            
            if Counter mod BatchSize = 0 then
                Commit(); // Commit after each batch
        until RecRef.Next() = 0;
end;

/// <summary>
/// Execute with retry logic
/// </summary>
procedure ExecuteWithRetry(MaxAttempts: Integer): Boolean
var
    Attempt: Integer;
    Success: Boolean;
begin
    for Attempt := 1 to MaxAttempts do begin
        Success := TryExecute();
        if Success then
            exit(true);
        
        if Attempt < MaxAttempts then
            Sleep(1000 * Attempt); // Exponential backoff
    end;
    
    exit(false);
end;

local procedure TryExecute(): Boolean
begin
    // Implementation
    exit(true);
end;

local procedure ProcessRecord(var RecRef: RecordRef)
begin
    // Implementation
end;
```

## Usage Examples

### Example 1: Data Export
```al
procedure ExportCustomers()
var
    Customer: Record Customer;
    TempBlob: Codeunit "Temp Blob";
    Headers: List of [Text];
    Data: List of [List of [Text]];
    Row: List of [Text];
    FileName: Text;
begin
    Headers.Add('No.');
    Headers.Add('Name');
    Headers.Add('Balance');
    
    if Customer.FindSet() then
        repeat
            Clear(Row);
            Row.Add(Customer."No.");
            Row.Add(Customer.Name);
            Row.Add(Format(Customer."Balance (LCY)"));
            Data.Add(Row);
        until Customer.Next() = 0;
    
    ExportToCSV(TempBlob, Headers, Data);
    FileName := GenerateFileName('Customers', 'csv');
    // Download or save file
end;
```

### Example 2: Validation
```al
procedure ValidateCustomerData(var Customer: Record Customer)
begin
    if not IsValidEmail(Customer."E-Mail") then
        Error('Invalid email address');
    
    if not IsValidPhoneNumber(Customer."Phone No.") then
        Error('Invalid phone number');
    
    if Customer."Balance (LCY)" > Customer."Credit Limit (LCY)" then
        ShowWarning('Customer exceeds credit limit');
end;
```

## Best Practices

1. **Error Handling**: Always handle errors gracefully
2. **Performance**: Use batch processing for large datasets
3. **Validation**: Validate input data before processing
4. **Logging**: Log important operations and errors
5. **User Feedback**: Provide clear feedback to users
6. **Reusability**: Create generic, reusable functions
7. **Documentation**: Document all public procedures
8. **Testing**: Test helper functions thoroughly
