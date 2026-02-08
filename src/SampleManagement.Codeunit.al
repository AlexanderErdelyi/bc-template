/// <summary>
/// Business logic codeunit for Sample Master operations
/// </summary>
codeunit 50100 "Sample Management"
{
    /// <summary>
    /// Process a sample record
    /// </summary>
    /// <param name="SampleMaster">The record to process</param>
    procedure ProcessRecord(var SampleMaster: Record "Sample Master")
    begin
        ValidateRecord(SampleMaster);
        
        // Add your processing logic here
        
        SampleMaster.Status := SampleMaster.Status::"In Progress";
        SampleMaster.Modify(true);
        
        Message('Record %1 has been processed successfully.', SampleMaster."No.");
    end;

    /// <summary>
    /// Validate a sample record before processing
    /// </summary>
    /// <param name="SampleMaster">The record to validate</param>
    local procedure ValidateRecord(SampleMaster: Record "Sample Master")
    begin
        SampleMaster.TestField("No.");
        SampleMaster.TestField(Description);
        
        if SampleMaster.Status = SampleMaster.Status::Completed then
            Error('Cannot process a completed record.');
    end;

    /// <summary>
    /// Complete a sample record
    /// </summary>
    /// <param name="SampleMaster">The record to complete</param>
    procedure CompleteRecord(var SampleMaster: Record "Sample Master")
    begin
        if SampleMaster.Status <> SampleMaster.Status::"In Progress" then
            Error('Only records in progress can be completed.');
        
        SampleMaster.Status := SampleMaster.Status::Completed;
        SampleMaster.Modify(true);
        
        Message('Record %1 has been completed.', SampleMaster."No.");
    end;

    /// <summary>
    /// Cancel a sample record
    /// </summary>
    /// <param name="SampleMaster">The record to cancel</param>
    procedure CancelRecord(var SampleMaster: Record "Sample Master")
    begin
        if not Confirm('Are you sure you want to cancel record %1?', false, SampleMaster."No.") then
            exit;
        
        SampleMaster.Status := SampleMaster.Status::Cancelled;
        SampleMaster.Modify(true);
        
        Message('Record %1 has been cancelled.', SampleMaster."No.");
    end;
}
