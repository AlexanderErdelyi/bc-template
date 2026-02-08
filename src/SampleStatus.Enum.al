/// <summary>
/// Status enum for sample records
/// </summary>
enum 50100 "Sample Status"
{
    Extensible = true;

    value(0; New)
    {
        Caption = 'New';
    }
    value(1; "In Progress")
    {
        Caption = 'In Progress';
    }
    value(2; Completed)
    {
        Caption = 'Completed';
    }
    value(3; Cancelled)
    {
        Caption = 'Cancelled';
    }
}
