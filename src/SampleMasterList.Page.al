/// <summary>
/// Sample Master List page
/// </summary>
page 50101 "Sample Master List"
{
    PageType = List;
    SourceTable = "Sample Master";
    Caption = 'Sample Master List';
    CardPageId = "Sample Master Card";
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the record.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the record.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the record.';
                }
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the record was created.';
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
            action(New)
            {
                ApplicationArea = All;
                Caption = 'New';
                ToolTip = 'Create a new record.';
                Image = New;
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page "Sample Master Card";
                RunPageMode = Create;
            }
        }
    }
}
