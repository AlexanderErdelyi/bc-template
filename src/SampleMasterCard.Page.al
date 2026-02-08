/// <summary>
/// Sample Master Card page
/// </summary>
page 50100 "Sample Master Card"
{
    PageType = Card;
    SourceTable = "Sample Master";
    Caption = 'Sample Master Card';
    UsageCategory = None;

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
                    ToolTip = 'Specifies the number of the record.';
                    
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the record.';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies additional description.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the record.';
                }
            }

            group(Tracking)
            {
                Caption = 'Tracking';

                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the record was created.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies who created the record.';
                }
                field("Modified Date"; Rec."Modified Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the record was last modified.';
                }
                field("Modified By"; Rec."Modified By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies who last modified the record.';
                }
            }
        }

        area(FactBoxes)
        {
            systempart(Control1; Links)
            {
                ApplicationArea = All;
            }
            systempart(Control2; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SetInProgress)
            {
                ApplicationArea = All;
                Caption = 'Set In Progress';
                ToolTip = 'Set the status to In Progress.';
                Image = Status;
                Promoted = true;
                PromotedCategory = Process;
                Enabled = Rec.Status = Rec.Status::New;

                trigger OnAction()
                begin
                    SetStatus(Rec.Status::"In Progress");
                end;
            }
            action(Complete)
            {
                ApplicationArea = All;
                Caption = 'Complete';
                ToolTip = 'Mark the record as completed.';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                Enabled = Rec.Status = Rec.Status::"In Progress";

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to complete this record?') then
                        SetStatus(Rec.Status::Completed);
                end;
            }
        }
        area(Navigation)
        {
            action(Related)
            {
                ApplicationArea = All;
                Caption = 'Related Records';
                ToolTip = 'View related records.';
                Image = ViewDetails;

                trigger OnAction()
                begin
                    Message('Show related records');
                end;
            }
        }
    }

    /// <summary>
    /// Set the status of the record
    /// </summary>
    /// <param name="NewStatus">The new status value</param>
    local procedure SetStatus(NewStatus: Enum "Sample Status")
    begin
        Rec.Status := NewStatus;
        Rec.Modify(true);
        CurrPage.Update(false);
    end;
}
