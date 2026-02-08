/// <summary>
/// Example table demonstrating BC table structure and best practices.
/// </summary>
table 50100 "Sample Master"
{
    Caption = 'Sample Master';
    DataClassification = CustomerContent;
    LookupPageId = "Sample Master List";
    DrillDownPageId = "Sample Master List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    NoSeriesMgt.TestManual(GetNoSeriesCode());
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
            DataClassification = CustomerContent;
        }
        field(10; Status; Enum "Sample Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(20; "Created Date"; Date)
        {
            Caption = 'Created Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(21; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
            TableRelation = User."User Name";
        }
        field(22; "Modified Date"; Date)
        {
            Caption = 'Modified Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(23; "Modified By"; Code[50])
        {
            Caption = 'Modified By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
            TableRelation = User."User Name";
        }
        field(100; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Key2; Description)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Description, Status)
        {
        }
        fieldgroup(Brick; "No.", Description, Status)
        {
        }
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            NoSeriesMgt.InitSeries(GetNoSeriesCode(), xRec."No. Series", 0D, "No.", "No. Series");
        end;

        InitRecord();
    end;

    trigger OnModify()
    begin
        UpdateModifiedFields();
    end;

    trigger OnDelete()
    begin
        // Add deletion checks here
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;

    /// <summary>
    /// Initialize record with default values
    /// </summary>
    local procedure InitRecord()
    begin
        "Created Date" := Today();
        "Created By" := UserId();
        Status := Status::New;
    end;

    /// <summary>
    /// Update modification tracking fields
    /// </summary>
    local procedure UpdateModifiedFields()
    begin
        "Modified Date" := Today();
        "Modified By" := UserId();
    end;

    /// <summary>
    /// Get the number series code for this table
    /// </summary>
    local procedure GetNoSeriesCode(): Code[20]
    var
        SampleSetup: Record "Sample Setup";
    begin
        SampleSetup.Get();
        exit(SampleSetup."Sample Nos.");
    end;
}
